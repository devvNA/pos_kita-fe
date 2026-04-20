import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_kita/data/datasources/product_remote_datasource.dart';
import 'package:pos_kita/presentation/items/models/product_model.dart';

import '../../../../data/datasources/db_local_datasource.dart';
import '../../../../data/models/responses/product_response_model.dart';

part 'product_bloc.freezed.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRemoteDataSource productRemoteDataSource;
  final DBLocalDatasource dbLocalDatasource;
  List<Product> products = [];
  ProductBloc(this.productRemoteDataSource, this.dbLocalDatasource)
    : super(_Initial()) {
    on<_AddProduct>((event, emit) async {
      emit(ProductState.loading());
      final result = await productRemoteDataSource.addProduct(event.product);
      result.fold((l) => emit(_Error(l)), (r) => add(_GetProducts()));
    });

    on<_AddProductWithImage>((event, emit) async {
      emit(ProductState.loading());
      final result = await productRemoteDataSource.addProductWithImage(
        event.product,
        event.image,
      );
      result.fold((l) => emit(_Error(l)), (r) => add(_GetProducts()));
    });

    on<_EditProduct>((event, emit) async {
      emit(ProductState.loading());
      final result = await productRemoteDataSource.editProduct(
        event.product,
        event.id,
      );
      result.fold((l) => emit(_Error(l)), (r) => add(_GetProducts()));
    });

    on<_EditProductWithImage>((event, emit) async {
      emit(ProductState.loading());
      final result = await productRemoteDataSource.editProductWithImage(
        event.product,
        event.image,
        event.id,
      );
      result.fold((l) => emit(_Error(l)), (r) => add(_GetProducts()));
    });

    on<_GetProducts>((event, emit) async {
      emit(ProductState.loading());
      final result = await productRemoteDataSource.getProducts();

      result.fold(
        (l) {
          emit(_Error(l));
        },
        (r) {
          products = r.data ?? [];
          dbLocalDatasource.removeAllProduct();
          dbLocalDatasource.insertAllProduct(products);
          // for (final product in products) {
          //   await dbLocalDatasource.insertProduct(product);
          // }
          emit(_Success(products));
          // emit(_Success(r.data ?? []));
        },
      );
    });

    on<_UpdateStock>((event, emit) async {
      emit(ProductState.loading());
      final result = await productRemoteDataSource.updateStock(
        event.stock,
        event.type,
        event.note,
        event.id,
      );
      result.fold((l) => emit(_Error(l)), (r) => add(_GetProducts()));
    });

    on<_GetProductsByCategory>((event, emit) async {
      emit(ProductState.loading());
      final result = products
          .where((element) => element.categoryId! == event.categoryId)
          .toList();
      emit(_Success(result));
    });

    on<_GetProductByBarcode>((event, emit) async {
      emit(ProductState.loading());
      final result = products
          .where((element) => element.barcode == event.barcode)
          .toList();
      emit(_Success(result));
    });

    // on<_FetchLocal>((event, emit) async {
    //   emit(const _Loading());
    //   // reset global state agar tidak numpuk
    //   log("🔥 Fetching local products...");
    //   products = [];

    //   final localProducts = await DBLocalDatasource.instance.getAllProduct();
    //   log("Local products fetched: ${localProducts.length}");
    //   products = localProducts;

    //   emit(_Success(products));
    // });
    // on<_FetchLocal>((event, emit) async {
    //   emit(const _Loading());

    //   log("🔥 Fetching local products...");
    //   products = [];

    //   try {
    //     final localProducts = await dbLocalDatasource.getAllProduct();
    //     log("Local products fetched: ${localProducts.length}");

    //     products = localProducts;
    //     emit(_Success(products));
    //   } catch (e) {
    //     log("Error fetching local products: $e");
    //     emit(_Error("Gagal mengambil produk dari lokal"));
    //   }
    // });
  }
}
