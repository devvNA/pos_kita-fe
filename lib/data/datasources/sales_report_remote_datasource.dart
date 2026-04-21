import 'package:dartz/dartz.dart';
import 'package:pos_kita/core/constants/variables.dart';
import 'package:pos_kita/core/network/network.dart';
import 'package:pos_kita/data/datasources/auth_local_datasource.dart';
import 'package:pos_kita/data/models/responses/sales_report_response_model.dart';

class SalesReportRemoteDatasource {
  final AuthLocalDatasource _authLocalDatasource;

  static final HttpClient _client = HttpClient(
    baseUrl: Variables.baseUrl,
    timeout: const Duration(seconds: 15),
    maxRetries: 2,
  );

  SalesReportRemoteDatasource({AuthLocalDatasource? authLocalDatasource})
    : _authLocalDatasource = authLocalDatasource ?? AuthLocalDatasource();

  Future<Either<String, SalesReportResponseModel>> getSalesReport(
    String date,
  ) async {
    final authData = await _authLocalDatasource.getUserData();
    final businessId = authData?.data?.businessId;

    if (businessId == null) {
      return const Left('Business ID tidak ditemukan.');
    }

    return _wrapRequest(
      () async => _client.post<SalesReportResponseModel>(
        '/api/get-daily-sales-report',
        headers: await _authorizedHeaders(),
        body: {'date': date, 'business_id': businessId},
        fromJson: (json) =>
            SalesReportResponseModel.fromMap(json as Map<String, dynamic>),
      ),
      fallbackMessage: 'Gagal mengambil laporan penjualan.',
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
      return Left(e.message);
    } catch (_) {
      return const Left('Terjadi kesalahan tidak terduga.');
    }
  }
}
