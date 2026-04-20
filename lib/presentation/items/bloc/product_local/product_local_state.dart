part of 'product_local_bloc.dart';

@freezed
class ProductLocalState with _$ProductLocalState {
  const factory ProductLocalState.initial() = _Initial;
  const factory ProductLocalState.loading() = _Loading;
  const factory ProductLocalState.success(List<Product> products) = _Success;
  const factory ProductLocalState.error(String message) = _Error;
}
