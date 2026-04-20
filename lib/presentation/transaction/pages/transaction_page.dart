import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/core/extensions/date_time_ext.dart';
import 'package:pos_kita/presentation/home/bloc/transaction/transaction_bloc.dart';
import 'package:pos_kita/presentation/home/models/product_model.dart';
import 'package:pos_kita/presentation/transaction/widgets/transaction_group_widget.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  void initState() {
    context.read<TransactionBloc>().add(
      const TransactionEvent.getTransactions(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<TransactionBloc, TransactionState>(
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
              if (transactions.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_rounded,
                        size: 64,
                        color: AppColors.textTertiary,
                      ),
                      AppSpacing.vGapMd,
                      Text(
                        'Tidak ada transaksi online',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              List<TransactionGroup> transactionGroups = [];
              for (var transaction in transactions.data!) {
                final date = transaction.createdAt!.toFormattedDateOnly();
                final existingGroup = transactionGroups.where(
                  (g) => g.date == date,
                );

                if (existingGroup.isEmpty) {
                  transactionGroups.add(
                    TransactionGroup(date: date, items: [transaction]),
                  );
                } else {
                  existingGroup.first.items.add(transaction);
                }
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: transactionGroups.length,
                itemBuilder: (context, index) =>
                    TransactionGroupWidget(transactionGroups[index]),
              );
            },
            orElse: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
