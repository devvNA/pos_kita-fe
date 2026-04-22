import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/data/datasources/auth_local_datasource.dart';
import 'package:pos_kita/data/models/requests/business_setting_request_model.dart';
import 'package:pos_kita/presentation/tax_discount/bloc/business_setting/business_setting_bloc.dart';

class AddTaxPage extends StatefulWidget {
  const AddTaxPage({super.key});

  @override
  State<AddTaxPage> createState() => _AddTaxPageState();
}

class _AddTaxPageState extends State<AddTaxPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController valueController = TextEditingController();

  String chargeType = 'tax';
  List<String> chargeTypeList = ['tax', 'discount'];

  String type = 'percentage';
  List<String> typeList = ['percentage', 'fixed'];

  String _chargeTypeLabel(String value) {
    return value == 'tax' ? 'Pajak' : 'Diskon';
  }

  String _typeLabel(String value) {
    return value == 'percentage' ? 'Persentase' : 'Nominal Tetap';
  }

  @override
  void dispose() {
    nameController.dispose();
    valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Pengaturan',
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
      body: SingleChildScrollView(
        padding: AppSpacing.allMd,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informasi Dasar',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.vGapSm,
              TextFormField(
                controller: nameController,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              AppSpacing.vGapMd,
              DropdownButtonFormField<String>(
                initialValue: chargeType,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
                dropdownColor: AppColors.surface,
                decoration: const InputDecoration(
                  labelText: 'Tipe Pengaturan',
                ),
                items: chargeTypeList
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          _chargeTypeLabel(e),
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    chargeType = value!;
                  });
                },
              ),
              AppSpacing.vGapMd,
              DropdownButtonFormField<String>(
                initialValue: type,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
                dropdownColor: AppColors.surface,
                decoration: const InputDecoration(
                  labelText: 'Tipe Nilai',
                ),
                items: typeList
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          _typeLabel(e),
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    type = value!;
                  });
                },
              ),
              AppSpacing.vGapMd,
              TextFormField(
                controller: valueController,
                keyboardType: TextInputType.number,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  labelText: 'Nilai',
                  suffixText: type == 'percentage' ? '%' : 'Rp',
                  suffixStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nilai tidak boleh kosong';
                  }
                  return null;
                },
              ),
              AppSpacing.vGapXl,
              BlocConsumer<BusinessSettingBloc, BusinessSettingState>(
                listener: (context, state) {
                  state.maybeWhen(
                    orElse: () {},
                    loaded: (_) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Berhasil menambahkan pengaturan',
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: AppColors.success600,
                        ),
                      );
                    },
                    error: (message) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            message,
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: AppColors.error500,
                        ),
                      );
                    },
                  );
                },
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () {
                      return AppButton.filled(
                        width: double.infinity,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final authData =
                                await AuthLocalDatasource().getUserData();
                            final data = BusinessSettingRequestModel(
                              nameController.text,
                              chargeType,
                              type,
                              valueController.text,
                              authData!.data!.businessId!,
                              null,
                            );
                            context.read<BusinessSettingBloc>().add(
                              BusinessSettingEvent.addBusinessSetting(data),
                            );
                          }
                        },
                        label: 'Tambah',
                      );
                    },
                    loading: () {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
