import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasources/db_local_datasource.dart';
import '../../../../data/datasources/order_remote_datasource.dart';
import '../../../../data/models/requests/order_request_model.dart';
import '../../../../data/models/responses/product_response_model.dart';
import '../../../home/models/product_quantity.dart';

part 'sync_order_bloc.freezed.dart';
part 'sync_order_event.dart';
part 'sync_order_state.dart';

class SyncOrderBloc extends Bloc<SyncOrderEvent, SyncOrderState> {
  final DBLocalDatasource local;
  final OrderRemoteDatasource remote;
  SyncOrderBloc(
    this.local,
    this.remote,
  ) : super(_Initial()) {
    on<_SyncAll>((event, emit) async {
      emit(const SyncOrderState.loading());

      final orders = await local.getUnsyncedOrders(); //tambahkan query ini
      if (orders.isEmpty) {
        emit(const SyncOrderState.success());
        return;
      }

      int sent = 0;
      emit(SyncOrderState.progress(synced: sent, total: orders.length));

      for (final localTrx in orders) {
        try {
          // Bangun kembali Request
          // final items =
          //     await local.getItemsByTransactionId(localTrx.transactionId ?? '');

          // if (items.isEmpty) continue; // tidak ada item, skip
          final itemRows =
              await local.getItemsByTransactionId(localTrx.transactionId ?? '');

          final prodQuantities = <ProductQuantity>[];

          for (final row in itemRows) {
            // dapatkan product; kalau null buat stub sederhana
            Product? prod = row.product;
            if (prod == null && row.productId != null) {
              prod = await local.getProductById(row.productId!);
            }
            prod ??= Product(
              id: row.productId,
              price: row.price,
            );

            prodQuantities.add(ProductQuantity(
              product: prod,
              quantity: row.quantity ?? 0,
            ));
          }

          if (prodQuantities.isEmpty) continue; // tidak valid, lewat

          // final outletId = localTrx.outletId;
          // if (outletId == null || outletId == 0) {
          //   log('Skip trx ${localTrx.transactionId} outletId kosong');
          //   continue;
          // }

          final req = OrderRequestModel(
            outletId: localTrx.outletId ?? 0,
            subtotal: double.tryParse(localTrx.subTotal ?? '') ?? 0,
            totalPrice: double.tryParse(localTrx.totalPrice ?? '') ?? 0,
            totalItems: localTrx.totalItems ?? 0,
            tax: double.tryParse(localTrx.tax ?? '') ?? 0,
            discount: double.tryParse(localTrx.discount ?? '') ?? 0,
            paymentMethod: localTrx.paymentMethod ?? '',
            items: prodQuantities,
            // items: items
            //     .map((e) => ProductQuantity(
            //           product: e.product!, // pastikan product ada
            //           quantity: e.quantity ?? 0,
            //         ))
            //     .toList(),
          );

          // final result = await remote.createOrder(orderRequestModel: req);
          // result.fold(
          //   (err) => throw Exception(err),
          //   (_) async {
          //     await local.markOrderSynced(id: localTrx.id!, status: 'success');
          //     sent++;
          //     emit(SyncOrderState.progress(synced: sent, total: orders.length));
          //   },
          // );

          try {
            final res = await remote.createOrder(orderRequestModel: req);
            res.fold(
              (l) => log('API error: $l'),
              (_) => log('Success send ${localTrx.transactionId}'),
            );
          } catch (e) {
            log('Exception: $e');
          } finally {
            //selalu panggil – baik success, duplicate, maupun error
            await local.markOrderSynced(id: localTrx.id!, status: 'sent');
            sent++;
            emit(SyncOrderState.progress(synced: sent, total: orders.length));
          }

          log(jsonEncode(req.toMap()));
        } catch (e) {
          emit(SyncOrderState.error('Gagal sync: $e'));
          log(e.toString());
          return;
        }
      }

      emit(const SyncOrderState.success());
    });

    // on<_SyncAll>((event, emit) async {
    //   emit(const _Loading());

    //   try {
    //     final unsynced = await local.getUnsyncedOrders();
    //     if (unsynced.isEmpty) {
    //       emit(const _Success());
    //       return;
    //     }

    //     int done = 0;
    //     for (final trx in unsynced) {
    //       // ----- ambil item transaksi -----
    //       final items = await local.getItemsByTransactionId(trx.transactionId!);

    //       // konversi ke ProductQuantity → OrderRequestModel
    //       final products = items
    //           .map((e) => ProductQuantity(
    //                 product: e.product!, // diasumsikan sudah include
    //                 quantity: e.quantity ?? 0,
    //               ))
    //           .toList();

    //       final req = OrderRequestModel(
    //         outletId: trx.outletId!,
    //         subtotal: double.parse(trx.subTotal ?? '0'),
    //         totalPrice: double.parse(trx.totalPrice ?? '0'),
    //         totalItems: trx.totalItems ?? 0,
    //         tax: double.parse(trx.tax ?? '0'),
    //         discount: double.parse(trx.discount ?? '0'),
    //         paymentMethod: trx.paymentMethod ?? 'Tunai',
    //         items: products,
    //       );

    //       Either<String, Transaction> res =
    //           await remote.createOrder(orderRequestModel: req);

    //       res.fold(
    //         (err) => null, // kalau gagal biarkan, akan disync lagi nanti
    //         (data) async {
    //           await local.markOrderSynced(
    //             id: trx.id!,
    //             status: 'success',
    //           );
    //         },
    //       );

    //       done++;
    //       emit(_Progress(synced: done, total: unsynced.length));
    //     }

    //     emit(const _Success());
    //   } catch (e) {
    //     emit(_Error(e.toString()));
    //     log("Pesan error: ${e.toString()}");
    //   }
    // });
  }
}
