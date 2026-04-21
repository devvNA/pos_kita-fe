import 'package:dartz/dartz.dart';
import 'package:pos_kita/core/constants/variables.dart';
import 'package:pos_kita/core/network/network.dart';
import 'package:pos_kita/data/datasources/auth_local_datasource.dart';
import 'package:pos_kita/data/models/responses/auth_response_model.dart';
import 'package:pos_kita/data/models/responses/myoutlet_response_model.dart';

class AuthRemoteDataSource {
  final AuthLocalDatasource _authLocalDatasource;

  static final HttpClient _client = HttpClient(
    baseUrl: Variables.baseUrl,
    timeout: const Duration(seconds: 15),
    maxRetries: 2,
  );

  AuthRemoteDataSource({AuthLocalDatasource? authLocalDatasource})
    : _authLocalDatasource = authLocalDatasource ?? AuthLocalDatasource();

  Future<Either<String, AuthResponseModel>> login(
    String email,
    String password,
  ) async {
    return _wrapRequest(
      () => _client.post<AuthResponseModel>(
        '/api/login',
        body: {'email': email, 'password': password},
        fromJson: (json) =>
            AuthResponseModel.fromMap(json as Map<String, dynamic>),
      ),
      fallbackMessage: 'Login gagal.',
    );
  }

  //register
  Future<Either<String, AuthResponseModel>> register(
    String name,
    String address,
    String email,
    String password,
  ) async {
    return _wrapRequest(
      () => _client.post<AuthResponseModel>(
        '/api/register',
        body: {
          'name': name,
          'business_name': name,
          'email': email,
          'password': password,
          'address': address,
        },
        fromJson: (json) =>
            AuthResponseModel.fromMap(json as Map<String, dynamic>),
      ),
      fallbackMessage: 'Registrasi gagal.',
    );
  }

  //me
  Future<Either<String, AuthResponseModel>> me(String token) async {
    return _wrapRequest(
      () => _client.get<AuthResponseModel>(
        '/api/me',
        headers: {'Authorization': 'Bearer $token'},
        fromJson: (json) =>
            AuthResponseModel.fromMap(json as Map<String, dynamic>),
      ),
      fallbackMessage: 'Gagal mengambil data profil.',
    );
  }

  //myoutlet
  Future<Either<String, MyoutletResponseModel>> myoutlet() async {
    final headers = await _authorizedHeaders();

    return _wrapRequest(
      () => _client.get<MyoutletResponseModel>(
        '/api/my-outlet',
        headers: headers,
        fromJson: (json) =>
            MyoutletResponseModel.fromMap(json as Map<String, dynamic>),
      ),
      fallbackMessage: 'Gagal mengambil data outlet.',
    );
  }

  //logout
  Future<Either<String, String>> logout() async {
    try {
      final response = await _client.post<void>(
        '/api/logout',
        headers: await _authorizedHeaders(),
      );
      if (response.success) {
        return const Right('Logout success');
      }
      return Left(response.message ?? 'Logout gagal.');
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
