import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/components/spaces.dart';
import 'package:pos_kita/core/constants/variables.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/core/extensions/string_ext.dart';
import 'package:pos_kita/presentation/items/bloc/product/product_bloc.dart';
import 'package:pos_kita/presentation/items/pages/stock/outlet_stock_page.dart';

import '../../../../data/models/responses/product_response_model.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(ProductEvent.getProducts());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> _filterProducts(List<Product> products) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return products;

    return products.where((product) {
      final name = (product.name ?? '').toLowerCase();
      final category = (product.category?.name ?? '').toLowerCase();
      final barcode = (product.barcode ?? '').toLowerCase();
      final sku = (product.sku ?? '').toLowerCase();

      return name.contains(query) ||
          category.contains(query) ||
          barcode.contains(query) ||
          sku.contains(query);
    }).toList();
  }

  void _openOutletStock(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OutletStockPage(data: product.stocks ?? []),
      ),
    );
  }

  Future<void> _refreshProducts() async {
    context.read<ProductBloc>().add(ProductEvent.getProducts());
  }

  Widget _buildLoadingState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: const [
        _StockSummarySkeleton(),
        SpaceHeight(16),
        AppCard(child: Skeleton(height: 52, borderRadius: 12)),
        SpaceHeight(16),
        _StockItemSkeleton(),
        SpaceHeight(12),
        _StockItemSkeleton(),
        SpaceHeight(12),
        _StockItemSkeleton(),
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        const _StockSummaryCard(totalProducts: 0, visibleProducts: 0),
        const SpaceHeight(24),
        AppEmptyState(
          icon: Icons.error_outline_rounded,
          title: 'Stok gagal dimuat',
          subtitle: message,
          actionLabel: 'Coba Lagi',
          onAction: _refreshProducts,
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        const _StockSummaryCard(totalProducts: 0, visibleProducts: 0),
        const SpaceHeight(24),
        const AppEmptyState(
          icon: Icons.inventory_2_outlined,
          title: 'Belum ada produk',
          subtitle:
              'Tambahkan produk terlebih dulu untuk mulai mengelola stok per outlet.',
        ),
      ],
    );
  }

  Widget _buildContent(List<Product> products) {
    if (products.isEmpty) {
      return _buildEmptyState();
    }

    final filteredProducts = _filterProducts(products);

    return RefreshIndicator(
      onRefresh: _refreshProducts,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _StockSummaryCard(
            totalProducts: products.length,
            visibleProducts: filteredProducts.length,
          ),
          const SpaceHeight(16),
          AppCard(
            variant: AppCardVariant.outlined,
            child: AppSearchField(
              controller: _searchController,
              hint: 'Cari produk, kategori, barcode, atau SKU',
              onChanged: (_) => setState(() {}),
              onClear: () => setState(() {}),
            ),
          ),
          const SpaceHeight(18),
          Row(
            children: [
              Text(
                'Daftar stok produk',
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  '${filteredProducts.length} item',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SpaceHeight(12),
          if (filteredProducts.isEmpty)
            AppCard(
              child: EmptySearchResults(
                query: _searchController.text.trim(),
                onClear: () {
                  _searchController.clear();
                  setState(() {});
                },
              ),
            )
          else
            ...List.generate(filteredProducts.length, (index) {
              final product = filteredProducts[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == filteredProducts.length - 1 ? 0 : 12,
                ),
                child: _StockProductCard(
                  product: product,
                  onTap: () => _openOutletStock(product),
                ),
              );
            }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Manajemen Stok',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.white,
          ),
        ),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: _buildLoadingState,
            loading: _buildLoadingState,
            error: _buildErrorState,
            success: _buildContent,
          );
        },
      ),
    );
  }
}

class _StockSummaryCard extends StatelessWidget {
  const _StockSummaryCard({
    required this.totalProducts,
    required this.visibleProducts,
  });

  final int totalProducts;
  final int visibleProducts;

  @override
  Widget build(BuildContext context) {
    final isFiltered = totalProducts != visibleProducts;

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.md,
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -12,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.18),
                        ),
                      ),
                      child: const Icon(
                        Icons.warehouse_outlined,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Text(
                        'Siap cek outlet',
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SpaceHeight(18),
                Text(
                  visibleProducts.toString(),
                  style: AppTypography.displaySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SpaceHeight(4),
                Text(
                  isFiltered
                      ? 'Produk cocok dengan pencarian'
                      : 'Produk siap dipantau stoknya',
                  style: AppTypography.titleMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SpaceHeight(8),
                Text(
                  isFiltered
                      ? 'Dari total $totalProducts produk, hanya hasil yang relevan yang ditampilkan.'
                      : 'Pilih produk untuk melihat distribusi stok per outlet dan lanjut ubah jumlah stok.',
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StockProductCard extends StatelessWidget {
  const _StockProductCard({required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  int get _totalStock {
    final stocks = product.stocks ?? const <Stock>[];
    if (stocks.isEmpty) return product.stock ?? 0;
    return stocks.fold<int>(0, (sum, item) => sum + (item.quantity ?? 0));
  }

  int get _outletCount => (product.stocks ?? const <Stock>[]).length;

  @override
  Widget build(BuildContext context) {
    final productName = (product.name ?? '').trim().isEmpty
        ? 'Produk tanpa nama'
        : product.name!.trim();
    final rawCategoryName = product.category?.name?.trim();
    final categoryName = (rawCategoryName == null || rawCategoryName.isEmpty)
        ? 'Tanpa kategori'
        : rawCategoryName;

    return AppCard(
      onTap: onTap,
      padding: AppSpacing.allLg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StockThumbnail(product: product),
          const SpaceWidth(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpaceHeight(6),
                Text(
                  categoryName,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SpaceHeight(12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InfoChip(
                      icon: Icons.inventory_2_outlined,
                      label: 'Stok $_totalStock',
                    ),
                    _InfoChip(
                      icon: Icons.storefront_outlined,
                      label: '$_outletCount outlet',
                    ),
                  ],
                ),
                const SpaceHeight(12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.price?.currencyFormatRpV3 ?? 'Rp0',
                        style: AppTypography.priceSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SpaceWidth(8),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StockThumbnail extends StatelessWidget {
  const _StockThumbnail({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final image = product.image;
    if (image != null && image.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Image.network(
          '${Variables.baseUrl}$image',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _FallbackThumbnail(product: product),
        ),
      );
    }

    return _FallbackThumbnail(product: product);
  }
}

class _FallbackThumbnail extends StatelessWidget {
  const _FallbackThumbnail({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
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
        size: 26,
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SpaceWidth(6),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StockSummarySkeleton extends StatelessWidget {
  const _StockSummarySkeleton();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Skeleton(width: 48, height: 48, borderRadius: 16),
              Spacer(),
              Skeleton(width: 96, height: 32, borderRadius: 999),
            ],
          ),
          SpaceHeight(18),
          Skeleton(width: 72, height: 36, borderRadius: 12),
          SpaceHeight(8),
          Skeleton(width: 220, height: 16, borderRadius: 8),
          SpaceHeight(8),
          Skeleton(width: double.infinity, height: 12, borderRadius: 8),
          SpaceHeight(8),
          Skeleton(width: 240, height: 12, borderRadius: 8),
        ],
      ),
    );
  }
}

class _StockItemSkeleton extends StatelessWidget {
  const _StockItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Skeleton(width: 60, height: 60, borderRadius: 16),
          SpaceWidth(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(width: double.infinity, height: 16, borderRadius: 8),
                SpaceHeight(8),
                Skeleton(width: 120, height: 12, borderRadius: 8),
                SpaceHeight(12),
                Row(
                  children: [
                    Skeleton(width: 92, height: 28, borderRadius: 999),
                    SpaceWidth(8),
                    Skeleton(width: 82, height: 28, borderRadius: 999),
                  ],
                ),
                SpaceHeight(12),
                Row(
                  children: [
                    Expanded(
                      child: Skeleton(
                        width: double.infinity,
                        height: 18,
                        borderRadius: 8,
                      ),
                    ),
                    SpaceWidth(8),
                    Skeleton(width: 40, height: 40, borderRadius: 12),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
