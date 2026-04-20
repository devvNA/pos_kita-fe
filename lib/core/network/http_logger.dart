// lib/core/network/http_logger.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class HttpLogger {
  final bool enabled;
  final LogLevel level;

  const HttpLogger({
    this.enabled = kDebugMode,
    this.level = LogLevel.debug,
  });

  // ─── Request Logger ───────────────────────────────────────────────────────

  void logRequest({
    required String method,
    required String url,
    Map<String, String>? headers,
    dynamic body,
  }) {
    if (!enabled) return;

    final buffer = StringBuffer();
    buffer.writeln('\n╔════════════════ REQUEST ════════════════');
    buffer.writeln('║ 🚀 $method $url');
    buffer.writeln('╠─────────────────────────────────────────');

    if (headers != null && headers.isNotEmpty) {
      buffer.writeln('║ 📋 Headers:');
      headers.forEach((key, value) {
        // Mask sensitive headers
        final maskedValue = _maskSensitiveHeader(key, value);
        buffer.writeln('║   $key: $maskedValue');
      });
    }

    if (body != null) {
      buffer.writeln('╠─────────────────────────────────────────');
      buffer.writeln('║ 📦 Body:');
      buffer.writeln('║   ${_prettyJson(body)}');
    }

    buffer.writeln('╚═════════════════════════════════════════');
    _log(buffer.toString(), level: LogLevel.info);
  }

  // ─── Response Logger ──────────────────────────────────────────────────────

  void logResponse({
    required int statusCode,
    required String url,
    Map<String, String>? headers,
    dynamic body,
    required Duration duration,
  }) {
    if (!enabled) return;

    final isSuccess = statusCode >= 200 && statusCode < 300;
    final icon = isSuccess ? '✅' : '❌';

    final buffer = StringBuffer();
    buffer.writeln('\n╔════════════════ RESPONSE ═══════════════');
    buffer.writeln('║ $icon $statusCode | ${duration.inMilliseconds}ms | $url');
    buffer.writeln('╠─────────────────────────────────────────');

    if (headers != null && headers.isNotEmpty) {
      buffer.writeln('║ 📋 Headers:');
      headers.forEach((key, value) {
        buffer.writeln('║   $key: $value');
      });
    }

    if (body != null) {
      buffer.writeln('╠─────────────────────────────────────────');
      buffer.writeln('║ 📥 Body:');
      buffer.writeln('║   ${_prettyJson(body)}');
    }

    buffer.writeln('╚═════════════════════════════════════════');
    _log(buffer.toString(), level: isSuccess ? LogLevel.info : LogLevel.error);
  }

  // ─── Error Logger ─────────────────────────────────────────────────────────

  void logError({
    required String url,
    required Object error,
    StackTrace? stackTrace,
  }) {
    if (!enabled) return;

    final buffer = StringBuffer();
    buffer.writeln('\n╔════════════════ ERROR ══════════════════');
    buffer.writeln('║ 💥 $url');
    buffer.writeln('╠─────────────────────────────────────────');
    buffer.writeln('║ $error');
    if (stackTrace != null && level == LogLevel.debug) {
      buffer.writeln('╠─────────────────────────────────────────');
      buffer.writeln('║ StackTrace:');
      buffer.writeln('║   $stackTrace');
    }
    buffer.writeln('╚═════════════════════════════════════════');
    _log(buffer.toString(), level: LogLevel.error);
  }

  // ─── Private Helpers ──────────────────────────────────────────────────────

  String _prettyJson(dynamic data) {
    try {
      if (data is String) {
        final decoded = jsonDecode(data);
        return const JsonEncoder.withIndent('  ').convert(decoded);
      }
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data.toString();
    }
  }

  String _maskSensitiveHeader(String key, String value) {
    const sensitiveHeaders = {'authorization', 'cookie', 'x-api-key', 'token'};
    if (sensitiveHeaders.contains(key.toLowerCase())) {
      if (value.length <= 8) return '***';
      return '${value.substring(0, 6)}...${value.substring(value.length - 4)}';
    }
    return value;
  }

  void _log(String message, {required LogLevel level}) {
    if (level.index >= this.level.index) {
      debugPrint(message);
    }
  }
}
