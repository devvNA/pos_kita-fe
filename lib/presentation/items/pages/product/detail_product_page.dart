import 'package:flutter/material.dart';
import 'package:pos_kita/core/constants/variables.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/core/extensions/string_ext.dart';
import 'package:pos_kita/data/models/responses/product_response_model.dart';
import 'package:pos_kita/presentation/items/pages/product/edit_product_page.dart';

class DetailProductPage extends StatefulWidget {
  final Product data;

  const DetailProductPage({super.key, required this.data});

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  void _openEditPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductPage(data: widget.data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.data;
    final productName = (product.name ?? '').trim().isEmpty
        ? 'Produk tanpa nama'
        : product.name!.trim();
    final rawCategoryName = product.category?.name?.trim();
    final categoryName = (rawCategoryName == null || rawCategoryName.isEmpty)
        ? 'Tanpa kategori'
        : rawCategoryName;
    final description = (product.description ?? '').trim();
    final barcode = (product.barcode ?? '').trim();
    final sku = (product.sku ?? '').trim();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Detail Produk',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: AppShadows.md,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProductPreview(product: product),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.full,
                                ),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.18),
                                ),
                              ),
                              child: Text(
                                categoryName,
                                style: AppTypography.labelSmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              productName,
                              style: AppTypography.headlineSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              product.price?.currencyFormatRpV3 ?? 'Rp0',
                              style: AppTypography.priceLarge.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    description.isEmpty
                        ? 'Produk ini siap ditampilkan di katalog dan digunakan pada proses transaksi.'
                        : description,
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.86),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                _DetailRow(label: 'Nama produk', value: productName),
                const SizedBox(height: 14),
                _DetailRow(label: 'Kategori', value: categoryName),
                const SizedBox(height: 14),
                _DetailRow(
                  label: 'Harga jual',
                  value: product.price?.currencyFormatRpV3 ?? 'Rp0',
                  valueColor: AppColors.primary,
                ),
                const SizedBox(height: 14),
                _DetailRow(
                  label: 'Harga dasar',
                  value: product.cost?.currencyFormatRpV3 ?? 'Rp0',
                ),
                if (sku.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  _DetailRow(label: 'SKU', value: sku),
                ],
                if (barcode.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  _DetailRow(label: 'Barcode', value: barcode),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppButton.filled(
            onPressed: _openEditPage,
            label: 'Edit Produk',
            size: AppButtonSize.large,
            prefixIcon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
    );
  }
}

class _ProductPreview extends StatelessWidget {
  const _ProductPreview({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final image = product.image;
    if (image != null && image.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Image.network(
          '${Variables.baseUrl}$image',
          width: 92,
          height: 92,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _FallbackPreview(product: product),
        ),
      );
    }

    return _FallbackPreview(product: product);
  }
}

class _FallbackPreview extends StatelessWidget {
  const _FallbackPreview({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        color: AppColors.changeStringtoColor(
          product.color ?? '',
        ).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.inventory_2_outlined,
        color: AppColors.white,
        size: 34,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTypography.bodyMedium.copyWith(
              color: valueColor ?? AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
