// lib/core/network/http_client.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';

// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'api_response.dart';
import 'http_logger.dart';

/// Token provider callback — implement this to supply dynamic auth tokens.
typedef TokenProvider = Future<String?> Function();

/// Base HTTP Client with logging, auth headers, error handling, & retries.
class HttpClient {
  final String baseUrl;
  final Duration timeout;
  final int maxRetries;
  final HttpLogger logger;
  final TokenProvider? tokenProvider;
  final Map<String, String> defaultHeaders;

  late final http.Client _client;

  HttpClient({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 30),
    this.maxRetries = 1,
    HttpLogger? logger,
    this.tokenProvider,
    Map<String, String>? defaultHeaders,
    http.Client? client,
    bool withCredentials = true,
  }) : logger = logger ?? const HttpLogger(),
       defaultHeaders =
           defaultHeaders ??
           {
             HttpHeaders.contentTypeHeader: ContentType.json.value,
             HttpHeaders.acceptHeader: ContentType.json.value,
           } {
    _client = client ?? http.Client();
    // if (kIsWeb && withCredentials && _client is BrowserClient) {
    //   (_client).withCredentials = true;
    // }
  }

  // ─── Public Methods ───────────────────────────────────────────────────────

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    T Function(dynamic json)? fromJson,
  }) async {
    final uri = _buildUri(path, queryParams);
    return _executeWithRetry(
      () => _request<T>(
        method: 'GET',
        uri: uri,
        headers: headers,
        fromJson: fromJson,
      ),
    );
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    T Function(dynamic json)? fromJson,
  }) async {
    final uri = _buildUri(path, queryParams);
    return _executeWithRetry(
      () => _request<T>(
        method: 'POST',
        uri: uri,
        body: body,
        headers: headers,
        fromJson: fromJson,
      ),
    );
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    T Function(dynamic json)? fromJson,
  }) async {
    final uri = _buildUri(path, queryParams);
    return _executeWithRetry(
      () => _request<T>(
        method: 'PUT',
        uri: uri,
        body: body,
        headers: headers,
        fromJson: fromJson,
      ),
    );
  }

  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    T Function(dynamic json)? fromJson,
  }) async {
    final uri = _buildUri(path, queryParams);
    return _executeWithRetry(
      () => _request<T>(
        method: 'PATCH',
        uri: uri,
        body: body,
        headers: headers,
        fromJson: fromJson,
      ),
    );
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    T Function(dynamic json)? fromJson,
  }) async {
    final uri = _buildUri(path, queryParams);
    return _executeWithRetry(
      () => _request<T>(
        method: 'DELETE',
        uri: uri,
        headers: headers,
        fromJson: fromJson,
      ),
    );
  }

  void dispose() => _client.close();

  // ─── Core Request Handler ─────────────────────────────────────────────────

  Future<ApiResponse<T>> _request<T>({
    required String method,
    required Uri uri,
    dynamic body,
    Map<String, String>? headers,
    T Function(dynamic json)? fromJson,
  }) async {
    final mergedHeaders = await _buildHeaders(headers);
    final encodedBody = body != null ? jsonEncode(body) : null;

    logger.logRequest(
      method: method,
      url: uri.toString(),
      headers: mergedHeaders,
      body: body,
    );

    final stopwatch = Stopwatch()..start();

    try {
      final response =
          await _sendRequest(
            method: method,
            uri: uri,
            headers: mergedHeaders,
            body: encodedBody,
          ).timeout(
            timeout,
            onTimeout: () {
              throw const NetworkException(message: 'Request timed out.');
            },
          );

      stopwatch.stop();

      final responseBody = _tryDecodeBody(response.body);

      logger.logResponse(
        statusCode: response.statusCode,
        url: uri.toString(),
        headers: response.headers,
        body: responseBody,
        duration: stopwatch.elapsed,
      );

      return _handleResponse<T>(response, responseBody, fromJson);
    } on ApiException {
      rethrow;
    } on SocketException catch (e, stack) {
      logger.logError(url: uri.toString(), error: e, stackTrace: stack);
      throw NetworkException(message: e.message);
    } on TimeoutException catch (e, stack) {
      logger.logError(url: uri.toString(), error: e, stackTrace: stack);
      throw const NetworkException(message: 'Connection timed out.');
    } catch (e, stack) {
      logger.logError(url: uri.toString(), error: e, stackTrace: stack);
      throw ApiException(message: e.toString());
    }
  }

  // ─── Response Handler ─────────────────────────────────────────────────────

  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    dynamic body,
    T Function(dynamic json)? fromJson,
  ) {
    final statusCode = response.statusCode;

    switch (statusCode) {
      case >= 200 && < 300:
        final data = (fromJson != null && body != null) ? fromJson(body) : null;
        return ApiResponse.success(statusCode: statusCode, data: data);

      case 401:
        throw ApiException(
          statusCode: statusCode,
          message: _extractMessage(body) ?? 'Unauthorized. Please login again.',
          data: body,
        );

      case 404:
        throw NotFoundException(
          message: _extractMessage(body) ?? 'Resource not found.',
        );

      case >= 400 && < 500:
        throw ApiException(
          statusCode: statusCode,
          message: _extractMessage(body) ?? 'Client error.',
          data: body,
        );

      case >= 500:
        throw ServerException(
          message: _extractMessage(body) ?? 'Server error.',
        );

      default:
        throw ApiException(
          statusCode: statusCode,
          message: 'Unexpected status code: $statusCode',
        );
    }
  }

  // ─── Retry Logic ──────────────────────────────────────────────────────────

  Future<ApiResponse<T>> _executeWithRetry<T>(
    Future<ApiResponse<T>> Function() request,
  ) async {
    int attempts = 0;
    while (true) {
      try {
        return await request();
      } on NetworkException {
        if (++attempts > maxRetries) rethrow;
        await Future.delayed(Duration(seconds: attempts));
      } on ServerException {
        if (++attempts > maxRetries) rethrow;
        await Future.delayed(Duration(seconds: attempts));
      } on ApiException {
        rethrow; // Do not retry 4xx errors
      }
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  Future<Map<String, String>> _buildHeaders(
    Map<String, String>? extraHeaders,
  ) async {
    final headers = Map<String, String>.from(defaultHeaders);

    if (tokenProvider != null) {
      final token = await tokenProvider!();
      if (token != null) {
        headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      }
    }

    if (extraHeaders != null) headers.addAll(extraHeaders);
    return headers;
  }

  Uri _buildUri(String path, Map<String, String>? queryParams) {
    final cleanBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    final uri = Uri.parse('$cleanBase$cleanPath');
    return queryParams != null && queryParams.isNotEmpty
        ? uri.replace(queryParameters: {...uri.queryParameters, ...queryParams})
        : uri;
  }

  Future<http.Response> _sendRequest({
    required String method,
    required Uri uri,
    required Map<String, String> headers,
    String? body,
  }) {
    switch (method.toUpperCase()) {
      case 'GET':
        return _client.get(uri, headers: headers);
      case 'POST':
        return _client.post(uri, headers: headers, body: body);
      case 'PUT':
        return _client.put(uri, headers: headers, body: body);
      case 'PATCH':
        return _client.patch(uri, headers: headers, body: body);
      case 'DELETE':
        return _client.delete(uri, headers: headers, body: body);
      default:
        throw ApiException(message: 'Unsupported HTTP method: $method');
    }
  }

  dynamic _tryDecodeBody(String body) {
    if (body.isEmpty) return null;
    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  String? _extractMessage(dynamic body) {
    if (body is Map) {
      return body['message']?.toString() ??
          body['error']?.toString() ??
          body['detail']?.toString();
    }
    return null;
  }
}
