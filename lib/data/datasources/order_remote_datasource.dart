import 'package:dartz/dartz.dart';
import 'package:pos_kita/core/constants/variables.dart';
import 'package:pos_kita/core/network/network.dart';
import 'package:pos_kita/data/datasources/auth_local_datasource.dart';
import 'package:pos_kita/data/models/requests/order_request_model.dart';
import 'package:pos_kita/data/models/responses/transaction_response_model.dart';

class OrderRemoteDatasource {
  final AuthLocalDatasource _authLocalDatasource;

  static final HttpClient _client = HttpClient(
    baseUrl: Variables.baseUrl,
    timeout: const Duration(seconds: 15),
    maxRetries: 2,
  );

  OrderRemoteDatasource({AuthLocalDatasource? authLocalDatasource})
    : _authLocalDatasource = authLocalDatasource ?? AuthLocalDatasource();

  Future<Either<String, Transaction>> createOrder({
    required OrderRequestModel orderRequestModel,
  }) async {
    return _wrapRequest(
      () async => _client.post<Transaction>(
        '/api/add-order',
        headers: await _authorizedHeaders(),
        body: orderRequestModel.toMap(),
        fromJson: (json) =>
            Transaction.fromMap((json as Map<String, dynamic>)['data']),
      ),
      fallbackMessage: 'Gagal membuat order.',
    );
  }

  //get order by outlet id
  Future<Either<String, TransactionResponseModel>> getOrderByOutletId() async {
    final outletData = await _authLocalDatasource.getOutletData();

    if (outletData.id == 0) {
      return const Left('Outlet tidak ditemukan.');
    }

    return _wrapRequest(
      () async => _client.get<TransactionResponseModel>(
        '/api/get-orders-by-outlet/${outletData.id}',
        headers: await _authorizedHeaders(),
        fromJson: (json) =>
            TransactionResponseModel.fromMap(json as Map<String, dynamic>),
      ),
      fallbackMessage: 'Gagal mengambil data transaksi.',
    );
  }

  Future<Map<String, String>> _authorizedHeaders() async {
    final token = await _authLocalDatasource.getToken();
    if (token == null || token.isEmpty) {
      return const {};
    }

    return {'Authorization': 'Bearer $token'};
  }

  Future<Either<String, T>> _wrapRequest<T>(
    Future<ApiResponse<T>> Function() request, {
    required String fallbackMessage,
  }) async {
    try {
      final response = await request();
      final data = response.data;

      if (response.success && data != null) {
        return Right(data);
      }

      return Left(response.message ?? fallbackMessage);
    } on ApiException catch (e) {
      return Left(_normalizeErrorMessage(e.message, fallbackMessage));
    } catch (_) {
      return const Left('Terjadi kesalahan tidak terduga.');
    }
  }

  String _normalizeErrorMessage(String? message, String fallbackMessage) {
    final normalizedMessage = message?.trim();
    if (normalizedMessage == null || normalizedMessage.isEmpty) {
      return fallbackMessage;
    }

    final lowerCasedMessage = normalizedMessage.toLowerCase();
    if (lowerCasedMessage.contains('failed host lookup') ||
        lowerCasedMessage.contains('socketexception') ||
        lowerCasedMessage.contains('connection refused') ||
        lowerCasedMessage.contains('network is unreachable')) {
      return 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
    }

    return normalizedMessage;
  }
}
