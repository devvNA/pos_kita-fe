import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:pos_kita/data/datasources/db_local_datasource.dart';
import 'package:pos_kita/data/datasources/sales_report_remote_datasource.dart';
import 'package:pos_kita/data/models/responses/sales_report_response_model.dart';
import 'package:pos_kita/data/models/responses/transaction_response_model.dart';

part 'sales_report_bloc.freezed.dart';
part 'sales_report_event.dart';
part 'sales_report_state.dart';

class SalesReportBloc extends Bloc<SalesReportEvent, SalesReportState> {
  final SalesReportRemoteDatasource salesReportRemoteDatasource;
  SalesReportBloc(this.salesReportRemoteDatasource) : super(_Initial()) {
    on<_GetSalesReport>((event, emit) async {
      emit(_Loading());
      final offlineSales = await DBLocalDatasource.instance.getOrderByDate(
        event.date,
      );
      final result = await salesReportRemoteDatasource.getSalesReport(
        event.date,
      );
      result.fold((l) {
        if (offlineSales.isEmpty) {
          emit(_Error(l));
          return;
        }

        emit(_Loaded(_buildOfflineOnlyReport(event.date, offlineSales)));
      }, (r) => emit(_Loaded(_mergeSalesReports(r, offlineSales))));
    });
  }

  SalesReportResponseModel _buildOfflineOnlyReport(
    String date,
    List<TransactionModel> offlineSales,
  ) {
    return _mergeSalesReports(
      SalesReportResponseModel(date, 0, 0, 0, [], 0, 0, 0),
      offlineSales,
    );
  }

  SalesReportResponseModel _mergeSalesReports(
    SalesReportResponseModel onlineReport,
    List<TransactionModel> offlineSales,
  ) {
    final offlineTransactions = offlineSales
        .map(_mapOfflineToTransaction)
        .toList();
    final mergedSales = [...onlineReport.sales, ...offlineTransactions]
      ..sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });

    final offlineTotalPrice = offlineSales.fold<double>(
      0,
      (sum, transaction) =>
          sum + (double.tryParse(transaction.totalPrice ?? '0') ?? 0),
    );

    final offlineTotalTax = offlineSales.fold<double>(
      0,
      (sum, transaction) =>
          sum + (double.tryParse(transaction.tax ?? '0') ?? 0),
    );

    final mergedTotalReceipts =
        onlineReport.totalRecipts + offlineTransactions.length;
    final mergedTotalPrice = onlineReport.totalPrice + offlineTotalPrice;
    final mergedTotalSales = onlineReport.totalSales + offlineTotalPrice;
    final mergedAverageSales = mergedTotalReceipts == 0
        ? 0
        : mergedTotalSales / mergedTotalReceipts;
    final mergedTotalCost = onlineReport.totalCost;
    final mergedTotalProfit =
        onlineReport.totalProfit + (offlineTotalPrice - offlineTotalTax);

    return SalesReportResponseModel(
      onlineReport.date,
      mergedTotalReceipts,
      mergedTotalSales,
      mergedAverageSales.toDouble(),
      mergedSales,
      mergedTotalCost,
      mergedTotalPrice,
      mergedTotalProfit,
    );
  }

  Transaction _mapOfflineToTransaction(TransactionModel transaction) {
    return Transaction(
      id: transaction.id,
      orderNumber: transaction.orderNumber,
      outletId: transaction.outletId,
      subTotal: transaction.subTotal,
      totalPrice: transaction.totalPrice,
      totalItems: transaction.totalItems,
      tax: transaction.tax,
      discount: transaction.discount,
      paymentMethod: transaction.paymentMethod,
      status: transaction.status,
      cashierId: transaction.cashierId,
      createdAt: transaction.createdAt,
      items: transaction.items,
    );
  }
}
