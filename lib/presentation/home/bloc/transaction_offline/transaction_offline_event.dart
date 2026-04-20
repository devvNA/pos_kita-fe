part of 'transaction_offline_bloc.dart';

@freezed
class TransactionOfflineEvent with _$TransactionOfflineEvent {
  const factory TransactionOfflineEvent.started() = _Started;
  const factory TransactionOfflineEvent.fetchTransactionOff() =
      _FetchTransactionOff;
}
