import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_kita/core/components/barcode_scanner_page.dart';
import 'package:pos_kita/core/constants/variables.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/core/extensions/build_context_ext.dart';
import 'package:pos_kita/core/extensions/string_ext.dart';
import 'package:pos_kita/data/datasources/auth_local_datasource.dart';
import 'package:pos_kita/data/models/responses/category_response_model.dart';
import 'package:pos_kita/data/models/responses/product_response_model.dart';
import 'package:pos_kita/presentation/items/bloc/category/category_bloc.dart';
import 'package:pos_kita/presentation/items/bloc/product/product_bloc.dart';

import '../../models/product_model.dart';

class EditProductPage extends StatefulWidget {
  final Product data;
  const EditProductPage({super.key, required this.data});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _costController = TextEditingController();
  final _businessIdController = TextEditingController();

  Category? _selectedCategoryData;

  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
  ];

  Color _selectedColor = Colors.red;
  final _formKey = GlobalKey<FormState>();
  XFile? _image;
  bool _isImage = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.data.name ?? '';
    _priceController.text = widget.data.price!.currencyFormatRpV3;
    _stockController.text = widget.data.stock.toString();
    _descriptionController.text = widget.data.description ?? '';
    _barcodeController.text = widget.data.barcode ?? '';
    _costController.text = widget.data.cost!.currencyFormatRpV3;
    _businessIdController.text = widget.data.businessId.toString();
    _selectedCategoryData = widget.data.category;
    _selectedColor = AppColors.changeStringtoColor(widget.data.color ?? '');
    _isImage = widget.data.image != null;
    context.read<CategoryBloc>().add(const CategoryEvent.getCategories());
  }

  void _getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _image = image);
  }

  void _takePicture() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) setState(() => _image = image);
  }

  void _scanBarcode() async {
    final result = await context.push<String>(const BarcodeScannerPage());
    if (result != null) {
      setState(() => _barcodeController.text = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Produk'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            AppTextField(
              label: 'Nama Produk',
              controller: _nameController,
              hint: 'Contoh: Nasi Goreng Spesial',
            ),
            AppSpacing.vGapMd,
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                List<Category> categories = [
                  Category(id: 0, name: 'Pilih Kategori'),
                ];
                state.maybeWhen(
                  orElse: () {},
                  success: (data) {
                    categories = data;
                  },
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kategori',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AppSpacing.vGapXs,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.input),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Category>(
                          value:
                              categories.any(
                                (e) => e.id == _selectedCategoryData?.id,
                              )
                              ? categories.firstWhere(
                                  (e) => e.id == _selectedCategoryData?.id,
                                )
                              : categories.first,
                          isExpanded: true,
                          dropdownColor: AppColors.surface,
                          items: categories.map((Category category) {
                            return DropdownMenuItem<Category>(
                              value: category,
                              child: Text(
                                category.name ?? '',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _selectedCategoryData = value);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            AppSpacing.vGapMd,
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Harga Jual',
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                AppSpacing.hGapMd,
                Expanded(
                  child: AppTextField(
                    label: 'Harga Modal',
                    controller: _costController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            AppSpacing.vGapMd,
            AppTextField(
              label: 'Barcode (Opsional)',
              controller: _barcodeController,
              keyboardType: TextInputType.number,
              suffixIcon: GestureDetector(
                onTap: _scanBarcode,
                child: const Icon(Icons.qr_code_scanner_rounded),
              ),
            ),
            AppSpacing.vGapLg,

            Text(
              'Tampilan di POS',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSpacing.vGapSm,
            Row(
              children: [
                _buildTypeOption(false, 'Warna'),
                AppSpacing.hGapMd,
                _buildTypeOption(true, 'Gambar'),
              ],
            ),
            AppSpacing.vGapMd,

            if (!_isImage)
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _colors
                    .map((color) => _buildColorPicker(color))
                    .toList(),
              ),

            if (_isImage) _buildImagePicker(),

            AppSpacing.vGapXxl,
            AppButton.filled(onPressed: _handleSave, label: 'SIMPAN PERUBAHAN'),
            AppSpacing.vGapLg,
          ],
        ),
      ),
    );
  }

  Widget _buildTypeOption(bool value, String label) {
    final bool isSelected = _isImage == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isImage = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary100 : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorPicker(Color color) {
    final bool isSelected = _selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
          boxShadow: isSelected ? AppShadows.md : null,
        ),
        child: isSelected
            ? const Icon(Icons.check_rounded, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildImagePicker() {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.neutral100,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border),
          ),
          child: _image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: Image.file(File(_image!.path), fit: BoxFit.cover),
                )
              : widget.data.image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: Image.network(
                    '${Variables.baseUrl}${widget.data.image!}',
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(
                  Icons.image_outlined,
                  color: AppColors.textTertiary,
                  size: 40,
                ),
        ),
        AppSpacing.hGapMd,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppButton.outlined(
                onPressed: _getImage,
                label: 'Pilih Galeri',
                prefixIcon: const Icon(Icons.photo_library_rounded, size: 18),
                size: AppButtonSize.small,
              ),
              AppSpacing.vGapSm,
              AppButton.outlined(
                onPressed: _takePicture,
                label: 'Ambil Foto',
                prefixIcon: const Icon(Icons.camera_alt_rounded, size: 18),
                size: AppButtonSize.small,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      final authData = await AuthLocalDatasource().getUserData();
      final outletData = await AuthLocalDatasource().getOutletData();

      final data = ProductModel(
        name: _nameController.text,
        categoryId: _selectedCategoryData?.id ?? 0,
        price: _priceController.text.toIntegerFromText.toDouble(),
        cost: _costController.text.toIntegerFromText.toDouble(),
        stock: 0,
        color: AppColors.getColorString(_selectedColor),
        barcode: _barcodeController.text,
        businessId: authData!.data!.businessId!,
        description: _nameController.text,
        outletId: outletData.id!,
      );

      if (_isImage && _image != null) {
        context.read<ProductBloc>().add(
          ProductEvent.editProductWithImage(data, _image!, widget.data.id!),
        );
      } else {
        context.read<ProductBloc>().add(
          ProductEvent.editProduct(data, widget.data.id!),
        );
      }

      context.pop();
      context.pop();
      context.showSnackBar('Produk berhasil diperbarui', AppColors.success);
    }
  }
}
