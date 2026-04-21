import 'package:dartz/dartz.dart';
import 'package:pos_kita/core/constants/variables.dart';
import 'package:pos_kita/core/network/network.dart';
import 'package:pos_kita/data/datasources/auth_local_datasource.dart';
import 'package:pos_kita/data/models/requests/printer_request_model.dart';
import 'package:pos_kita/data/models/responses/printer_response_model.dart';

class PrinterRemoteDatasource {
  final AuthLocalDatasource _authLocalDatasource;

  static final HttpClient _client = HttpClient(
    baseUrl: Variables.baseUrl,
    timeout: const Duration(seconds: 15),
    maxRetries: 2,
  );

  PrinterRemoteDatasource({AuthLocalDatasource? authLocalDatasource})
    : _authLocalDatasource = authLocalDatasource ?? AuthLocalDatasource();

  Future<Either<String, String>> addPrinter(PrinterModel data) async {
    try {
      final response = await _client.post<void>(
        '/api/add-printer',
        headers: await _authorizedHeaders(),
        body: data.toMap(),
      );

      if (response.success) {
        return right('Success');
      }

      return Left(response.message ?? 'Gagal menambahkan printer.');
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (_) {
      return const Left('Terjadi kesalahan tidak terduga.');
    }
  }

  //delete printer
  Future<Either<String, String>> deletePrinter(int id) async {
    try {
      final response = await _client.delete<void>(
        '/api/delete-printer/$id',
        headers: await _authorizedHeaders(),
      );

      if (response.success) {
        return right('Success');
      }

      return Left(response.message ?? 'Gagal menghapus printer.');
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (_) {
      return const Left('Terjadi kesalahan tidak terduga.');
    }
  }

  Future<Either<String, PrinterResponseModel>> getPrinters() async {
    final outletData = await _authLocalDatasource.getOutletData();

    if (outletData.id == 0) {
      return const Left('Outlet tidak ditemukan.');
    }

    return _wrapRequest(
      () async => _client.get<PrinterResponseModel>(
        '/api/get-printers-by-outlet/${outletData.id}',
        headers: await _authorizedHeaders(),
        fromJson: (json) =>
            PrinterResponseModel.fromMap(json as Map<String, dynamic>),
      ),
      fallbackMessage: 'Gagal mengambil data printer.',
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
