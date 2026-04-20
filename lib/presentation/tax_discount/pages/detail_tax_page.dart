import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/core/extensions/build_context_ext.dart';
import 'package:pos_kita/data/models/requests/business_setting_request_model.dart';
import 'package:pos_kita/presentation/tax_discount/bloc/business_setting/business_setting_bloc.dart';
import 'package:pos_kita/presentation/tax_discount/pages/edit_tax_page.dart';

class DetailTaxPage extends StatefulWidget {
  final BusinessSettingRequestModel businessSetting;
  const DetailTaxPage({super.key, required this.businessSetting});

  @override
  State<DetailTaxPage> createState() => _DetailTaxPageState();
}

class _DetailTaxPageState extends State<DetailTaxPage> {
  String _chargeTypeLabel(String value) {
    return value == 'tax' ? 'Pajak' : 'Diskon';
  }

  String _typeLabel(String value) {
    return value == 'percentage' ? 'Persentase' : 'Nominal Tetap';
  }

  @override
  Widget build(BuildContext context) {
    final setting = widget.businessSetting;
    final isTax = setting.chargeType == 'tax';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Pengaturan',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.onPrimary),
        ),
      ),
      body: ListView(
        padding: AppSpacing.allMd,
        children: [
          // Header card
          Container(
            padding: AppSpacing.allMd,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: AppShadows.sm,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor:
                      isTax ? AppColors.primary100 : AppColors.info100,
                  child: Icon(
                    isTax ? Icons.percent : Icons.discount,
                    color: isTax ? AppColors.primary : AppColors.info600,
                    size: 24,
                  ),
                ),
                AppSpacing.hGapMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        setting.name,
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      AppSpacing.vGapXxs,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isTax
                              ? AppColors.primary50
                              : AppColors.info50,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          _chargeTypeLabel(setting.chargeType),
                          style: AppTypography.labelSmall.copyWith(
                            color: isTax
                                ? AppColors.primary700
                                : AppColors.info700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.vGapMd,

          // Detail info
          Container(
            padding: AppSpacing.allMd,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: AppShadows.sm,
            ),
            child: Column(
              children: [
                _buildDetailRow('Nama', setting.name),
                const Divider(color: AppColors.divider, height: 24),
                _buildDetailRow(
                  'Tipe Pengaturan',
                  _chargeTypeLabel(setting.chargeType),
                ),
                const Divider(color: AppColors.divider, height: 24),
                _buildDetailRow('Tipe Nilai', _typeLabel(setting.type)),
                const Divider(color: AppColors.divider, height: 24),
                _buildDetailRow('Nilai', setting.value.toString()),
              ],
            ),
          ),
          AppSpacing.vGapLg,

          // Action buttons
          Row(
            children: [
              Expanded(
                child: AppButton.danger(
                  onPressed: () {
                    context.read<BusinessSettingBloc>().add(
                      BusinessSettingEvent.deleteBusinessSetting(
                        setting.id ?? 0,
                      ),
                    );
                    context.pop();
                    context.showSnackBar(
                      'Berhasil dihapus',
                      AppColors.error500,
                    );
                  },
                  label: 'Hapus',
                  prefixIcon: const Icon(Icons.delete_outline),
                ),
              ),
              AppSpacing.hGapMd,
              Expanded(
                child: AppButton.filled(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditTaxPage(data: setting),
                      ),
                    );
                  },
                  label: 'Edit',
                  prefixIcon: const Icon(Icons.edit_outlined),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
