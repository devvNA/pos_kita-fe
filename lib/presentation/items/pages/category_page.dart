import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/components/spaces.dart';
import 'package:pos_kita/core/design_system/components/app_card.dart';
import 'package:pos_kita/core/design_system/components/app_empty_state.dart';
import 'package:pos_kita/core/design_system/components/app_skeleton.dart';
import 'package:pos_kita/core/design_system/tokens/colors.dart';
import 'package:pos_kita/core/design_system/tokens/shadows.dart';
import 'package:pos_kita/core/design_system/tokens/typography.dart';
import 'package:pos_kita/data/models/responses/category_response_model.dart';
import 'package:pos_kita/presentation/items/bloc/category/category_bloc.dart';
import 'package:pos_kita/presentation/items/pages/add_category_page.dart';
import 'package:pos_kita/presentation/items/pages/edit_category_page.dart';

import '../../home/bloc/online_checker/online_checker_bloc.dart';
import '../bloc/category_local/category_local_bloc.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool _hasFetchedOnlineData = false;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();

    Connectivity().checkConnectivity().then(_handleConnectivity);
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      _handleConnectivity,
    );
  }

  void _handleConnectivity(List<ConnectivityResult> list) {
    final isOnline =
        list.contains(ConnectivityResult.mobile) ||
        list.contains(ConnectivityResult.wifi);

    // update status ke OnlineCheckerBloc
    if (mounted) {
      context.read<OnlineCheckerBloc>().add(OnlineCheckerEvent.check(isOnline));
    }

    if (isOnline) {
      // hanya sinkron produk & kategori sekali
      if (mounted) {
        if (!_hasFetchedOnlineData) _fetchOnlineProductOnce();
      }
    } else {
      if (mounted) {
        context.read<CategoryLocalBloc>().add(
          const CategoryLocalEvent.fetchLocal(),
        );
      }
    }
  }

  void _fetchOnlineProductOnce() {
    _hasFetchedOnlineData = true;
    context.read<CategoryBloc>().add(const CategoryEvent.getCategories());
  }

  void _fetchOfflineCategories() {
    context.read<CategoryLocalBloc>().add(
      const CategoryLocalEvent.fetchLocal(),
    );
  }

  void _openAddCategoryPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCategoryPage()),
    );
  }

  void _openEditCategoryPage(Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCategoryPage(category: category),
      ),
    );
  }

  Future<void> _refreshCategories(bool isOffline) async {
    if (isOffline) {
      _fetchOfflineCategories();
      return;
    }

    context.read<CategoryBloc>().add(const CategoryEvent.getCategories());
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Widget _buildLoadingState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: const [
        _CategorySummarySkeleton(),
        SpaceHeight(16),
        _CategoryTileSkeleton(),
        SpaceHeight(12),
        _CategoryTileSkeleton(),
        SpaceHeight(12),
        _CategoryTileSkeleton(),
      ],
    );
  }

  Widget _buildErrorState(String message, {required bool isOffline}) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        _CategorySummaryCard(count: 0, isOffline: isOffline),
        const SpaceHeight(24),
        AppEmptyState(
          icon: Icons.error_outline_rounded,
          title: 'Kategori gagal dimuat',
          subtitle: message,
          actionLabel: 'Coba Lagi',
          onAction: () => _refreshCategories(isOffline),
        ),
      ],
    );
  }

  Widget _buildEmptyState({required bool isOffline}) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        _CategorySummaryCard(count: 0, isOffline: isOffline),
        const SpaceHeight(24),
        AppCard(
          child: Column(
            children: [
              EmptyCategories(onAddCategory: _openAddCategoryPage),
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
                          'Anda sedang offline. Kategori baru akan tersinkron saat koneksi kembali normal.',
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

  Widget _buildCategoryContent(
    List<Category> categories, {
    required bool isOffline,
  }) {
    if (categories.isEmpty) {
      return _buildEmptyState(isOffline: isOffline);
    }

    return RefreshIndicator(
      onRefresh: () => _refreshCategories(isOffline),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: categories.length + 2,
        separatorBuilder: (_, index) =>
            index == 0 ? const SpaceHeight(16) : const SpaceHeight(12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _CategorySummaryCard(
              count: categories.length,
              isOffline: isOffline,
            );
          }

          if (index == 1) {
            return Row(
              children: [
                Text(
                  'Daftar kategori',
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
                    '${categories.length} item',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            );
          }

          final category = categories[index - 2];
          return _CategoryTile(
            category: category,
            isOffline: isOffline,
            onTap: () => _openEditCategoryPage(category),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.white,
          ),
        ),
        title: const Text(
          'Kategori',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<OnlineCheckerBloc, OnlineCheckerState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: _buildLoadingState,
            online: () {
              return BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  return state.map(
                    initial: (_) => _buildLoadingState(),
                    loading: (_) => _buildLoadingState(),
                    error: (error) =>
                        _buildErrorState(error.message, isOffline: false),
                    success: (success) =>
                        _buildCategoryContent(success.data, isOffline: false),
                  );
                },
              );
            },
            offline: () {
              return BlocBuilder<CategoryLocalBloc, CategoryLocalState>(
                builder: (context, state) {
                  return state.map(
                    initial: (_) => _buildLoadingState(),
                    loading: (_) => _buildLoadingState(),
                    error: (error) =>
                        _buildErrorState(error.message, isOffline: true),
                    success: (success) => _buildCategoryContent(
                      success.categories,
                      isOffline: true,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: _openAddCategoryPage,
        tooltip: 'Tambah Kategori',
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}

class _CategorySummaryCard extends StatelessWidget {
  const _CategorySummaryCard({required this.count, required this.isOffline});

  final int count;
  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.md,
      ),
      child: Stack(
        children: [
          Positioned(
            top: -18,
            right: -10,
            child: Container(
              width: 92,
              height: 92,
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
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: const Icon(
                        Icons.folder_copy_outlined,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    _StatusBadge(isOffline: isOffline),
                  ],
                ),
                const SpaceHeight(18),
                Text(
                  count.toString(),
                  style: AppTypography.displaySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SpaceHeight(4),
                Text(
                  count == 1
                      ? 'Kategori tersedia'
                      : 'Kategori tersedia saat ini',
                  style: AppTypography.titleMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SpaceHeight(8),
                Text(
                  isOffline
                      ? 'Anda sedang melihat data lokal. Perubahan akan disinkronkan saat online.'
                      : 'Atur kategori agar daftar produk lebih rapi dan proses kasir lebih cepat.',
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

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isOffline});

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

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.isOffline,
    required this.onTap,
  });

  final Category category;
  final bool isOffline;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final displayName = (category.name ?? '').trim().isEmpty
        ? 'Kategori tanpa nama'
        : category.name!.trim();
    final categoryId = category.id ?? category.categoryId;

    return AppCard(
      variant: AppCardVariant.elevated,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.inventory_2_outlined,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SpaceWidth(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpaceHeight(6),
                Text(
                  categoryId != null
                      ? 'ID kategori #$categoryId'
                      : 'Kategori siap digunakan',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SpaceHeight(10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _CategoryChip(
                      icon: isOffline
                          ? Icons.cloud_off_outlined
                          : Icons.verified_outlined,
                      label: isOffline ? 'Data lokal' : 'Tersinkron',
                    ),
                    _CategoryChip(
                      icon: Icons.edit_note_rounded,
                      label: 'Tap untuk edit',
                    ),
                  ],
                ),
              ],
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
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.icon, required this.label});

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

class _CategorySummarySkeleton extends StatelessWidget {
  const _CategorySummarySkeleton();

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

class _CategoryTileSkeleton extends StatelessWidget {
  const _CategoryTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Skeleton(width: 52, height: 52, borderRadius: 16),
          SpaceWidth(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(width: double.infinity, height: 16, borderRadius: 8),
                SpaceHeight(8),
                Skeleton(width: 120, height: 12, borderRadius: 8),
                SpaceHeight(12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Skeleton(width: 92, height: 28, borderRadius: 999),
                    Skeleton(width: 98, height: 28, borderRadius: 999),
                  ],
                ),
              ],
            ),
          ),
          SpaceWidth(8),
          Skeleton(width: 40, height: 40, borderRadius: 12),
        ],
      ),
    );
  }
}
