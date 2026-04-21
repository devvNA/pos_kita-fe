import 'package:dartz/dartz.dart';
import 'package:pos_kita/core/constants/variables.dart';
import 'package:pos_kita/core/network/network.dart';
import 'package:pos_kita/data/datasources/auth_local_datasource.dart';
import 'package:pos_kita/data/models/responses/product_response_model.dart';
import 'package:pos_kita/presentation/items/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProductRemoteDataSource {
  final AuthLocalDatasource _authLocalDatasource;

  static final HttpClient _client = HttpClient(
    baseUrl: Variables.baseUrl,
    timeout: const Duration(seconds: 15),
    maxRetries: 2,
  );

  ProductRemoteDataSource({AuthLocalDatasource? authLocalDatasource})
    : _authLocalDatasource = authLocalDatasource ?? AuthLocalDatasource();

  Future<Either<String, String>> addProduct(ProductModel data) async {
    try {
      final response = await _client.post<void>(
        '/api/add-product',
        headers: await _authorizedHeaders(),
        body: data.toMap(),
      );

      if (response.success) {
        return right('Success');
      }

      return Left(response.message ?? 'Gagal menambahkan produk.');
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (_) {
      return const Left('Terjadi kesalahan tidak terduga.');
    }
  }

  Future<Either<String, String>> addProductWithImage(
    ProductModel data,
    XFile image,
  ) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Variables.baseUrl}/api/add-product'),
    );

    request.headers.addAll(await _authorizedHeaders());
    request.headers['accept'] = 'application/json';

    request.fields.addAll(data.toMapString());
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    final response = await request.send();

    if (response.statusCode == 201) {
      return right('Success');
    } else {
      return left('Gagal menambahkan produk dengan gambar.');
    }
  }

  //edit product
  Future<Either<String, String>> editProduct(ProductModel data, int id) async {
    try {
      final response = await _client.put<void>(
        '/api/update-product/$id',
        headers: await _authorizedHeaders(),
        body: data.toMap(),
      );

      if (response.success) {
        return right('Success');
      }

      return Left(response.message ?? 'Gagal mengubah produk.');
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (_) {
      return const Left('Terjadi kesalahan tidak terduga.');
    }
  }

  Future<Either<String, String>> editProductWithImage(
    ProductModel data,
    XFile image,
    int id,
  ) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Variables.baseUrl}/api/update-product-with-image/$id'),
    );

    request.headers.addAll(await _authorizedHeaders());
    request.headers['accept'] = 'application/json';

    request.fields.addAll(data.toMapString());
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      return right('Success');
    } else {
      return left('Gagal mengubah produk dengan gambar.');
    }
  }

  //get product
  Future<Either<String, ProductResponseModel>> getProducts() async {
    return _wrapRequest(
      () async => _client.get<ProductResponseModel>(
        '/api/get-products',
        headers: await _authorizedHeaders(),
        fromJson: (json) =>
            ProductResponseModel.fromMap(json as Map<String, dynamic>),
      ),
      fallbackMessage: 'Gagal mengambil produk.',
    );
  }

  //edit stock
  Future<Either<String, String>> updateStock(
    int stock,
    String type,
    String note,
    int id,
  ) async {
    try {
      final response = await _client.put<void>(
        '/api/update-stock/$id',
        headers: await _authorizedHeaders(),
        body: {'quantity': stock, 'type': type, 'note': note},
      );

      if (response.success) {
        return right('Success');
      }

      return Left(response.message ?? 'Gagal mengubah stok.');
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
