import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasources/db_local_datasource.dart';
import '../../../../data/models/responses/transaction_response_model.dart';

part 'transaction_offline_event.dart';
part 'transaction_offline_state.dart';
part 'transaction_offline_bloc.freezed.dart';

class TransactionOfflineBloc
    extends Bloc<TransactionOfflineEvent, TransactionOfflineState> {
  TransactionOfflineBloc() : super(_Initial()) {
    on<_FetchTransactionOff>(_onFetch);
  }

  Future<void> _onFetch(
    _FetchTransactionOff event,
    Emitter<TransactionOfflineState> emit,
  ) async {
    emit(const TransactionOfflineState.loading());

    try {
      final db = await DBLocalDatasource.instance.database;
      final rows = await db.query(
        DBLocalDatasource.instance.tableTransactions,
        where: 'is_sync = ?',
        whereArgs: [0],
        orderBy: 'createdAt DESC',
      );

      final List<TransactionModel> data =
          rows.map((e) => TransactionModel.fromMap(e)).toList();

      emit(TransactionOfflineState.success(data));
    } catch (e) {
      emit(TransactionOfflineState.error(e.toString()));
    }
  }
}
