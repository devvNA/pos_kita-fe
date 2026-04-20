import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_kita/core/components/spaces.dart';
import 'package:pos_kita/core/design_system/design_system.dart' as ds;
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class DialogSearchPrinter extends StatefulWidget {
  const DialogSearchPrinter({super.key});

  @override
  State<DialogSearchPrinter> createState() => _DialogSearchPrinterState();
}

class _DialogSearchPrinterState extends State<DialogSearchPrinter> {
  bool _isScanning = false;
  String? _errorMessage;
  List<BluetoothInfo> _items = [];

  @override
  void initState() {
    super.initState();
    _scanPrinters();
  }

  Future<void> _scanPrinters() async {
    setState(() {
      _isScanning = true;
      _errorMessage = null;
      _items = [];
    });

    try {
      final bool permissionGranted = await _requestBluetoothPermissions();
      if (!permissionGranted) {
        _setError(
          'Izin bluetooth dibutuhkan untuk mencari printer. '
          'Aktifkan izin lalu coba lagi.',
        );
        return;
      }

      final bool isBluetoothEnabled =
          await PrintBluetoothThermal.bluetoothEnabled;
      if (!isBluetoothEnabled) {
        _setError('Bluetooth belum aktif. Aktifkan bluetooth lalu coba lagi.');
        return;
      }

      final List<BluetoothInfo> result =
          await PrintBluetoothThermal.pairedBluetooths;

      final Map<String, BluetoothInfo> uniqueItems = {
        for (final item in result)
          if (item.macAdress.trim().isNotEmpty) item.macAdress: item,
      };

      if (!mounted) return;
      setState(() {
        _items = uniqueItems.values.toList()
          ..sort(
            (a, b) => _printerLabel(
              a,
            ).toLowerCase().compareTo(_printerLabel(b).toLowerCase()),
          );
      });
    } catch (_) {
      _setError('Gagal memuat printer bluetooth. Coba lagi beberapa saat lagi.');
    } finally {
      if (!mounted) return;
      setState(() {
        _isScanning = false;
      });
    }
  }

  Future<bool> _requestBluetoothPermissions() async {
    final Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();

    return statuses.values.every(
      (status) => status.isGranted || status.isLimited,
    );
  }

  void _setError(String message) {
    if (!mounted) return;
    setState(() {
      _errorMessage = message;
    });
  }

  String _printerLabel(BluetoothInfo printer) {
    final String name = printer.name.trim();
    return name.isNotEmpty ? name : 'Printer tanpa nama';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 12, 0),
      contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      title: Row(
        children: [
          Expanded(
            child: Text(
              'Cari Printer Bluetooth',
              style: ds.AppTypography.titleLarge.copyWith(
                color: ds.AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            onPressed: _isScanning ? null : _scanPrinters,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Muat Ulang',
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _buildContent(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Tutup',
            style: ds.AppTypography.labelLarge.copyWith(
              color: ds.AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isScanning) {
      return const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return SizedBox(
        height: 220,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bluetooth_disabled_rounded,
              size: 42,
              color: ds.AppColors.textTertiary,
            ),
            const SpaceHeight(12),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: ds.AppTypography.bodyMedium.copyWith(
                color: ds.AppColors.textSecondary,
              ),
            ),
            const SpaceHeight(16),
            ds.AppButton.outlined(
              onPressed: _scanPrinters,
              label: 'Coba Lagi',
            ),
          ],
        ),
      );
    }

    if (_items.isEmpty) {
      return SizedBox(
        height: 220,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.print_disabled_outlined,
              size: 42,
              color: ds.AppColors.textTertiary,
            ),
            const SpaceHeight(12),
            Text(
              'Belum ada printer bluetooth yang terpasang di perangkat ini.',
              textAlign: TextAlign.center,
              style: ds.AppTypography.bodyMedium.copyWith(
                color: ds.AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 320),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: _items.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final BluetoothInfo printer = _items[index];

          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: ds.AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.print_outlined,
                color: ds.AppColors.primary,
              ),
            ),
            title: Text(
              _printerLabel(printer),
              style: ds.AppTypography.titleMedium.copyWith(
                color: ds.AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Text(
              printer.macAdress,
              style: ds.AppTypography.bodySmall.copyWith(
                color: ds.AppColors.textSecondary,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: ds.AppColors.textTertiary,
            ),
            onTap: () => Navigator.of(context).pop(printer),
          );
        },
      ),
    );
  }
}
