part of 'sync_order_bloc.dart';

@freezed
class SyncOrderState with _$SyncOrderState {
  const factory SyncOrderState.initial() = _Initial;
  const factory SyncOrderState.loading() = _Loading;
  const factory SyncOrderState.progress({
    required int synced,
    required int total,
  }) = _Progress;
  const factory SyncOrderState.success() = _Success;
  const factory SyncOrderState.error(String message) = _Error;
}
