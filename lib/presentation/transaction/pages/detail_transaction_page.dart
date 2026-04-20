import 'package:flutter/material.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/core/extensions/build_context_ext.dart';
import 'package:pos_kita/core/extensions/date_time_ext.dart';
import 'package:pos_kita/core/extensions/string_ext.dart';
import 'package:pos_kita/data/models/responses/transaction_response_model.dart';
import 'package:pos_kita/presentation/home/models/product_quantity.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../../data/dataoutputs/cwb_print.dart';

class DetailTransactionPage extends StatelessWidget {
  final Transaction transaction;
  const DetailTransactionPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          _buildHeaderInfo(),
          AppSpacing.vGapLg,
          Text(
            'DAFTAR PESANAN',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.vGapSm,
          _buildItemsList(),
          AppSpacing.vGapXl,
          _buildSummary(),
          const SizedBox(height: 100), // Space for bottom bar
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildHeaderInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.sm,
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          _buildInfoRow('No. Pesanan', transaction.orderNumber ?? '-', isBold: true),
          const Divider(height: 24, color: AppColors.divider),
          _buildInfoRow('Waktu', transaction.createdAt!.toLocal().toFormattedDateTime()),
          const SizedBox(height: 12),
          _buildInfoRow('Metode', transaction.paymentMethod ?? '-'),
          const SizedBox(height: 12),
          _buildInfoRow('Status', transaction.status?.toUpperCase() ?? '-', isStatus: true),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    return Column(
      children: transaction.items!.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product?.name ?? '-',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.quantity} x ${item.price!.currencyFormatRpV3}',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Text(
                item.total!.currencyFormatRpV3,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary600,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.md,
      ),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', transaction.subTotal!.currencyFormatRpV3),
          if (transaction.tax != null && transaction.tax != '0') ...[
            const SizedBox(height: 8),
            _buildSummaryRow('Pajak', transaction.tax!.currencyFormatRpV3),
          ],
          if (transaction.discount != null && transaction.discount != '0') ...[
            const SizedBox(height: 8),
            _buildSummaryRow('Diskon', '- ${transaction.discount!.currencyFormatRpV3}'),
          ],
          const Divider(height: 24, color: Colors.white24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL HARGA',
                style: AppTypography.labelLarge.copyWith(color: Colors.white70),
              ),
              Text(
                transaction.totalPrice!.currencyFormatRpV3,
                style: AppTypography.titleLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false, bool isStatus = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
        if (isStatus)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success100,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              value,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.success700,
                fontWeight: FontWeight.w800,
              ),
            ),
          )
        else
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodyMedium.copyWith(color: Colors.white70)),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: AppButton.filled(
        onPressed: () => _printReceipt(context),
        label: 'CETAK ULANG STRUK',
        prefixIcon: const Icon(Icons.print_rounded, color: Colors.white),
      ),
    );
  }

  void _printReceipt(BuildContext context) async {
    final printValue = await CwbPrint.instance.printOrderV2(
      transaction.items!
          .map((e) => ProductQuantity(product: e.product!, quantity: e.quantity!))
          .toList(),
      transaction.totalItems!,
      transaction.totalPrice!.toDouble.toInt(),
      transaction.paymentMethod!,
      transaction.totalPrice!.toIntegerFromText,
      'Kasir 1',
      'Customer',
      transaction.tax!.toDouble,
      transaction.subTotal!.toDouble,
      transaction.orderNumber ?? '',
      transaction.discount!.toDouble,
      true,
    );
    await PrintBluetoothThermal.writeBytes(printValue);
  }
}
