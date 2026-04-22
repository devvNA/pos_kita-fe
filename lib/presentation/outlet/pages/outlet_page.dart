import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/components/spaces.dart';
import 'package:pos_kita/core/design_system/design_system.dart' as ds;
import 'package:pos_kita/data/models/responses/me_response_model.dart';
import 'package:pos_kita/presentation/home/widgets/drawer_widget.dart';
import 'package:pos_kita/presentation/outlet/bloc/outlet/outlet_bloc.dart';
import 'package:pos_kita/presentation/outlet/pages/add_outlet_page.dart';
import 'package:pos_kita/presentation/outlet/pages/detail_outlet_page.dart';

class OutletPage extends StatefulWidget {
  const OutletPage({super.key, required this.outletName});

  final String outletName;

  @override
  State<OutletPage> createState() => _OutletPageState();
}

class _OutletPageState extends State<OutletPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<OutletBloc>().add(OutletEvent.getOutlets());
  }

  void _reloadOutlets() {
    context.read<OutletBloc>().add(OutletEvent.getOutlets());
  }

  void _openDetailPage(Outlet outlet) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailOutletPage(outlet: outlet)),
    );
  }

  void _openAddOutletPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddOutletPage()),
    );
  }

  String _displayName(Outlet outlet) {
    final name = outlet.name?.trim() ?? '';
    return name.isNotEmpty ? name : 'Outlet tanpa nama';
  }

  String _displayAddress(Outlet outlet) {
    final address = outlet.address?.trim() ?? '';
    return address.isNotEmpty ? address : 'Alamat outlet belum tersedia';
  }

  String _displayPhone(Outlet outlet) {
    final phone = outlet.phone?.toString().trim() ?? '';
    return phone.isNotEmpty ? phone : 'Kontak belum tersedia';
  }

  Widget _buildLoadingState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: const [
        _OutletSummarySkeleton(),
        SpaceHeight(16),
        _OutletTileSkeleton(),
        SpaceHeight(12),
        _OutletTileSkeleton(),
        SpaceHeight(12),
        _OutletTileSkeleton(),
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        const _OutletSummaryCard(count: 0),
        const SpaceHeight(24),
        ds.AppEmptyState(
          icon: Icons.storefront_outlined,
          title: 'Outlet gagal dimuat',
          subtitle: message,
          actionLabel: 'Coba Lagi',
          onAction: _reloadOutlets,
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        const _OutletSummaryCard(count: 0),
        const SpaceHeight(24),
        ds.AppEmptyState(
          icon: Icons.store_mall_directory_outlined,
          title: 'Belum Ada Outlet',
          subtitle:
              'Tambahkan outlet baru untuk membagi operasional bisnis dan memudahkan pengelolaan staff.',
          actionLabel: 'Tambah Outlet',
          onAction: _openAddOutletPage,
        ),
      ],
    );
  }

  Widget _buildOutletContent(List<Outlet> outlets) {
    if (outlets.isEmpty) return _buildEmptyState();

    return RefreshIndicator(
      onRefresh: () async => _reloadOutlets(),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: outlets.length + 2,
        separatorBuilder: (_, index) =>
            index == 0 ? const SpaceHeight(16) : const SpaceHeight(12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _OutletSummaryCard(count: outlets.length);
          }

          if (index == 1) {
            return Row(
              children: [
                Text(
                  'Daftar outlet',
                  style: ds.AppTypography.titleLarge.copyWith(
                    color: ds.AppColors.textPrimary,
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
                    color: ds.AppColors.surface,
                    borderRadius: BorderRadius.circular(ds.AppRadius.full),
                    border: Border.all(color: ds.AppColors.border),
                  ),
                  child: Text(
                    '${outlets.length} item',
                    style: ds.AppTypography.labelSmall.copyWith(
                      color: ds.AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            );
          }

          final outlet = outlets[index - 2];
          return _OutletTile(
            outlet: outlet,
            title: _displayName(outlet),
            address: _displayAddress(outlet),
            phone: _displayPhone(outlet),
            onTap: () => _openDetailPage(outlet),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ds.AppColors.background,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: Text(
          widget.outletName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(Icons.menu, color: ds.AppColors.white),
        ),
      ),
      body: BlocBuilder<OutletBloc, OutletState>(
        builder: (context, state) {
          return state.maybeWhen(
            initial: _buildLoadingState,
            loading: _buildLoadingState,
            error: _buildErrorState,
            loaded: _buildOutletContent,
            orElse: _buildLoadingState,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddOutletPage,
        backgroundColor: ds.AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _OutletSummaryCard extends StatelessWidget {
  const _OutletSummaryCard({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return ds.AppCard(
      variant: ds.AppCardVariant.elevated,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: ds.AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(ds.AppRadius.lg),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.storefront_outlined,
              color: ds.AppColors.primary,
            ),
          ),
          const SpaceWidth(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count outlet aktif',
                  style: ds.AppTypography.titleMedium.copyWith(
                    color: ds.AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SpaceHeight(4),
                Text(
                  'Kelola cabang dan lihat detail outlet bisnis Anda di sini.',
                  style: ds.AppTypography.bodySmall.copyWith(
                    color: ds.AppColors.textSecondary,
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

class _OutletTile extends StatelessWidget {
  const _OutletTile({
    required this.outlet,
    required this.title,
    required this.address,
    required this.phone,
    required this.onTap,
  });

  final Outlet outlet;
  final String title;
  final String address;
  final String phone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ds.AppCard(
      variant: ds.AppCardVariant.elevated,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: ds.AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(ds.AppRadius.lg),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.store_rounded,
              color: ds.AppColors.primary,
              size: 24,
            ),
          ),
          const SpaceWidth(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: ds.AppTypography.titleMedium.copyWith(
                    color: ds.AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SpaceHeight(6),
                Text(
                  address,
                  style: ds.AppTypography.bodySmall.copyWith(
                    color: ds.AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpaceHeight(10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _OutletChip(icon: Icons.phone_outlined, label: phone),
                    _OutletChip(
                      icon: Icons.arrow_outward_rounded,
                      label: 'Lihat detail',
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
              color: ds.AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(ds.AppRadius.md),
              border: Border.all(color: ds.AppColors.border),
            ),
            child: const Icon(
              Icons.chevron_right_rounded,
              color: ds.AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _OutletChip extends StatelessWidget {
  const _OutletChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: ds.AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(ds.AppRadius.full),
        border: Border.all(color: ds.AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: ds.AppColors.textSecondary),
          const SpaceWidth(6),
          Text(
            label,
            style: ds.AppTypography.labelSmall.copyWith(
              color: ds.AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _OutletSummarySkeleton extends StatelessWidget {
  const _OutletSummarySkeleton();

  @override
  Widget build(BuildContext context) {
    return ds.AppCard(
      child: Row(
        children: const [
          ds.Skeleton(width: 52, height: 52, borderRadius: 16),
          SpaceWidth(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ds.Skeleton(width: 140, height: 18, borderRadius: 8),
                SpaceHeight(8),
                ds.Skeleton(
                  width: double.infinity,
                  height: 12,
                  borderRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OutletTileSkeleton extends StatelessWidget {
  const _OutletTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return ds.AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ds.Skeleton(width: 52, height: 52, borderRadius: 16),
          SpaceWidth(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ds.Skeleton(width: 180, height: 16, borderRadius: 8),
                SpaceHeight(8),
                ds.Skeleton(
                  width: double.infinity,
                  height: 12,
                  borderRadius: 8,
                ),
                SpaceHeight(8),
                ds.Skeleton(width: 220, height: 12, borderRadius: 8),
                SpaceHeight(12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ds.Skeleton(width: 110, height: 28, borderRadius: 999),
                    ds.Skeleton(width: 96, height: 28, borderRadius: 999),
                  ],
                ),
              ],
            ),
          ),
          SpaceWidth(8),
          ds.Skeleton(width: 40, height: 40, borderRadius: 12),
        ],
      ),
    );
  }
}
