import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/core/extensions/string_ext.dart';
import 'package:pos_kita/presentation/home/widgets/drawer_widget.dart';
import 'package:pos_kita/presentation/tax_discount/bloc/business_setting/business_setting_bloc.dart';
import 'package:pos_kita/presentation/tax_discount/pages/add_tax_page.dart';
import 'package:pos_kita/presentation/tax_discount/pages/detail_tax_page.dart';

class TaxDiscountPage extends StatefulWidget {
  const TaxDiscountPage({super.key});

  @override
  State<TaxDiscountPage> createState() => _TaxDiscountPageState();
}

class _TaxDiscountPageState extends State<TaxDiscountPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    context.read<BusinessSettingBloc>().add(
      const BusinessSettingEvent.getBusinessSetting(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text(
          'Pajak & Diskon',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu, color: AppColors.onPrimary),
        ),
      ),
      body: BlocBuilder<BusinessSettingBloc, BusinessSettingState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            },
            loaded: (data) {
              if (data.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 64,
                        color: AppColors.neutral400,
                      ),
                      AppSpacing.vGapMd,
                      Text(
                        'Belum ada pengaturan',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppSpacing.vGapXs,
                      Text(
                        'Tambahkan pajak atau diskon baru',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding: AppSpacing.allMd,
                itemCount: data.length,
                separatorBuilder: (_, _) => const Divider(
                  color: AppColors.divider,
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final item = data[index];
                  final isTax = item.chargeType == 'tax';
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: AppSpacing.xxs,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: isTax
                          ? AppColors.primary100
                          : AppColors.info100,
                      child: Icon(
                        isTax ? Icons.percent : Icons.discount,
                        color: isTax
                            ? AppColors.primary
                            : AppColors.info600,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      item.name,
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        item.type == 'percentage'
                            ? '${item.value}%'
                            : item.value.currencyFormatRp,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textTertiary,
                      size: 16,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return DetailTaxPage(
                              businessSetting: item,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const AddTaxPage();
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
