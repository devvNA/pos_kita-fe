import 'package:dartz/dartz.dart';
import 'package:pos_kita/core/constants/variables.dart';
import 'package:pos_kita/core/network/network.dart';
import 'package:pos_kita/data/datasources/auth_local_datasource.dart';
import 'package:pos_kita/data/models/responses/category_response_model.dart';

class CategoryRemoteDataSource {
  final AuthLocalDatasource _authLocalDatasource;

  static final HttpClient _client = HttpClient(
    baseUrl: Variables.baseUrl,
    timeout: const Duration(seconds: 15),
    maxRetries: 2,
  );

  CategoryRemoteDataSource({AuthLocalDatasource? authLocalDatasource})
    : _authLocalDatasource = authLocalDatasource ?? AuthLocalDatasource();

  Future<Either<String, CategoryResponseModel>> getCategories() async {
    return _wrapRequest(
      () async => _client.get<CategoryResponseModel>(
        '/api/get-categories',
        headers: await _authorizedHeaders(),
        fromJson: (json) =>
            CategoryResponseModel.fromMap(json as Map<String, dynamic>),
      ),
      fallbackMessage: 'Gagal mengambil kategori.',
    );
  }

  //add category
  Future<Either<String, String>> addCategory(String name) async {
    final authData = await _authLocalDatasource.getUserData();
    final businessId = authData?.data?.businessId;

    if (businessId == null) {
      return const Left('Business ID tidak ditemukan.');
    }

    try {
      final response = await _client.post<void>(
        '/api/add-category',
        headers: await _authorizedHeaders(),
        body: {'name': name, 'business_id': businessId},
      );

      if (response.success) {
        return const Right('success');
      }

      return Left(response.message ?? 'Gagal menambahkan kategori.');
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (_) {
      return const Left('Terjadi kesalahan tidak terduga.');
    }
  }

  Future<Either<String, String>> updateCategory(int id, String name) async {
    final authData = await _authLocalDatasource.getUserData();
    final businessId = authData?.data?.businessId;

    if (businessId == null) {
      return const Left('Business ID tidak ditemukan.');
    }

    try {
      final response = await _client.put<void>(
        '/api/update-category/$id',
        headers: await _authorizedHeaders(),
        body: {'name': name, 'business_id': businessId},
      );

      if (response.success) {
        return const Right('success');
      }

      return Left(response.message ?? 'Gagal mengubah kategori.');
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (_) {
      return const Left('Terjadi kesalahan tidak terduga.');
    }
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
