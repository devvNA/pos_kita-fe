import 'package:flutter/material.dart';
import 'package:pos_kita/core/components/spaces.dart';
import 'package:pos_kita/core/design_system/design_system.dart' as ds;
import 'package:pos_kita/data/models/responses/me_response_model.dart';
import 'package:pos_kita/presentation/staff/pages/edit_staff_page.dart';

class DetailStaffPage extends StatelessWidget {
  const DetailStaffPage({super.key, required this.user});

  final UserModel user;

  bool get _isEditableRole => const [2, 3].contains(user.role?.id);

  String get _displayName {
    final String name = user.name?.trim() ?? '';
    return name.isNotEmpty ? name : 'Tanpa Nama';
  }

  String get _email {
    final String email = user.email?.trim() ?? '';
    return email.isNotEmpty ? email : 'Email belum tersedia';
  }

  String get _roleLabel {
    final String roleName = user.role?.name.trim() ?? '';
    return roleName.isNotEmpty ? roleName : 'Role belum diatur';
  }

  String get _outletLabel {
    final String outletName = user.outlet?.name?.trim() ?? '';
    if (outletName.isNotEmpty) {
      return outletName;
    }

    final bool isPrimaryRole = !const [2, 3].contains(user.role?.id);
    return isPrimaryRole ? 'Semua outlet' : 'Outlet belum ditetapkan';
  }

  String get _initials {
    final List<String> words = _displayName
        .split(' ')
        .where((word) => word.trim().isNotEmpty)
        .toList();

    if (words.isEmpty) return 'ST';
    if (words.length == 1) return words.first.substring(0, 1).toUpperCase();
    return '${words.first.substring(0, 1)}${words[1].substring(0, 1)}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Staff',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ds.AppCard(
              variant: ds.AppCardVariant.elevated,
              child: Column(
                children: [
                  Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      color: ds.AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _initials,
                      style: ds.AppTypography.headlineSmall.copyWith(
                        color: ds.AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SpaceHeight(16),
                  Text(
                    _displayName,
                    textAlign: TextAlign.center,
                    style: ds.AppTypography.headlineSmall.copyWith(
                      color: ds.AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SpaceHeight(4),
                  Text(
                    _email,
                    textAlign: TextAlign.center,
                    style: ds.AppTypography.bodyMedium.copyWith(
                      color: ds.AppColors.textSecondary,
                    ),
                  ),
                  const SpaceHeight(14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _MetaChip(icon: Icons.badge_outlined, label: _roleLabel),
                      _MetaChip(
                        icon: Icons.storefront_outlined,
                        label: _outletLabel,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SpaceHeight(16),
            ds.AppCard(
              variant: ds.AppCardVariant.elevated,
              child: Column(
                children: [
                  _DetailRow(label: 'Nama Staff', value: _displayName),
                  const Divider(height: 24),
                  _DetailRow(label: 'Email Staff', value: _email),
                  const Divider(height: 24),
                  _DetailRow(label: 'Role', value: _roleLabel),
                  const Divider(height: 24),
                  _DetailRow(label: 'Outlet', value: _outletLabel),
                ],
              ),
            ),
            if (!_isEditableRole) ...[
              const SpaceHeight(16),
              ds.AppCard(
                variant: ds.AppCardVariant.flat,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: ds.AppColors.primary,
                    ),
                    const SpaceWidth(10),
                    Expanded(
                      child: Text(
                        'Role ini tidak dapat diedit dari menu staff. '
                        'Data owner/admin mengikuti pengaturan bisnis utama.',
                        style: ds.AppTypography.bodySmall.copyWith(
                          color: ds.AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SpaceHeight(24),
            ds.AppButton.filled(
              onPressed: _isEditableRole
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditStaffPage(user: user),
                        ),
                      );
                    }
                  : null,
              label: _isEditableRole ? 'Edit Staff' : 'Edit Tidak Tersedia',
              size: ds.AppButtonSize.large,
              isDisabled: !_isEditableRole,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: ds.AppTypography.labelMedium.copyWith(
                  color: ds.AppColors.textSecondary,
                ),
              ),
              const SpaceHeight(6),
              Text(
                value,
                style: ds.AppTypography.titleMedium.copyWith(
                  color: ds.AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: ds.AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(999),
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
