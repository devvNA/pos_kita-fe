import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasources/db_local_datasource.dart';
import '../../../../data/models/responses/product_response_model.dart';
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
        where: 'is_sync = ? OR is_sync IS NULL',
        whereArgs: [0],
        orderBy: 'createdAt DESC',
      );

      final List<TransactionModel> data = [];

      for (final row in rows) {
        final transaction = TransactionModel.fromMap(row);
        final items = await DBLocalDatasource.instance.getItemsByTransactionId(
          transaction.transactionId ?? '',
        );

        final enrichedItems = <Item>[];
        for (final item in items) {
          final product = item.productId == null
              ? null
              : await DBLocalDatasource.instance.getProductById(
                  item.productId!,
                );

          enrichedItems.add(
            Item(
              id: item.id,
              orderId: item.orderId,
              productId: item.productId,
              quantity: item.quantity,
              price: item.price,
              total: item.total,
              createdAt: item.createdAt,
              updatedAt: item.updatedAt,
              product:
                  product ??
                  Product(
                    id: item.productId,
                    productId: item.productId,
                    name: 'Produk tidak ditemukan',
                    price: item.price,
                  ),
            ),
          );
        }

        data.add(transaction.copyWith(items: enrichedItems));
      }

      emit(TransactionOfflineState.success(data));
    } catch (e) {
      emit(TransactionOfflineState.error(e.toString()));
    }
  }
}
