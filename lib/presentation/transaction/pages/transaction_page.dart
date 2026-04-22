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
  void _loadTransactions() {
    context.read<TransactionBloc>().add(const TransactionEvent.getTransactions());
  }

  @override
  void initState() {
    _loadTransactions();
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
              child: Padding(
                padding: AppSpacing.screenPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.error50,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: const Icon(
                        Icons.wifi_off_rounded,
                        color: AppColors.error,
                        size: 36,
                      ),
                    ),
                    AppSpacing.vGapLg,
                    Text(
                      'Gagal memuat transaksi online',
                      textAlign: TextAlign.center,
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AppSpacing.vGapSm,
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppSpacing.vGapLg,
                    SizedBox(
                      width: 180,
                      child: AppButton.outlined(
                        onPressed: _loadTransactions,
                        label: 'Coba Lagi',
                      ),
                    ),
                  ],
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
