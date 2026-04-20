import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/core/extensions/build_context_ext.dart';

import 'package:pos_kita/data/models/requests/business_setting_request_model.dart';
import 'package:pos_kita/presentation/tax_discount/bloc/business_setting/business_setting_bloc.dart';

class EditTaxPage extends StatefulWidget {
  final BusinessSettingRequestModel data;
  const EditTaxPage({super.key, required this.data});

  @override
  State<EditTaxPage> createState() => _EditTaxPageState();
}

class _EditTaxPageState extends State<EditTaxPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taxNameController = TextEditingController();
  final TextEditingController _taxValueController = TextEditingController();

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
  void initState() {
    _taxNameController.text = widget.data.name;
    _taxValueController.text = widget.data.value.toString();
    chargeType = widget.data.chargeType;
    type = widget.data.type;
    super.initState();
  }

  @override
  void dispose() {
    _taxNameController.dispose();
    _taxValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Pengaturan',
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
                controller: _taxNameController,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  hintText: 'Masukkan nama',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              AppSpacing.vGapMd,
              DropdownButtonFormField<String>(
                value: chargeType,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
                dropdownColor: AppColors.surface,
                decoration: const InputDecoration(
                  labelText: 'Tipe Pengaturan',
                  hintText: 'Pilih tipe',
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
                    chargeType = value ?? 'tax';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tipe pengaturan harus dipilih';
                  }
                  return null;
                },
              ),
              AppSpacing.vGapMd,
              DropdownButtonFormField<String>(
                value: type,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
                dropdownColor: AppColors.surface,
                decoration: const InputDecoration(
                  labelText: 'Tipe Nilai',
                  hintText: 'Pilih tipe nilai',
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
                    type = value ?? 'percentage';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tipe nilai harus dipilih';
                  }
                  return null;
                },
              ),
              AppSpacing.vGapMd,
              TextFormField(
                controller: _taxValueController,
                keyboardType: TextInputType.number,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  labelText: 'Nilai',
                  hintText: 'Masukkan nilai',
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
              AppButton.filled(
                width: double.infinity,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final data = BusinessSettingRequestModel(
                      _taxNameController.text,
                      chargeType,
                      type,
                      _taxValueController.text,
                      widget.data.businessId,
                      widget.data.id,
                    );
                    context.read<BusinessSettingBloc>().add(
                      BusinessSettingEvent.editBusinessSetting(
                        data,
                        widget.data.id ?? 0,
                      ),
                    );
                    context.pop();
                    context.pop();
                  }
                },
                label: 'Simpan Perubahan',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
