import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasources/db_local_datasource.dart';
import '../../../../data/models/responses/product_response_model.dart';

part 'product_local_event.dart';
part 'product_local_state.dart';
part 'product_local_bloc.freezed.dart';

class ProductLocalBloc extends Bloc<ProductLocalEvent, ProductLocalState> {
  final DBLocalDatasource dbLocalDatasource;
  ProductLocalBloc(this.dbLocalDatasource) : super(_Initial()) {
    on<_FetchLocal>((event, emit) async {
      emit(_Loading());
      try {
        final products = await dbLocalDatasource.getAllProduct();
        emit(_Success(products));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });

    on<_GetProductsByCategoryLocal>((event, emit) async {
      emit(ProductLocalState.loading());
      final products =
          await dbLocalDatasource.getProductsByCategoryId(event.categoryId);
      final result = products
          .where((element) => element.categoryId! == event.categoryId)
          .toList();
      emit(_Success(result));
    });
  }
}
