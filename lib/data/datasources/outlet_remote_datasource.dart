import 'package:dartz/dartz.dart';
import 'package:pos_kita/core/constants/variables.dart';
import 'package:pos_kita/core/network/network.dart';
import 'package:pos_kita/data/datasources/auth_local_datasource.dart';
import 'package:pos_kita/data/models/requests/outlet_request_model.dart';
import 'package:pos_kita/data/models/responses/outlet_response_model.dart';

class OutletRemoteDatasource {
  final AuthLocalDatasource _authLocalDatasource;

  static final HttpClient _client = HttpClient(
    baseUrl: Variables.baseUrl,
    timeout: const Duration(seconds: 15),
    maxRetries: 2,
  );

  OutletRemoteDatasource({AuthLocalDatasource? authLocalDatasource})
    : _authLocalDatasource = authLocalDatasource ?? AuthLocalDatasource();

  Future<Either<String, String>> addOutlet(OutletRequestModel data) async {
    try {
      final response = await _client.post<void>(
        '/api/add-outlet',
        headers: await _authorizedHeaders(),
        body: data.toMap(),
      );

      if (response.success) {
        return const Right('Success');
      }

      return Left(response.message ?? 'Gagal menambahkan outlet.');
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (_) {
      return const Left('Terjadi kesalahan tidak terduga.');
    }
  }

  Future<Either<String, String>> updateOutlet(
    OutletRequestModel data,
    int id,
  ) async {
    try {
      final response = await _client.put<void>(
        '/api/update-outlet/$id',
        headers: await _authorizedHeaders(),
        body: data.toMap(),
      );

      if (response.success) {
        return const Right('Success');
      }

      return Left(response.message ?? 'Gagal mengubah outlet.');
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (_) {
      return const Left('Terjadi kesalahan tidak terduga.');
    }
  }

  Future<Either<String, OutletResponseModel>> getOutlets() async {
    final authData = await _authLocalDatasource.getUserData();
    final businessId = authData?.data?.businessId;

    if (businessId == null) {
      return const Left('Business ID tidak ditemukan.');
    }

    return _wrapRequest(
      () async => _client.get<OutletResponseModel>(
        '/api/get-outlets/$businessId',
        headers: await _authorizedHeaders(),
        fromJson: (json) =>
            OutletResponseModel.fromMap(json as Map<String, dynamic>),
      ),
      fallbackMessage: 'Gagal mengambil data outlet.',
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
