part of 'order_offline_bloc.dart';

@freezed
class OrderOfflineState with _$OrderOfflineState {
  const factory OrderOfflineState.initial() = _Initial;
  const factory OrderOfflineState.loading() = _Loading;
  const factory OrderOfflineState.success(TransactionModel data) = _Success;
  const factory OrderOfflineState.error(String message) = _Error;
}
