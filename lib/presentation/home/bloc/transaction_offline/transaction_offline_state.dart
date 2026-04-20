part of 'transaction_offline_bloc.dart';

@freezed
class TransactionOfflineState with _$TransactionOfflineState {
  const factory TransactionOfflineState.initial() = _Initial;
  const factory TransactionOfflineState.loading() = _Loading;
  const factory TransactionOfflineState.success(List<TransactionModel> data) =
      _Success;
  const factory TransactionOfflineState.error(String message) = _Error;
}
