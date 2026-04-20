import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/core/extensions/date_time_ext.dart';
import 'package:pos_kita/presentation/home/bloc/transaction_offline/transaction_offline_bloc.dart';
import 'package:pos_kita/presentation/home/models/product_model.dart';

import '../widgets/transaction_offline_group_widget.dart';

class TransactionOfflinePage extends StatefulWidget {
  const TransactionOfflinePage({super.key});

  @override
  State<TransactionOfflinePage> createState() => _TransactionOfflinePageState();
}

class _TransactionOfflinePageState extends State<TransactionOfflinePage> {
  @override
  void initState() {
    context.read<TransactionOfflineBloc>().add(
      const TransactionOfflineEvent.fetchTransactionOff(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<TransactionOfflineBloc, TransactionOfflineState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(
              child: Text(
                message,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
            success: (transactions) {
              if (transactions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_off_rounded,
                        size: 64,
                        color: AppColors.textTertiary,
                      ),
                      AppSpacing.vGapMd,
                      Text(
                        'Tidak ada transaksi offline',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              List<TransactionOfflineGroup> transactionGroups = [];
              for (var transaction in transactions) {
                final date = transaction.createdAt!.toFormattedDateOnly();
                final existingGroup = transactionGroups.where(
                  (g) => g.date == date,
                );

                if (existingGroup.isEmpty) {
                  transactionGroups.add(
                    TransactionOfflineGroup(date: date, items: [transaction]),
                  );
                } else {
                  existingGroup.first.items.add(transaction);
                }
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: transactionGroups.length,
                itemBuilder: (context, index) =>
                    TransactionOfflineGroupWidget(transactionGroups[index]),
              );
            },
            orElse: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
