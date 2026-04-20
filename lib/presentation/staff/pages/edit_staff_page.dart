import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/components/spaces.dart';
import 'package:pos_kita/core/design_system/design_system.dart' as ds;
import 'package:pos_kita/core/design_system/tokens/colors.dart';
import 'package:pos_kita/data/models/requests/staff_request_model.dart';
import 'package:pos_kita/data/models/responses/me_response_model.dart';
import 'package:pos_kita/presentation/outlet/bloc/outlet/outlet_bloc.dart';
import 'package:pos_kita/presentation/staff/bloc/staff/staff_bloc.dart';

class EditStaffPage extends StatefulWidget {
  const EditStaffPage({super.key, required this.user});

  final UserModel user;

  @override
  State<EditStaffPage> createState() => _EditStaffPageState();
}

class _EditStaffPageState extends State<EditStaffPage> {
  static const List<_RoleOption> _editableRoles = [
    _RoleOption(id: 2, label: 'Manager'),
    _RoleOption(id: 3, label: 'Kasir'),
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  int _roleId = _editableRoles.first.id;
  int? _outletId;
  bool _isSubmitting = false;

  bool get _isEditableRole =>
      _editableRoles.any((role) => role.id == widget.user.role?.id);

  String get _lockedRoleLabel {
    final String roleName = widget.user.role?.name.trim() ?? '';
    return roleName.isNotEmpty ? roleName : 'Role utama';
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name ?? '';
    _emailController.text = widget.user.email ?? '';
    _outletId = widget.user.outlet?.id;

    final int? currentRoleId = widget.user.role?.id;
    if (_editableRoles.any((role) => role.id == currentRoleId)) {
      _roleId = currentRoleId!;
    }

    context.read<OutletBloc>().add(const OutletEvent.getOutlets());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  int? _resolveSelectedOutlet(List<Outlet> outlets) {
    if (outlets.isEmpty) return null;
    if (_outletId != null && outlets.any((outlet) => outlet.id == _outletId)) {
      return _outletId;
    }
    return outlets.first.id;
  }

  void _showMessage(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  void _handleSubmit() {
    if (!_isEditableRole) {
      _showMessage(
        'Role $_lockedRoleLabel tidak dapat diedit dari menu staff.',
        AppColors.error,
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;
    if (widget.user.id == null || widget.user.businessId == null) {
      _showMessage(
        'Data staff tidak lengkap. Silakan muat ulang halaman lalu coba lagi.',
        AppColors.error,
      );
      return;
    }

    final OutletState outletState = context.read<OutletBloc>().state;
    final int? selectedOutletId = outletState.maybeWhen(
      loaded: (outlets) => _resolveSelectedOutlet(outlets),
      orElse: () => _outletId,
    );

    if (selectedOutletId == null) {
      _showMessage(
        'Outlet belum tersedia. Tambahkan outlet terlebih dahulu.',
        AppColors.error,
      );
      return;
    }

    final data = StaffRequestModel(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      outletId: selectedOutletId,
      roleId: _roleId,
      businessId: widget.user.businessId!,
    );

    setState(() {
      _isSubmitting = true;
    });

    context.read<StaffBloc>().add(StaffEvent.editStaff(data, widget.user.id!));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StaffBloc, StaffState>(
      listener: (context, state) {
        if (!_isSubmitting) return;

        state.maybeWhen(
          orElse: () {},
          error: (message) {
            setState(() {
              _isSubmitting = false;
            });
            _showMessage(message, AppColors.error);
          },
          loaded: (_) {
            setState(() {
              _isSubmitting = false;
            });
            _showMessage('Staff berhasil diperbarui', AppColors.primary);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      },
      builder: (context, state) {
        final bool isLoading =
            _isSubmitting &&
            state.maybeWhen(loading: () => true, orElse: () => false);

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Edit Staff',
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!_isEditableRole) ...[
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
                                'Role $_lockedRoleLabel tidak didukung untuk proses edit dari halaman ini.',
                                style: ds.AppTypography.bodySmall.copyWith(
                                  color: ds.AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SpaceHeight(16),
                    ],
                    ds.AppCard(
                      variant: ds.AppCardVariant.elevated,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Informasi Staff',
                            style: ds.AppTypography.titleLarge.copyWith(
                              color: ds.AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SpaceHeight(4),
                          Text(
                            'Perbarui data staff sesuai kebutuhan outlet.',
                            style: ds.AppTypography.bodySmall.copyWith(
                              color: ds.AppColors.textSecondary,
                            ),
                          ),
                          const SpaceHeight(16),
                          ds.AppTextField(
                            controller: _nameController,
                            label: 'Nama Staff',
                            hint: 'Masukkan nama staff',
                            prefixIcon: const Icon(
                              Icons.person_outline_rounded,
                            ),
                            enabled: _isEditableRole,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Nama staff tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SpaceHeight(16),
                          ds.AppTextField(
                            controller: _emailController,
                            label: 'Email Staff',
                            hint: 'Masukkan email staff',
                            prefixIcon: const Icon(Icons.email_outlined),
                            keyboardType: TextInputType.emailAddress,
                            enabled: _isEditableRole,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email staff tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SpaceHeight(16),
                          ds.AppTextField(
                            controller: _passwordController,
                            label: 'Password Baru',
                            hint:
                                'Kosongkan jika tidak ingin mengubah password',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            obscureText: true,
                            enabled: _isEditableRole,
                          ),
                        ],
                      ),
                    ),
                    const SpaceHeight(16),
                    ds.AppCard(
                      variant: ds.AppCardVariant.elevated,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Akses & Outlet',
                            style: ds.AppTypography.titleLarge.copyWith(
                              color: ds.AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SpaceHeight(4),
                          Text(
                            'Atur outlet penugasan dan level akses staff.',
                            style: ds.AppTypography.bodySmall.copyWith(
                              color: ds.AppColors.textSecondary,
                            ),
                          ),
                          const SpaceHeight(16),
                          BlocBuilder<OutletBloc, OutletState>(
                            builder: (context, outletState) {
                              return outletState.maybeWhen(
                                loading: () => const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                error: (message) =>
                                    _FieldInfo(message: message, isError: true),
                                loaded: (outlets) {
                                  final int? selectedOutletId =
                                      _resolveSelectedOutlet(outlets);

                                  if (outlets.isEmpty) {
                                    return const _FieldInfo(
                                      message:
                                          'Belum ada outlet tersedia untuk staff ini.',
                                    );
                                  }

                                  return _DropdownField<int>(
                                    label: 'Outlet',
                                    value: selectedOutletId,
                                    enabled: _isEditableRole,
                                    items: outlets
                                        .map(
                                          (outlet) => DropdownMenuItem<int>(
                                            value: outlet.id,
                                            child: Text(outlet.name ?? ''),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _outletId = value;
                                      });
                                    },
                                  );
                                },
                                orElse: () => const SizedBox.shrink(),
                              );
                            },
                          ),
                          const SpaceHeight(16),
                          _isEditableRole
                              ? _DropdownField<int>(
                                  label: 'Role',
                                  value: _roleId,
                                  enabled: true,
                                  items: _editableRoles
                                      .map(
                                        (role) => DropdownMenuItem<int>(
                                          value: role.id,
                                          child: Text(role.label),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    if (value == null) return;
                                    setState(() {
                                      _roleId = value;
                                    });
                                  },
                                )
                              : _FieldInfo(
                                  label: 'Role',
                                  message: _lockedRoleLabel,
                                ),
                        ],
                      ),
                    ),
                    const SpaceHeight(24),
                    ds.AppButton.filled(
                      onPressed: isLoading ? null : _handleSubmit,
                      label: 'Simpan',
                      size: ds.AppButtonSize.large,
                      isLoading: isLoading,
                      isDisabled: !_isEditableRole,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: ds.AppTypography.labelMedium.copyWith(
            color: ds.AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SpaceHeight(8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: enabled ? ds.AppColors.surface : ds.AppColors.disabled,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ds.AppColors.border),
          ),
          child: DropdownButtonFormField<T>(
            initialValue: value,
            items: items,
            onChanged: enabled ? onChanged : null,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            iconEnabledColor: ds.AppColors.textSecondary,
            dropdownColor: ds.AppColors.surface,
            style: ds.AppTypography.bodyMedium.copyWith(
              color: ds.AppColors.textPrimary,
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

class _FieldInfo extends StatelessWidget {
  const _FieldInfo({required this.message, this.label, this.isError = false});

  final String? label;
  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: ds.AppTypography.labelMedium.copyWith(
              color: ds.AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SpaceHeight(8),
        ],
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isError
                ? ds.AppColors.error500.withValues(alpha: 0.08)
                : ds.AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isError
                  ? ds.AppColors.error500.withValues(alpha: 0.18)
                  : ds.AppColors.border,
            ),
          ),
          child: Text(
            message,
            style: ds.AppTypography.bodySmall.copyWith(
              color: isError
                  ? ds.AppColors.error500
                  : ds.AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _RoleOption {
  const _RoleOption({required this.id, required this.label});

  final int id;
  final String label;
}
