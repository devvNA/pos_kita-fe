import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasources/auth_local_datasource.dart';
import '../../../../data/datasources/db_local_datasource.dart';
import '../../../../data/models/requests/order_request_model.dart';
import '../../../../data/models/responses/transaction_response_model.dart';

part 'order_offline_event.dart';
part 'order_offline_state.dart';
part 'order_offline_bloc.freezed.dart';

String _generateTransactionId() {
  final timestamp = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
  final randomPart = Random().nextInt(1000).toString().padLeft(3, '0');
  return 'ORD$timestamp$randomPart';
}

class OrderOfflineBloc extends Bloc<OrderOfflineEvent, OrderOfflineState> {
  OrderOfflineBloc() : super(_Initial()) {
    on<_CreateOfflineOrder>((event, emit) async {
      emit(const OrderOfflineState.loading());
      final userData = await AuthLocalDatasource().getUserData();
      try {
        // create transactionId unik
        final transactionId = _generateTransactionId();

        // create model transaksi
        final transaction = TransactionModel(
          transactionId: transactionId,
          orderNumber: transactionId.substring(0, 8).toUpperCase(),
          outletId: event.orderRequestModel.outletId,
          subTotal: event.orderRequestModel.subtotal.toString(),
          totalPrice: event.orderRequestModel.totalPrice.toString(),
          totalItems: event.orderRequestModel.totalItems,
          tax: event.orderRequestModel.tax.toString(),
          discount: event.orderRequestModel.discount.toString(),
          paymentMethod: event.orderRequestModel.paymentMethod,
          status: 'pending',
          cashierId: userData?.data?.id ?? 0,
          createdAt: DateTime.now(),
          items: event.orderRequestModel.items.map((p) {
            return Item(
              productId: p.product.id,
              quantity: p.quantity,
              price: p.product.price,
              total: (p.quantity * double.parse(p.product.price!)).toString(),
              createdAt: DateTime.now(),
            );
          }).toList(),
        );

        await DBLocalDatasource.instance.saveOrder(transaction);
        emit(OrderOfflineState.success(transaction));
      } catch (e) {
        emit(OrderOfflineState.error(e.toString()));
      }
    });
  }
}
