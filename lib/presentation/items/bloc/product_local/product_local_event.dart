part of 'product_local_bloc.dart';

@freezed
class ProductLocalEvent with _$ProductLocalEvent {
  const factory ProductLocalEvent.started() = _Started;
  const factory ProductLocalEvent.fetchLocal() = _FetchLocal;
  const factory ProductLocalEvent.getProductsByCategoryLocal(int categoryId) =
      _GetProductsByCategoryLocal;
}
