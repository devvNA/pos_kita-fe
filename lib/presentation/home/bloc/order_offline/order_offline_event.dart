part of 'order_offline_bloc.dart';

@freezed
class OrderOfflineEvent with _$OrderOfflineEvent {
  const factory OrderOfflineEvent.started() = _Started;
  const factory OrderOfflineEvent.createOfflineOrder(
      {required OrderRequestModel orderRequestModel}) = _CreateOfflineOrder;
}
