import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/core/extensions/int_ext.dart';
import 'package:pos_kita/core/extensions/string_ext.dart';
import 'package:pos_kita/core/utils/business_setting_mapper.dart';
import 'package:pos_kita/data/models/requests/business_setting_request_model.dart';
import 'package:pos_kita/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:pos_kita/presentation/home/pages/payment_page.dart';
import 'package:pos_kita/presentation/tax_discount/bloc/business_setting/business_setting_bloc.dart';

import '../../tax_discount/bloc/business_setting_local/business_setting_local_bloc.dart';
import '../bloc/online_checker/online_checker_bloc.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  BusinessSettingRequestModel? _selectedDiscount;

  double _getProductPrice(String? rawPrice) {
    return double.tryParse(rawPrice ?? '') ?? 0;
  }

  String _formatProductPrice(String? rawPrice) {
    return _getProductPrice(rawPrice).currencyFormatRp;
  }

  void _toggleDiscount(
    BusinessSettingRequestModel? disc,
    List<BusinessSettingRequestModel> taxs,
  ) {
    if (_selectedDiscount == disc && disc != null) {
      // Unselect if same
      context.read<CheckoutBloc>().add(
        CheckoutEvent.removeDiscount(discount: _selectedDiscount!),
      );
      setState(() => _selectedDiscount = null);
    } else {
      // Remove old if exists
      if (_selectedDiscount != null) {
        context.read<CheckoutBloc>().add(
          CheckoutEvent.removeDiscount(discount: _selectedDiscount!),
        );
      }
      // Add new
      setState(() => _selectedDiscount = disc);
      if (disc != null) {
        context.read<CheckoutBloc>().add(
          CheckoutEvent.addDiscount(discount: disc),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Detail Pesanan',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(child: _buildOrderList()),
            _buildDiscountSection(),
            _buildSummarySection(),
            _buildPayButton(context),
          ],
        ),
      ),
    );
  }

  /* ───────────── ORDER LIST ─────────── */

  Widget _buildOrderList() {
    return _withBusinessSetting(
      builder: (taxs) {
        return BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (_, state) => state.maybeWhen(
            success: (orders, _, _, _, _, _) {
              if (orders.isEmpty) {
                return const Center(child: Text('Belum ada pesanan'));
              }
              return ListView.separated(
                padding: AppSpacing.allMd,
                itemCount: orders.length,
                separatorBuilder: (_, _) => AppSpacing.vGapSm,
                itemBuilder: (_, i) {
                  final order = orders[i];
                  final unitPrice = _getProductPrice(order.product.price);
                  final lineTotal = unitPrice * order.quantity;

                  return AppCard(
                    variant: AppCardVariant.flat,
                    padding: AppSpacing.allSm,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: const BoxConstraints(minWidth: 40),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary50,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(
                            '${order.quantity}x',
                            textAlign: TextAlign.center,
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColors.primary700,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        AppSpacing.hGapMd,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.product.name ?? '-',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              AppSpacing.vGapXs,
                              Text(
                                '${_formatProductPrice(order.product.price)} / item',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.hGapSm,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              lineTotal.currencyFormatRp,
                              style: AppTypography.bodyLarge.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            AppSpacing.vGapXs,
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                context.read<CheckoutBloc>().add(
                                  CheckoutEvent.removeFromCart(
                                    product: order.product,
                                    businessSetting: taxs,
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: AppColors.error500,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            orElse: () => const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  /* ──────────── DISCOUNT ───────────── */

  Widget _buildDiscountSection() {
    return _withBusinessSetting(
      builder: (taxs) {
        final discounts = taxs
            .where((e) => e.chargeType == 'discount')
            .toList();

        if (discounts.isEmpty) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                'Pilih Diskon',
                style: AppTypography.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            AppSpacing.vGapXs,
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                itemCount: discounts.length,
                separatorBuilder: (_, _) => AppSpacing.hGapSm,
                itemBuilder: (_, i) {
                  final d = discounts[i];
                  final isSelected = _selectedDiscount == d;
                  return ChoiceChip(
                    label: Text(d.name),
                    selected: isSelected,
                    onSelected: (v) => _toggleDiscount(v ? d : null, taxs),
                    selectedColor: AppColors.primary100,
                    checkmarkColor: AppColors.primary700,
                    labelStyle: AppTypography.bodySmall.copyWith(
                      color: isSelected
                          ? AppColors.primary700
                          : AppColors.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary500
                            : AppColors.border,
                      ),
                    ),
                  );
                },
              ),
            ),
            AppSpacing.vGapMd,
          ],
        );
      },
    );
  }

  /* ──────────────── SUMMARY ───────────── */

  Widget _buildSummarySection() {
    return _withBusinessSetting(
      builder: (taxs) {
        final taxList = taxs.where((e) => e.chargeType == 'tax').toList();

        return BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (_, st) => st.maybeWhen(
            success: (_, discount, _, subtotal, totalPayment, qty) => AppCard(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              variant: AppCardVariant.elevated,
              padding: AppSpacing.allMd,
              child: Column(
                children: [
                  _summaryRow(
                    'Subtotal ($qty item)',
                    subtotal.currencyFormatRp,
                  ),
                  ...taxList.map(
                    (t) => _summaryRow(
                      t.name,
                      (subtotal * (t.value.toIntegerFromText / 100).toDouble())
                          .currencyFormatRp,
                    ),
                  ),
                  if (discount > 0)
                    _summaryRow(
                      'Diskon',
                      '-${discount.currencyFormatRp}',
                      isNegative: true,
                    ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(height: 1, thickness: 1),
                  ),
                  _summaryRow(
                    'Total Pembayaran',
                    totalPayment.currencyFormatRp,
                    isTotal: true,
                  ),
                ],
              ),
            ),
            orElse: () => const SizedBox(),
          ),
        );
      },
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool isTotal = false,
    bool isNegative = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700)
                : AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
          ),
          Text(
            value,
            style: isTotal
                ? AppTypography.titleMedium.copyWith(
                    color: AppColors.primary700,
                    fontWeight: FontWeight.w800,
                  )
                : AppTypography.bodyMedium.copyWith(
                    color: isNegative
                        ? AppColors.error500
                        : AppColors.textPrimary,
                    fontWeight: isNegative ? FontWeight.w600 : FontWeight.w500,
                  ),
          ),
        ],
      ),
    );
  }

  /* ───────────────────── BUTTON BAYAR ─────────────────── */

  Widget _buildPayButton(BuildContext ctx) => Padding(
    padding: AppSpacing.allLg,
    child: BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (_, state) {
        final hasOrders = state.maybeWhen(
          success: (orders, _, _, _, _, _) => orders.isNotEmpty,
          orElse: () => false,
        );

        return AppButton.filled(
          width: double.infinity,
          onPressed: hasOrders
              ? () {
                  Navigator.push(
                    ctx,
                    MaterialPageRoute(builder: (_) => const PaymentPage()),
                  );
                }
              : null,
          label: 'Lanjutkan Pembayaran',
          prefixIcon: const Icon(Icons.payments_outlined),
        );
      },
    ),
  );

  /* ──────────── HELPER ───────── */

  Widget _withBusinessSetting({
    required Widget Function(List<BusinessSettingRequestModel>) builder,
  }) {
    return BlocBuilder<OnlineCheckerBloc, OnlineCheckerState>(
      builder: (context, conn) {
        final bool isOnline = conn.maybeWhen(
          online: () => true,
          orElse: () => false,
        );

        return isOnline
            ? BlocBuilder<BusinessSettingBloc, BusinessSettingState>(
                builder: (_, bs) => builder(_extractTaxDiscount(bs)),
              )
            : BlocBuilder<BusinessSettingLocalBloc, BusinessSettingLocalState>(
                builder: (_, bs) => builder(_extractLocalTaxDiscount(bs)),
              );
      },
    );
  }

  List<BusinessSettingRequestModel> _extractTaxDiscount(
    BusinessSettingState bs,
  ) {
    return bs.maybeWhen(
      loaded: (data) => data,
      orElse: () => <BusinessSettingRequestModel>[],
    );
  }

  List<BusinessSettingRequestModel> _extractLocalTaxDiscount(
    BusinessSettingLocalState bs,
  ) {
    return bs.maybeWhen(
      loaded: (data) => data.map((e) => e.toRequestModel()).toList(),
      orElse: () => <BusinessSettingRequestModel>[],
    );
  }
}
