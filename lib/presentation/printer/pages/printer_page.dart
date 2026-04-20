import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/data/models/requests/printer_request_model.dart';
import 'package:pos_kita/presentation/home/widgets/drawer_widget.dart';
import 'package:pos_kita/presentation/printer/bloc/printer/printer_bloc.dart';
import 'package:pos_kita/presentation/printer/pages/add_printer_page.dart';
import 'package:pos_kita/presentation/printer/pages/detail_printer_page.dart';

class PrinterPage extends StatefulWidget {
  const PrinterPage({super.key});

  @override
  State<PrinterPage> createState() => _PrinterPageState();
}

class _PrinterPageState extends State<PrinterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fetchPrinters();
  }

  void _fetchPrinters() {
    context.read<PrinterBloc>().add(const PrinterEvent.getPrinters());
  }

  Future<void> _openAddPrinterPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddPrinterPage()),
    );
    if (!mounted) return;
    _fetchPrinters();
  }

  Future<void> _openDetailPage(PrinterModel printer) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailPrinterPage(data: printer)),
    );
    if (!mounted) return;
    _fetchPrinters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: const DrawerWidget(),
      body: SafeArea(
        child: BlocConsumer<PrinterBloc, PrinterState>(
          listener: (context, state) {
            state.maybeWhen(
              error: (message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: AppColors.error500,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            final isLoading = state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async => _fetchPrinters(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: _PrinterHeader(
                      onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                      onAddTap: _openAddPrinterPage,
                    ),
                  ),
                  SliverPadding(
                    padding: AppSpacing.horizontalLg,
                    sliver: SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 16),
                        child: _PrinterSummaryCard(
                          printerCount: state.maybeWhen(
                            loaded: (data) => data.length,
                            orElse: () => 0,
                          ),
                          isLoading: isLoading,
                        ),
                      ),
                    ),
                  ),
                  ...state.maybeWhen(
                    loading: () => [_buildLoadingState()],
                    loaded: (data) {
                      if (data.isEmpty) {
                        return [_buildEmptyState()];
                      }

                      return [_buildPrinterList(data)];
                    },
                    error: (message) => [_buildErrorState(message)],
                    orElse: () => [_buildLoadingState()],
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: Container(
        decoration: AppShadows.fab,
        child: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          onPressed: _openAddPrinterPage,
          icon: const Icon(Icons.add_rounded),
          label: Text(
            'Tambah Printer',
            style: AppTypography.labelLarge.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList.builder(
        itemCount: 3,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.card),
              boxShadow: AppShadows.sm,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: AppEmptyState(
        icon: Icons.print_disabled_outlined,
        title: 'Belum ada printer',
        subtitle:
            'Tambahkan printer kasir agar proses cetak struk lebih cepat dan rapi.',
        onAction: _openAddPrinterPage,
        secondaryActionLabel: 'Muat Ulang',
        onSecondaryAction: _fetchPrinters,
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: EmptyError(message: message, onRetry: _fetchPrinters),
    );
  }

  Widget _buildPrinterList(List<PrinterModel> printers) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      sliver: SliverList.builder(
        itemCount: printers.length,
        itemBuilder: (context, index) {
          final printer = printers[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _PrinterTile(
              printer: printer,
              onTap: () => _openDetailPage(printer),
            ),
          );
        },
      ),
    );
  }
}

class _PrinterHeader extends StatelessWidget {
  const _PrinterHeader({required this.onMenuTap, required this.onAddTap});

  final VoidCallback onMenuTap;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: AppShadows.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _HeaderIconButton(icon: Icons.menu_rounded, onTap: onMenuTap),
              const Spacer(),
              _HeaderActionChip(onTap: onAddTap),
            ],
          ),
          AppSpacing.vGapLg,
          Text(
            'Kelola printer',
            style: AppTypography.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.vGapXs,
          Text(
            'Atur printer default, cek jenis koneksi, dan buka detail printer dari satu tempat.',
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrinterSummaryCard extends StatelessWidget {
  const _PrinterSummaryCard({
    required this.printerCount,
    required this.isLoading,
  });

  final int printerCount;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Icon(
              Icons.print_outlined,
              color: AppColors.primary,
              size: 26,
            ),
          ),
          AppSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Printer Tersimpan',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                AppSpacing.vGapXxs,
                Text(
                  isLoading ? 'Memuat...' : '$printerCount printer',
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.success50,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              'Aktif',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.success700,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrinterTile extends StatelessWidget {
  const _PrinterTile({required this.printer, required this.onTap});

  final PrinterModel printer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: AppSpacing.allMd,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: printer.isDefault
                  ? AppColors.primary50
                  : AppColors.neutral100,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(
              _connectionIcon(printer.connectionType),
              color: printer.isDefault
                  ? AppColors.primary
                  : AppColors.textSecondary,
              size: 24,
            ),
          ),
          AppSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        printer.name,
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (printer.isDefault)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success50,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          'Default',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.success700,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                AppSpacing.vGapXs,
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _MetaChip(
                      icon: Icons.settings_ethernet_rounded,
                      label: printer.connectionType,
                    ),
                    _MetaChip(
                      icon: Icons.receipt_long_outlined,
                      label: '${printer.paperWidth} mm',
                    ),
                    if ((printer.macAddress ?? '').isNotEmpty)
                      _MetaChip(
                        icon: Icons.bluetooth_rounded,
                        label: printer.macAddress!,
                      ),
                    if ((printer.ipAddress ?? '').isNotEmpty)
                      _MetaChip(
                        icon: Icons.language_rounded,
                        label: printer.ipAddress!,
                      ),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.hGapSm,
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textTertiary,
            size: 24,
          ),
        ],
      ),
    );
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
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onTap});

  final IconData icon;
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
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}

class _HeaderActionChip extends StatelessWidget {
  const _HeaderActionChip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add_rounded, color: Colors.white, size: 18),
              AppSpacing.hGapXs,
              Text(
                'Tambah',
                style: AppTypography.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
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
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          AppSpacing.hGapXs,
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
