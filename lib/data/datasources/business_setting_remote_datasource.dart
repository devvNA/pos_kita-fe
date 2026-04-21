import 'package:dartz/dartz.dart';
import 'package:pos_kita/core/constants/variables.dart';
import 'package:pos_kita/core/network/network.dart';
import 'package:pos_kita/data/datasources/auth_local_datasource.dart';
import 'package:pos_kita/data/models/requests/business_setting_request_model.dart';
import 'package:pos_kita/data/models/responses/business_type_response_model.dart';

class BusinessSettingRemoteDatasource {
  final AuthLocalDatasource _authLocalDatasource;

  static final HttpClient _client = HttpClient(
    baseUrl: Variables.baseUrl,
    timeout: const Duration(seconds: 15),
    maxRetries: 2,
  );

  BusinessSettingRemoteDatasource({AuthLocalDatasource? authLocalDatasource})
    : _authLocalDatasource = authLocalDatasource ?? AuthLocalDatasource();

  Future<Either<String, String>> addBusinessSetting(
    BusinessSettingRequestModel data,
  ) async {
    try {
      final response = await _client.post<void>(
        '/api/add-business-setting',
        headers: await _authorizedHeaders(),
        body: data.toMap(),
      );

      if (response.success) {
        return right('Success');
      }

      return Left(response.message ?? 'Gagal menambahkan business setting.');
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (_) {
      return const Left('Terjadi kesalahan tidak terduga.');
    }
  }

  Future<Either<String, String>> updateBusinessSetting(
    BusinessSettingRequestModel data,
    int id,
  ) async {
    try {
      final response = await _client.put<void>(
        '/api/update-business-setting/$id',
        headers: await _authorizedHeaders(),
        body: data.toMap(),
      );

      if (response.success) {
        return right('Success');
      }

      return Left(response.message ?? 'Gagal mengubah business setting.');
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (_) {
      return const Left('Terjadi kesalahan tidak terduga.');
    }
  }

  //delete business setting
  Future<Either<String, String>> deleteBusinessSetting(int id) async {
    try {
      final response = await _client.delete<void>(
        '/api/delete-business-setting/$id',
        headers: await _authorizedHeaders(),
      );

      if (response.success) {
        return right('Success');
      }

      return Left(response.message ?? 'Gagal menghapus business setting.');
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (_) {
      return const Left('Terjadi kesalahan tidak terduga.');
    }
  }

  Future<Either<String, BusinessTypeResponseModel>> getBusinessSetting() async {
    final authData = await _authLocalDatasource.getUserData();
    final businessId = authData?.data?.businessId;

    if (businessId == null) {
      return const Left('Business ID tidak ditemukan.');
    }

    return _wrapRequest(
      () async => _client.get<BusinessTypeResponseModel>(
        '/api/get-business-settings-by-business/$businessId',
        headers: await _authorizedHeaders(),
        fromJson: (json) =>
            BusinessTypeResponseModel.fromMap(json as Map<String, dynamic>),
      ),
      fallbackMessage: 'Gagal mengambil business setting.',
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
