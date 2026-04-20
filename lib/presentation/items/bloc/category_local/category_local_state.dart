part of 'category_local_bloc.dart';

@freezed
class CategoryLocalState with _$CategoryLocalState {
  const factory CategoryLocalState.initial() = _Initial;
  const factory CategoryLocalState.loading() = _Loading;
  const factory CategoryLocalState.success(List<Category> categories) =
      _Success;
  const factory CategoryLocalState.error(String message) = _Error;
}
