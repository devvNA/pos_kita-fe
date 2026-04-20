part of 'category_local_bloc.dart';

@freezed
class CategoryLocalEvent with _$CategoryLocalEvent {
  const factory CategoryLocalEvent.started() = _Started;
  const factory CategoryLocalEvent.fetchLocal() = _FetchLocal;
}
