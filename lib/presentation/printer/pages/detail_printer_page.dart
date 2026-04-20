import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/data/models/requests/printer_request_model.dart';
import 'package:pos_kita/presentation/printer/bloc/printer/printer_bloc.dart';

class DetailPrinterPage extends StatefulWidget {
  final PrinterModel data;
  const DetailPrinterPage({super.key, required this.data});

  @override
  State<DetailPrinterPage> createState() => _DetailPrinterPageState();
}

class _DetailPrinterPageState extends State<DetailPrinterPage> {
  bool _isDeleting = false;

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        title: Text(
          'Hapus Printer',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus printer "${widget.data.name}"? Tindakan ini tidak dapat dibatalkan.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Batal',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Hapus',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.error500,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isDeleting = true);

    context.read<PrinterBloc>().add(
      PrinterEvent.deletePrinter(widget.data.id ?? 0),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Printer berhasil dihapus'),
        backgroundColor: AppColors.success600,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  IconData _connectionIcon(String type) {
    switch (type.toLowerCase()) {
      case 'bluetooth':
        return Icons.bluetooth_rounded;
      case 'ethernet':
        return Icons.router_outlined;
      case 'usb':
        return Icons.usb_rounded;
      default:
        return Icons.print_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final printer = widget.data;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Gradient Header ──
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _HeaderBackButton(
                        onTap: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _connectionIcon(printer.connectionType),
                              color: Colors.white,
                              size: 16,
                            ),
                            AppSpacing.hGapXs,
                            Text(
                              printer.connectionType,
                              style: AppTypography.labelMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vGapLg,
                  Text(
                    printer.name,
                    style: AppTypography.headlineSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AppSpacing.vGapXs,
                  Text(
                    'Detail dan pengaturan printer.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),

            // ── Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.allLg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Info Card ──
                    AppCard(
                      padding: AppSpacing.allLg,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.primary50,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.lg,
                                  ),
                                ),
                                child: Icon(
                                  _connectionIcon(printer.connectionType),
                                  color: AppColors.primary,
                                ),
                              ),
                              AppSpacing.hGapMd,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Informasi Printer',
                                      style:
                                          AppTypography.titleLarge.copyWith(
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    AppSpacing.vGapXxs,
                                    Text(
                                      'Data konfigurasi yang tersimpan.',
                                      style:
                                          AppTypography.bodySmall.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          AppSpacing.vGapLg,
                          _DetailRow(
                            icon: Icons.label_outline_rounded,
                            label: 'Nama Printer',
                            value: printer.name,
                          ),
                          _DetailRow(
                            icon: Icons.settings_ethernet_rounded,
                            label: 'Tipe Koneksi',
                            value: printer.connectionType,
                          ),
                          _DetailRow(
                            icon: Icons.receipt_long_outlined,
                            label: 'Ukuran Kertas',
                            value: '${printer.paperWidth} mm',
                          ),
                          _DetailRow(
                            icon: Icons.star_outline_rounded,
                            label: 'Printer Default',
                            value: printer.isDefault ? 'Ya' : 'Tidak',
                            valueColor: printer.isDefault
                                ? AppColors.success600
                                : null,
                          ),
                          if (printer.macAddress != null &&
                              printer.macAddress!.isNotEmpty)
                            _DetailRow(
                              icon: Icons.bluetooth_rounded,
                              label: 'MAC Address',
                              value: printer.macAddress!,
                            ),
                          if (printer.ipAddress != null &&
                              printer.ipAddress!.isNotEmpty)
                            _DetailRow(
                              icon: Icons.language_rounded,
                              label: 'IP Address',
                              value: printer.ipAddress!,
                              isLast: true,
                            ),
                        ],
                      ),
                    ),

                    // ── Default badge ──
                    if (printer.isDefault) ...[
                      AppSpacing.vGapMd,
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.success50,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: AppColors.success100),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline_rounded,
                              color: AppColors.success600,
                              size: 20,
                            ),
                            AppSpacing.hGapSm,
                            Expanded(
                              child: Text(
                                'Printer ini diatur sebagai printer default untuk mencetak struk transaksi.',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.success700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    AppSpacing.vGapXl,

                    // ── Delete Button ──
                    AppButton.danger(
                      onPressed: _isDeleting ? null : _confirmDelete,
                      label: 'Hapus Printer',
                      size: AppButtonSize.large,
                      width: double.infinity,
                      isLoading: _isDeleting,
                      prefixIcon: const Icon(Icons.delete_outline_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private widgets
// ─────────────────────────────────────────────────────────────────────────────

class _HeaderBackButton extends StatelessWidget {
  const _HeaderBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: const SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              AppSpacing.hGapMd,
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Text(
                value,
                style: AppTypography.bodyMedium.copyWith(
                  color: valueColor ?? AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, color: AppColors.divider),
      ],
    );
  }
}
