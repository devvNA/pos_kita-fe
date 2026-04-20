import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/components/spaces.dart';
import 'package:pos_kita/core/design_system/components/app_card.dart';
import 'package:pos_kita/core/design_system/components/app_empty_state.dart';
import 'package:pos_kita/core/design_system/tokens/colors.dart';
import 'package:pos_kita/core/design_system/tokens/typography.dart';
import 'package:pos_kita/data/models/responses/me_response_model.dart';
import 'package:pos_kita/presentation/staff/bloc/staff/staff_bloc.dart';
import 'package:pos_kita/presentation/staff/pages/add_staff_page.dart';
import 'package:pos_kita/presentation/staff/pages/detail_staff_page.dart';

import '../../home/widgets/drawer_widget.dart';

class StaffPage extends StatefulWidget {
  const StaffPage({super.key});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<StaffBloc>().add(const StaffEvent.getStaffs());
  }

  void _reloadStaffs() {
    context.read<StaffBloc>().add(const StaffEvent.getStaffs());
  }

  String _displayName(UserModel user) {
    final String name = user.name?.trim() ?? '';
    return name.isNotEmpty ? name : 'Tanpa Nama';
  }

  String _roleLabel(UserModel user) {
    final String roleName = user.role?.name.trim() ?? '';
    return roleName.isNotEmpty ? roleName : 'Role belum diatur';
  }

  String _outletLabel(UserModel user) {
    final String outletName = user.outlet?.name?.trim() ?? '';
    if (outletName.isNotEmpty) {
      return outletName;
    }

    final bool isPrimaryRole = !const [2, 3].contains(user.role?.id);
    return isPrimaryRole ? 'Semua outlet' : 'Outlet belum ditetapkan';
  }

  String _emailLabel(UserModel user) {
    final String email = user.email?.trim() ?? '';
    return email.isNotEmpty ? email : 'Email belum tersedia';
  }

  String _initials(UserModel user) {
    final List<String> words = _displayName(
      user,
    ).split(' ').where((word) => word.trim().isNotEmpty).toList();

    if (words.isEmpty) return 'ST';
    if (words.length == 1) return words.first.substring(0, 1).toUpperCase();
    return '${words.first.substring(0, 1)}${words[1].substring(0, 1)}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text(
          'Manajemen Staff',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(Icons.menu, color: AppColors.white),
        ),
      ),
      body: BlocBuilder<StaffBloc, StaffState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) =>
                EmptyError(message: message, onRetry: _reloadStaffs),
            loaded: (data) {
              if (data.isEmpty) {
                return AppEmptyState(
                  icon: Icons.people_outline_rounded,
                  title: 'Belum Ada Staff',
                  subtitle:
                      'Tambahkan staff baru untuk mengelola kasir dan operasional outlet.',
                  actionLabel: 'Muat Ulang',
                  onAction: _reloadStaffs,
                );
              }

              return RefreshIndicator(
                onRefresh: () async => _reloadStaffs(),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: data.length,
                  separatorBuilder: (_, _) => const SpaceHeight(12),
                  itemBuilder: (context, index) {
                    final UserModel user = data[index];

                    return AppCard(
                      variant: AppCardVariant.elevated,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailStaffPage(user: user),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _initials(user),
                              style: AppTypography.titleMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SpaceWidth(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _displayName(user),
                                  style: AppTypography.titleMedium.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SpaceHeight(4),
                                Text(
                                  _emailLabel(user),
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SpaceHeight(10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _InfoChip(
                                      icon: Icons.badge_outlined,
                                      label: _roleLabel(user),
                                    ),
                                    _InfoChip(
                                      icon: Icons.storefront_outlined,
                                      label: _outletLabel(user),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SpaceWidth(8),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.textTertiary,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        tooltip: 'Tambah Staff',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddStaffPage()),
          );
        },
        child: const Icon(Icons.add, color: AppColors.white),
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
        borderRadius: BorderRadius.circular(999),
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
