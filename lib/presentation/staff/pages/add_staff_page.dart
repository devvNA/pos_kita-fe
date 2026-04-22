import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/components/spaces.dart';
import 'package:pos_kita/core/design_system/design_system.dart' as ds;
import 'package:pos_kita/core/design_system/tokens/colors.dart';
import 'package:pos_kita/data/datasources/auth_local_datasource.dart';
import 'package:pos_kita/data/models/requests/staff_request_model.dart';
import 'package:pos_kita/data/models/responses/me_response_model.dart';
import 'package:pos_kita/presentation/outlet/bloc/outlet/outlet_bloc.dart';
import 'package:pos_kita/presentation/staff/bloc/staff/staff_bloc.dart';

class AddStaffPage extends StatefulWidget {
  const AddStaffPage({super.key});

  @override
  State<AddStaffPage> createState() => _AddStaffPageState();
}

class _AddStaffPageState extends State<AddStaffPage> {
  static const List<_RoleOption> _roles = [
    _RoleOption(id: 3, label: 'Kasir'),
    _RoleOption(id: 2, label: 'Manager'),
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  int? _outletId;
  int _roleId = _roles.first.id;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
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

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final staffBloc = context.read<StaffBloc>();
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

    final authData = await AuthLocalDatasource().getUserData();
    final int? businessId = authData?.data?.businessId;

    if (businessId == null || businessId == 0) {
      _showMessage(
        'Data bisnis tidak ditemukan. Silakan login ulang lalu coba lagi.',
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
      businessId: businessId,
    );

    setState(() {
      _isSubmitting = true;
    });

    staffBloc.add(StaffEvent.addStaff(data));
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
            _showMessage('Staff berhasil ditambahkan', AppColors.primary);
            Navigator.of(context).pop();
          },
        );
      },
      builder: (context, state) {
        final bool isLoading =
            _isSubmitting &&
            state.maybeWhen(loading: () => true, orElse: () => false);

        return Scaffold(
          backgroundColor: ds.AppColors.background,
          appBar: AppBar(
            title: const Text(
              'Tambah Staff',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
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
                            'Lengkapi data staff untuk menambahkan akses baru ke outlet.',
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
                            textInputAction: TextInputAction.next,
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
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email staff tidak boleh kosong';
                              }
                              if (!value.contains('@')) {
                                return 'Format email tidak valid';
                              }
                              return null;
                            },
                          ),
                          const SpaceHeight(16),
                          ds.AppTextField(
                            controller: _passwordController,
                            label: 'Password',
                            hint: 'Masukkan password staff',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            obscureText: true,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Password tidak boleh kosong';
                              }
                              if (value.trim().length < 6) {
                                return 'Password minimal 6 karakter';
                              }
                              return null;
                            },
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
                            'Tentukan outlet penugasan dan level akses untuk staff baru.',
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
                                          'Belum ada outlet tersedia. Tambahkan outlet terlebih dahulu sebelum membuat staff.',
                                    );
                                  }

                                  return _DropdownField<int>(
                                    label: 'Outlet',
                                    value: selectedOutletId,
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
                          _DropdownField<int>(
                            label: 'Role',
                            value: _roleId,
                            items: _roles
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
                      width: double.infinity,
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
  const _FieldInfo({required this.message, this.isError = false});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          color: isError ? ds.AppColors.error500 : ds.AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _RoleOption {
  const _RoleOption({required this.id, required this.label});

  final int id;
  final String label;
}
