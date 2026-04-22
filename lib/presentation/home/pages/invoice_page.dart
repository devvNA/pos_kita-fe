import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/core/extensions/int_ext.dart';
import 'package:pos_kita/core/extensions/string_ext.dart';
import 'package:pos_kita/data/dataoutputs/cwb_print.dart';
import 'package:pos_kita/data/models/responses/transaction_response_model.dart';
import 'package:pos_kita/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:pos_kita/presentation/home/pages/home_page.dart';
import 'package:pos_kita/presentation/items/bloc/product/product_bloc.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class InvoicePage extends StatefulWidget {
  final double nominal;
  final double totalPrice;
  final Transaction transaction;

  const InvoicePage({
    super.key,
    required this.nominal,
    required this.totalPrice,
    required this.transaction,
  });

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Nota #${widget.transaction.orderNumber}',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.read<CheckoutBloc>().add(const CheckoutEvent.started());
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.onPrimary),
        ),
      ),
      body: Column(
        children: [
          // Header: Total & Change
          Padding(
            padding: AppSpacing.allMd,
            child: AppCard(
              variant: AppCardVariant.elevated,
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Total Bayar',
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        AppSpacing.vGapXs,
                        Text(
                          widget.totalPrice.currencyFormatRp,
                          style: AppTypography.titleLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Kembalian',
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        AppSpacing.vGapXs,
                        Text(
                          (widget.nominal - widget.totalPrice).currencyFormatRp,
                          style: AppTypography.titleLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                const Icon(
                  Icons.receipt_long_outlined,
                  size: 18,
                  color: AppColors.textTertiary,
                ),
                AppSpacing.hGapSm,
                Text(
                  'Rincian Produk',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.vGapSm,

          // Order Items
          Expanded(
            child: BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () =>
                      const Center(child: CircularProgressIndicator()),
                  success: (orders, _, _, _, _, _) {
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      itemCount: orders.length,
                      separatorBuilder: (_, _) => AppSpacing.vGapXs,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return AppCard(
                          variant: AppCardVariant.flat,
                          padding: AppSpacing.allSm,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      order.product.name ?? '-',
                                      style: AppTypography.bodyMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      '${order.product.price!.currencyFormatRpV3} x ${order.quantity}',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.textTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                (order.product.price!.toDouble * order.quantity)
                                    .currencyFormatRp,
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),

          // Bottom Actions
          BlocBuilder<CheckoutBloc, CheckoutState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () => const SizedBox(),
                success: (cart, discount, tax, subtotal, total, totalItems) {
                  return Container(
                    padding: AppSpacing.allLg,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      boxShadow: AppShadows.md,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppButton.outlined(
                          width: double.infinity,
                          onPressed: () async {
                            final printValue = await CwbPrint.instance
                                .printOrderV2(
                                  cart,
                                  totalItems,
                                  total.toInt(),
                                  'Tunai',
                                  widget.nominal.toInt(),
                                  'Mawar',
                                  'Customer',
                                  tax,
                                  subtotal,
                                  widget.transaction.orderNumber ?? '',
                                  discount,
                                  false,
                                );
                            await PrintBluetoothThermal.writeBytes(printValue);
                          },
                          label: 'Cetak Nota',
                          prefixIcon: const Icon(Icons.print_outlined),
                        ),
                        AppSpacing.vGapMd,
                        AppButton.filled(
                          width: double.infinity,
                          onPressed: () {
                            context.read<CheckoutBloc>().add(
                              const CheckoutEvent.started(),
                            );
                            context.read<ProductBloc>().add(
                              const ProductEvent.getProducts(),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          },
                          label: 'Transaksi Baru',
                          prefixIcon: const Icon(
                            Icons.add_shopping_cart_rounded,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
