import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/core/extensions/build_context_ext.dart';
import 'package:pos_kita/core/extensions/string_ext.dart';
import 'package:pos_kita/data/models/responses/product_response_model.dart';
import 'package:pos_kita/presentation/items/bloc/product/product_bloc.dart';

class EditStockPage extends StatefulWidget {
  final Stock data;
  const EditStockPage({super.key, required this.data});

  @override
  State<EditStockPage> createState() => _EditStockPageState();
}

class _EditStockPageState extends State<EditStockPage> {
  final List<String> _stockType = ['Add', 'Reduce'];
  String? _selectedStockType = 'Add';

  final quantityController = TextEditingController();
  final noteController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    quantityController.dispose();
    noteController.dispose();
    super.dispose();
  }

  String _stockTypeLabel(String value) {
    return value == 'Add' ? 'Tambah Stok' : 'Kurangi Stok';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Update Stok',
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
        padding: AppSpacing.screenPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detail Produk',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.vGapSm,
              AppCard(
                variant: AppCardVariant.flat,
                backgroundColor: AppColors.primary50,
                padding: AppSpacing.allMd,
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary100,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: const Icon(
                        Icons.inventory_2_outlined,
                        color: AppColors.primary700,
                      ),
                    ),
                    AppSpacing.hGapMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.data.product?.name ?? '-',
                            style: AppTypography.titleSmall.copyWith(
                              color: AppColors.primary900,
                            ),
                          ),
                          Text(
                            'Outlet: ${widget.data.outlet?.name ?? '-'}',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primary700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.vGapLg,
              Text(
                'Form Perubahan',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.vGapSm,
              AppCard(
                variant: AppCardVariant.elevated,
                padding: AppSpacing.allMd,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Tipe Perubahan',
                        prefixIcon: const Icon(
                          Icons.swap_vert_rounded,
                          color: AppColors.textTertiary,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      dropdownColor: AppColors.surface,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      initialValue: _selectedStockType,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedStockType = newValue;
                        });
                      },
                      items: _stockType.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(_stockTypeLabel(value)),
                        );
                      }).toList(),
                    ),
                    AppSpacing.vGapMd,
                    AppTextField(
                      controller: quantityController,
                      label: 'Jumlah',
                      hint: 'Masukkan jumlah stok',
                      prefixIcon: const Icon(Icons.add_box_outlined),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Jumlah wajib diisi';
                        }
                        return null;
                      },
                    ),
                    AppSpacing.vGapMd,
                    AppTextField(
                      controller: noteController,
                      label: 'Catatan',
                      hint: 'Alasan perubahan stok...',
                      prefixIcon: const Icon(Icons.note_alt_outlined),
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Catatan wajib diisi';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              AppSpacing.vGapXl,
              AppButton.filled(
                width: double.infinity,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<ProductBloc>().add(
                      ProductEvent.updateStock(
                        quantityController.text.toIntegerFromText,
                        _selectedStockType == 'Add' ? 'add' : 'reduce',
                        noteController.text,
                        widget.data.id!,
                      ),
                    );

                    Navigator.pop(context);
                    Navigator.pop(context);
                    context.showSnackBar(
                      'Stok berhasil diperbarui',
                      AppColors.success600,
                    );
                  }
                },
                label: 'Simpan Perubahan',
                prefixIcon: const Icon(Icons.check_circle_outline_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
