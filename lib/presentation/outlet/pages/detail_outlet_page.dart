import 'package:flutter/material.dart';
import 'package:pos_kita/core/components/spaces.dart';
import 'package:pos_kita/core/design_system/design_system.dart' as ds;
import 'package:pos_kita/data/models/responses/me_response_model.dart';
import 'package:pos_kita/presentation/outlet/pages/edit_outlet_page.dart';

class DetailOutletPage extends StatefulWidget {
  const DetailOutletPage({super.key, required this.outlet});

  final Outlet outlet;

  @override
  State<DetailOutletPage> createState() => _DetailOutletPageState();
}

class _DetailOutletPageState extends State<DetailOutletPage> {
  String _fallback(String? value, String fallback) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? fallback : text;
  }

  void _openEditPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditOutletPage(outlet: widget.outlet),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final outletName = _fallback(widget.outlet.name, 'Outlet tanpa nama');
    final outletAddress = _fallback(
      widget.outlet.address,
      'Alamat outlet belum ditambahkan.',
    );
    final outletPhone = _fallback(
      widget.outlet.phone,
      'Nomor telepon belum tersedia.',
    );
    final outletDescription = _fallback(
      widget.outlet.description,
      'Belum ada deskripsi outlet.',
    );

    return Scaffold(
      backgroundColor: ds.AppColors.background,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Detail Outlet',
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
            color: ds.AppColors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          ds.AppCard(
            variant: ds.AppCardVariant.elevated,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informasi Outlet',
                  style: ds.AppTypography.titleLarge.copyWith(
                    color: ds.AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SpaceHeight(4),
                Text(
                  'Detail kontak dan keterangan outlet yang sedang aktif.',
                  style: ds.AppTypography.bodySmall.copyWith(
                    color: ds.AppColors.textSecondary,
                  ),
                ),
                const SpaceHeight(16),
                _DetailItem(
                  icon: Icons.badge_outlined,
                  label: 'Nama Outlet',
                  value: outletName,
                ),
                const SpaceHeight(12),
                _DetailItem(
                  icon: Icons.location_on_outlined,
                  label: 'Alamat Outlet',
                  value: outletAddress,
                ),
                const SpaceHeight(12),
                _DetailItem(
                  icon: Icons.phone_outlined,
                  label: 'Nomor Telepon',
                  value: outletPhone,
                ),
                const SpaceHeight(12),
                _DetailItem(
                  icon: Icons.description_outlined,
                  label: 'Deskripsi Outlet',
                  value: outletDescription,
                ),
              ],
            ),
          ),
          const SpaceHeight(24),
          ds.AppButton.filled(
            onPressed: _openEditPage,
            label: 'Edit Outlet',
            size: ds.AppButtonSize.large,
            width: double.infinity,
            prefixIcon: const Icon(Icons.edit_rounded),
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ds.AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(ds.AppRadius.lg),
        border: Border.all(color: ds.AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ds.AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(ds.AppRadius.md),
            ),
            child: Icon(icon, color: ds.AppColors.primary),
          ),
          const SpaceWidth(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: ds.AppTypography.labelMedium.copyWith(
                    color: ds.AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SpaceHeight(4),
                Text(
                  value,
                  style: ds.AppTypography.bodyMedium.copyWith(
                    color: ds.AppColors.textPrimary,
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
