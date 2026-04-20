import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/data/datasources/auth_local_datasource.dart';
import 'package:pos_kita/data/models/requests/printer_request_model.dart';
import 'package:pos_kita/presentation/printer/bloc/printer/printer_bloc.dart';
import 'package:pos_kita/presentation/printer/pages/dialog_search_printer.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class AddPrinterPage extends StatefulWidget {
  const AddPrinterPage({super.key});

  @override
  State<AddPrinterPage> createState() => _AddPrinterPageState();
}

class _AddPrinterPageState extends State<AddPrinterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ipAddressController = TextEditingController();
  final TextEditingController _macAddressController = TextEditingController();

  String _connectionType = 'Bluetooth';
  int _paperWidth = 58;
  bool _isDefault = false;

  /// Guards against reacting to stale [PrinterState.loaded] emissions
  /// that occurred before the user submitted the form.
  bool _didSave = false;

  final List<String> _connectionTypes = ['Bluetooth', 'Ethernet', 'USB'];

  bool get _showBluetoothField => _connectionType == 'Bluetooth';
  bool get _showIpField => _connectionType == 'Ethernet';

  @override
  void dispose() {
    _nameController.dispose();
    _ipAddressController.dispose();
    _macAddressController.dispose();
    super.dispose();
  }

  Future<void> _openPrinterScanner() async {
    final BluetoothInfo? printer = await showDialog<BluetoothInfo>(
      context: context,
      builder: (_) => const DialogSearchPrinter(),
    );

    if (printer == null || !mounted) return;

    setState(() {
      _macAddressController.text = printer.macAdress;
      if (_nameController.text.trim().isEmpty &&
          printer.name.trim().isNotEmpty) {
        _nameController.text = printer.name.trim();
      }
    });
  }

  void _onConnectionTypeChanged(String? value) {
    if (value == null) return;

    setState(() {
      _connectionType = value;
      if (!_showBluetoothField) {
        _macAddressController.clear();
      }
      if (!_showIpField) {
        _ipAddressController.clear();
      }
    });
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final outletData = await AuthLocalDatasource().getOutletData();
    if (!mounted) return;
    if (outletData.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error500,
          content: Text(
            'Outlet belum tersedia. Silakan atur outlet terlebih dahulu.',
            style: AppTypography.bodyMedium.copyWith(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final data = PrinterModel(
      name: _nameController.text.trim(),
      connectionType: _connectionType,
      ipAddress: _showIpField ? _ipAddressController.text.trim() : null,
      macAddress: _showBluetoothField
          ? _macAddressController.text.trim()
          : null,
      paperWidth: _paperWidth,
      outletId: outletData.id!,
      isDefault: _isDefault,
    );

    _didSave = true;
    context.read<PrinterBloc>().add(PrinterEvent.addPrinter(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<PrinterBloc, PrinterState>(
          listenWhen: (prev, curr) => prev != curr,
          listener: (context, state) {
            state.maybeWhen(
              orElse: () {},
              error: (message) {
                _didSave = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: AppColors.error500,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              loaded: (_) {
                if (!_didSave) return;
                _didSave = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Printer berhasil ditambahkan'),
                    backgroundColor: AppColors.success600,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.pop(context);
              },
            );
          },
          builder: (context, state) {
            final bool isLoading = state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );

            return Column(
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
                              borderRadius: BorderRadius.circular(
                                AppRadius.full,
                              ),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              'Printer Baru',
                              style: AppTypography.labelMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.vGapLg,
                      Text(
                        'Tambah printer',
                        style: AppTypography.headlineSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      AppSpacing.vGapXs,
                      Text(
                        'Lengkapi informasi printer untuk mencetak struk transaksi.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Form Body ──
                Expanded(
                  child: SingleChildScrollView(
                    padding: AppSpacing.allLg,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Card: Informasi Printer ──
                          AppCard(
                            padding: AppSpacing.allLg,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _SectionHeader(
                                  icon: Icons.print_outlined,
                                  title: 'Informasi Printer',
                                  subtitle:
                                      'Lengkapi nama printer dan tipe koneksi yang akan dipakai.',
                                ),
                                AppSpacing.vGapLg,
                                AppTextField(
                                  controller: _nameController,
                                  label: 'Nama Printer',
                                  hint: 'Contoh: Kasir Depan',
                                  prefixIcon: const Icon(Icons.print_outlined),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty) {
                                      return 'Nama printer tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                ),
                                AppSpacing.vGapLg,
                                _DropdownField<String>(
                                  label: 'Tipe Koneksi',
                                  value: _connectionType,
                                  items: _connectionTypes
                                      .map(
                                        (type) => DropdownMenuItem<String>(
                                          value: type,
                                          child: Text(type),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: _onConnectionTypeChanged,
                                ),
                              ],
                            ),
                          ),

                          AppSpacing.vGapLg,

                          // ── Card: Koneksi ──
                          AppCard(
                            padding: AppSpacing.allLg,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _SectionHeader(
                                  icon: _showBluetoothField
                                      ? Icons.bluetooth_rounded
                                      : _showIpField
                                          ? Icons.language_rounded
                                          : Icons.usb_rounded,
                                  title: 'Koneksi',
                                  subtitle: _showBluetoothField
                                      ? 'Pilih printer bluetooth yang sudah dipasangkan.'
                                      : _showIpField
                                          ? 'Masukkan alamat IP printer ethernet.'
                                          : 'Hubungkan printer USB dari perangkat yang digunakan.',
                                ),
                                AppSpacing.vGapLg,
                                if (_showBluetoothField)
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: AppTextField(
                                          controller: _macAddressController,
                                          label: 'Alamat Bluetooth',
                                          hint:
                                              'Pilih printer melalui tombol pindai',
                                          prefixIcon: const Icon(
                                            Icons.bluetooth_rounded,
                                          ),
                                          readOnly: true,
                                          validator: (value) {
                                            if (_showBluetoothField &&
                                                (value == null ||
                                                    value.trim().isEmpty)) {
                                              return 'Silakan pilih printer bluetooth';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      AppSpacing.hGapMd,
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 26),
                                        child: SizedBox(
                                          width: 120,
                                          child: AppButton.outlined(
                                            onPressed: _openPrinterScanner,
                                            label: 'Pindai',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (_showIpField)
                                  AppTextField(
                                    controller: _ipAddressController,
                                    label: 'IP Address',
                                    hint: 'Contoh: 192.168.1.10',
                                    prefixIcon:
                                        const Icon(Icons.language_rounded),
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (_showIpField &&
                                          (value == null ||
                                              value.trim().isEmpty)) {
                                        return 'IP Address tidak boleh kosong';
                                      }
                                      return null;
                                    },
                                  ),
                                if (!_showBluetoothField && !_showIpField)
                                  _InfoBanner(
                                    icon: Icons.usb_rounded,
                                    message:
                                        'Mode USB tidak membutuhkan proses scan. Pastikan printer sudah terhubung ke perangkat.',
                                  ),
                              ],
                            ),
                          ),

                          AppSpacing.vGapLg,

                          // ── Card: Preferensi Cetak ──
                          AppCard(
                            padding: AppSpacing.allLg,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _SectionHeader(
                                  icon: Icons.receipt_long_outlined,
                                  title: 'Preferensi Cetak',
                                  subtitle:
                                      'Atur ukuran kertas dan tandai printer default bila diperlukan.',
                                ),
                                AppSpacing.vGapLg,
                                _DropdownField<int>(
                                  label: 'Ukuran Kertas',
                                  value: _paperWidth,
                                  items: const [
                                    DropdownMenuItem(
                                      value: 58,
                                      child: Text('58 mm'),
                                    ),
                                    DropdownMenuItem(
                                      value: 80,
                                      child: Text('80 mm'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    if (value == null) return;
                                    setState(() {
                                      _paperWidth = value;
                                    });
                                  },
                                ),
                                AppSpacing.vGapMd,
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceVariant,
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.card,
                                    ),
                                    border: Border.all(
                                      color: AppColors.border,
                                    ),
                                  ),
                                  child: CheckboxListTile(
                                    value: _isDefault,
                                    activeColor: AppColors.primary,
                                    title: Text(
                                      'Jadikan printer default',
                                      style:
                                          AppTypography.bodyMedium.copyWith(
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    subtitle: Text(
                                      'Printer ini akan diprioritaskan untuk proses cetak.',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    onChanged: (value) {
                                      setState(() {
                                        _isDefault = value ?? false;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          AppSpacing.vGapXl,

                          // ── Save Button ──
                          AppButton.filled(
                            onPressed: isLoading ? null : _handleSave,
                            label: 'Simpan Printer',
                            size: AppButtonSize.large,
                            width: double.infinity,
                            isLoading: isLoading,
                            prefixIcon: const Icon(Icons.save_outlined),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary50,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        AppSpacing.hGapMd,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              AppSpacing.vGapXxs,
              Text(
                subtitle,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.info50,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.info100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.info600, size: 20),
          AppSpacing.hGapSm,
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.info700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSpacing.vGapSm,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonFormField<T>(
            initialValue: value,
            items: items,
            onChanged: onChanged,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            iconEnabledColor: AppColors.textSecondary,
            dropdownColor: AppColors.surface,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
