import 'package:flutter/material.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/core/extensions/date_time_ext.dart';
import 'package:pos_kita/core/extensions/string_ext.dart';
import 'package:pos_kita/data/models/responses/transaction_response_model.dart';
import 'package:pos_kita/presentation/home/models/product_model.dart';
import 'package:pos_kita/presentation/transaction/pages/detail_transaction_page.dart';

class TransactionGroupWidget extends StatelessWidget {
  final TransactionGroup group;

  const TransactionGroupWidget(this.group, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            group.date,
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ...group.items.map((transaction) => TransactionItemWidget(transaction)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(color: AppColors.divider, height: 1),
        ),
      ],
    );
  }
}

class TransactionItemWidget extends StatelessWidget {
  final Transaction transaction;

  const TransactionItemWidget(this.transaction, {super.key});

  @override
  Widget build(BuildContext context) {
    final isCash = transaction.paymentMethod == 'Tunai';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailTransactionPage(transaction: transaction),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                isCash ? Icons.payments_rounded : Icons.credit_card_rounded,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            AppSpacing.hGapMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.totalPrice!.currencyFormatRpV3,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    transaction.createdAt!.toLocal().toFormattedTimeOnly(),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  transaction.orderNumber ?? '-',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success100,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    'BERHASIL',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.success700,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
