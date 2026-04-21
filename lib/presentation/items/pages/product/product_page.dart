import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/components/spaces.dart';
import 'package:pos_kita/core/constants/variables.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/core/extensions/string_ext.dart';
import 'package:pos_kita/data/models/responses/product_response_model.dart';
import 'package:pos_kita/presentation/items/bloc/category/category_bloc.dart';
import 'package:pos_kita/presentation/items/pages/product/add_product_page.dart';
import 'package:pos_kita/presentation/items/pages/product/detail_product_page.dart';

import '../../../home/bloc/online_checker/online_checker_bloc.dart';
import '../../bloc/category_local/category_local_bloc.dart';
import '../../bloc/product/product_bloc.dart';
import '../../bloc/product_local/product_local_bloc.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool _hasFetchedOnlineData = false;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Connectivity().checkConnectivity().then(_handleConnectivity);
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      _handleConnectivity,
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _handleConnectivity(List<ConnectivityResult> list) {
    final isOnline =
        list.contains(ConnectivityResult.mobile) ||
        list.contains(ConnectivityResult.wifi);

    if (mounted) {
      context.read<OnlineCheckerBloc>().add(OnlineCheckerEvent.check(isOnline));
    }

    if (isOnline) {
      if (mounted && !_hasFetchedOnlineData) {
        _fetchOnlineProductOnce();
      }
    } else {
      if (mounted) {
        context.read<CategoryLocalBloc>().add(
          const CategoryLocalEvent.fetchLocal(),
        );
        context.read<ProductLocalBloc>().add(
          const ProductLocalEvent.fetchLocal(),
        );
      }
    }
  }

  void _fetchOnlineProductOnce() {
    _hasFetchedOnlineData = true;
    context.read<CategoryBloc>().add(const CategoryEvent.getCategories());
    context.read<ProductBloc>().add(ProductEvent.getProducts());
  }

  Future<void> _refreshProducts({required bool isOffline}) async {
    if (isOffline) {
      context.read<CategoryLocalBloc>().add(
        const CategoryLocalEvent.fetchLocal(),
      );
      context.read<ProductLocalBloc>().add(
        const ProductLocalEvent.fetchLocal(),
      );
      return;
    }

    context.read<CategoryBloc>().add(const CategoryEvent.getCategories());
    context.read<ProductBloc>().add(ProductEvent.getProducts());
  }

  List<Product> _filterProducts(List<Product> products) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return products;

    return products.where((product) {
      final name = (product.name ?? '').toLowerCase();
      final category = (product.category?.name ?? '').toLowerCase();
      final barcode = (product.barcode ?? '').toLowerCase();
      final sku = (product.sku ?? '').toLowerCase();
      final description = (product.description ?? '').toLowerCase();

      return name.contains(query) ||
          category.contains(query) ||
          barcode.contains(query) ||
          sku.contains(query) ||
          description.contains(query);
    }).toList();
  }

  void _openProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailProductPage(data: product)),
    );
  }

  void _openAddProductPage(List<dynamic> categories) {
    if (categories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tambahkan kategori terlebih dulu'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProductPage()),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: const [
        _ProductSummarySkeleton(),
        SpaceHeight(16),
        AppCard(child: Skeleton(height: 52, borderRadius: 12)),
        SpaceHeight(16),
        _ProductTileSkeleton(),
        SpaceHeight(12),
        _ProductTileSkeleton(),
        SpaceHeight(12),
        _ProductTileSkeleton(),
      ],
    );
  }

  Widget _buildErrorState(String message, {required bool isOffline}) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        _ProductSummaryCard(
          totalProducts: 0,
          visibleProducts: 0,
          isOffline: isOffline,
        ),
        const SpaceHeight(24),
        AppEmptyState(
          icon: Icons.error_outline_rounded,
          title: 'Produk gagal dimuat',
          subtitle: message,
          actionLabel: 'Coba Lagi',
          onAction: () => _refreshProducts(isOffline: isOffline),
        ),
      ],
    );
  }

  Widget _buildEmptyState({required bool isOffline}) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        _ProductSummaryCard(
          totalProducts: 0,
          visibleProducts: 0,
          isOffline: isOffline,
        ),
        const SpaceHeight(24),
        AppCard(
          child: Column(
            children: [
              const AppEmptyState(
                icon: Icons.inventory_2_outlined,
                title: 'Belum ada produk',
                subtitle:
                    'Tambahkan produk agar katalog item dan proses transaksi lebih siap digunakan.',
              ),
              if (isOffline) ...[
                const SpaceHeight(12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning50,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.warning100),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.wifi_off_rounded,
                        size: 18,
                        color: AppColors.warning700,
                      ),
                      const SpaceWidth(8),
                      Expanded(
                        child: Text(
                          'Anda sedang offline. Produk baru akan tersinkron saat koneksi kembali tersedia.',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.warning700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductContent(
    List<Product> products, {
    required bool isOffline,
  }) {
    if (products.isEmpty) {
      return _buildEmptyState(isOffline: isOffline);
    }

    final filteredProducts = _filterProducts(products);

    return RefreshIndicator(
      onRefresh: () => _refreshProducts(isOffline: isOffline),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          _ProductSummaryCard(
            totalProducts: products.length,
            visibleProducts: filteredProducts.length,
            isOffline: isOffline,
          ),
          const SpaceHeight(16),
          AppCard(
            variant: AppCardVariant.outlined,
            child: AppSearchField(
              controller: _searchController,
              hint: 'Cari produk, kategori, barcode, SKU, atau deskripsi',
              onChanged: (_) => setState(() {}),
              onClear: () => setState(() {}),
            ),
          ),
          const SpaceHeight(18),
          Row(
            children: [
              Text(
                'Daftar produk',
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
                child: _ProductTile(
                  product: product,
                  isOffline: isOffline,
                  onTap: () => _openProductDetail(product),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return BlocBuilder<OnlineCheckerBloc, OnlineCheckerState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          online: () {
            return BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                final categories = state.maybeWhen(
                  orElse: () => <dynamic>[],
                  success: (data) => data,
                );

                return FloatingActionButton(
                  backgroundColor: AppColors.primary,
                  tooltip: 'Tambah Produk',
                  onPressed: () => _openAddProductPage(categories),
                  child: const Icon(Icons.add, color: AppColors.white),
                );
              },
            );
          },
          offline: () {
            return BlocBuilder<CategoryLocalBloc, CategoryLocalState>(
              builder: (context, state) {
                final categories = state.maybeWhen(
                  orElse: () => <dynamic>[],
                  success: (data) => data,
                );

                return FloatingActionButton(
                  backgroundColor: AppColors.primary,
                  tooltip: 'Tambah Produk',
                  onPressed: () => _openAddProductPage(categories),
                  child: const Icon(Icons.add, color: AppColors.white),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Produk',
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
      body: BlocBuilder<OnlineCheckerBloc, OnlineCheckerState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: _buildLoadingState,
            online: () {
              return BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: _buildLoadingState,
                    loading: _buildLoadingState,
                    error: (message) =>
                        _buildErrorState(message, isOffline: false),
                    success: (data) =>
                        _buildProductContent(data, isOffline: false),
                  );
                },
              );
            },
            offline: () {
              return BlocBuilder<ProductLocalBloc, ProductLocalState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: _buildLoadingState,
                    loading: _buildLoadingState,
                    error: (message) =>
                        _buildErrorState(message, isOffline: true),
                    success: (data) =>
                        _buildProductContent(data, isOffline: true),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }
}

class _ProductSummaryCard extends StatelessWidget {
  const _ProductSummaryCard({
    required this.totalProducts,
    required this.visibleProducts,
    required this.isOffline,
  });

  final int totalProducts;
  final int visibleProducts;
  final bool isOffline;

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
                        Icons.inventory_2_outlined,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    _ProductStatusBadge(isOffline: isOffline),
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
                      : 'Produk aktif di katalog',
                  style: AppTypography.titleMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SpaceHeight(8),
                Text(
                  isOffline
                      ? 'Anda sedang melihat data lokal. Detail terbaru akan diperbarui kembali saat online.'
                      : 'Kelola katalog produk, cek harga, dan buka detail item dari satu halaman.',
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

class _ProductStatusBadge extends StatelessWidget {
  const _ProductStatusBadge({required this.isOffline});

  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    final icon = isOffline
        ? Icons.cloud_off_outlined
        : Icons.cloud_done_outlined;
    final label = isOffline ? 'Offline' : 'Online';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SpaceWidth(6),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({
    required this.product,
    required this.isOffline,
    required this.onTap,
  });

  final Product product;
  final bool isOffline;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final productName = (product.name ?? '').trim().isEmpty
        ? 'Produk tanpa nama'
        : product.name!.trim();
    final rawCategoryName = product.category?.name?.trim();
    final categoryName = (rawCategoryName == null || rawCategoryName.isEmpty)
        ? 'Tanpa kategori'
        : rawCategoryName;
    final skuText = (product.sku ?? '').trim();
    final barcodeText = (product.barcode ?? '').trim();

    return AppCard(
      onTap: onTap,
      padding: AppSpacing.allLg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProductThumbnail(product: product),
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
                    _ProductChip(
                      icon: isOffline
                          ? Icons.cloud_off_outlined
                          : Icons.verified_outlined,
                      label: isOffline ? 'Data lokal' : 'Tersinkron',
                    ),
                    if (skuText.isNotEmpty)
                      _ProductChip(
                        icon: Icons.qr_code_2_rounded,
                        label: skuText,
                      )
                    else if (barcodeText.isNotEmpty)
                      _ProductChip(
                        icon: Icons.barcode_reader,
                        label: barcodeText,
                      )
                    else
                      const _ProductChip(
                        icon: Icons.receipt_long_outlined,
                        label: 'Lihat detail',
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

class _ProductThumbnail extends StatelessWidget {
  const _ProductThumbnail({required this.product});

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
              _FallbackProductThumbnail(product: product),
        ),
      );
    }

    return _FallbackProductThumbnail(product: product);
  }
}

class _FallbackProductThumbnail extends StatelessWidget {
  const _FallbackProductThumbnail({required this.product});

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

class _ProductChip extends StatelessWidget {
  const _ProductChip({required this.icon, required this.label});

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
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 140),
            child: Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductSummarySkeleton extends StatelessWidget {
  const _ProductSummarySkeleton();

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
              Skeleton(width: 76, height: 32, borderRadius: 999),
            ],
          ),
          SpaceHeight(18),
          Skeleton(width: 72, height: 36, borderRadius: 12),
          SpaceHeight(8),
          Skeleton(width: 180, height: 16, borderRadius: 8),
          SpaceHeight(8),
          Skeleton(width: double.infinity, height: 12, borderRadius: 8),
          SpaceHeight(8),
          Skeleton(width: 220, height: 12, borderRadius: 8),
        ],
      ),
    );
  }
}

class _ProductTileSkeleton extends StatelessWidget {
  const _ProductTileSkeleton();

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
                Skeleton(width: 140, height: 12, borderRadius: 8),
                SpaceHeight(12),
                Row(
                  children: [
                    Skeleton(width: 96, height: 28, borderRadius: 999),
                    SpaceWidth(8),
                    Skeleton(width: 88, height: 28, borderRadius: 999),
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
