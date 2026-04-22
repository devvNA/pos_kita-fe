import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/components/spaces.dart';
import 'package:pos_kita/core/design_system/design_system.dart' as ds;
import 'package:pos_kita/core/extensions/build_context_ext.dart';
import 'package:pos_kita/data/models/requests/outlet_request_model.dart';
import 'package:pos_kita/data/models/responses/me_response_model.dart';
import 'package:pos_kita/presentation/outlet/bloc/outlet/outlet_bloc.dart';

class EditOutletPage extends StatefulWidget {
  const EditOutletPage({super.key, required this.outlet});

  final Outlet outlet;

  @override
  State<EditOutletPage> createState() => _EditOutletPageState();
}

class _EditOutletPageState extends State<EditOutletPage> {
  final _formKey = GlobalKey<FormState>();
  final _outletNameController = TextEditingController();
  final _outletAddressController = TextEditingController();
  final _outletPhoneController = TextEditingController();
  final _outletDescController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _outletNameController.text = widget.outlet.name ?? '';
    _outletAddressController.text = widget.outlet.address ?? '';
    _outletPhoneController.text = widget.outlet.phone ?? '';
    _outletDescController.text = widget.outlet.description ?? '';
  }

  @override
  void dispose() {
    _outletNameController.dispose();
    _outletAddressController.dispose();
    _outletPhoneController.dispose();
    _outletDescController.dispose();
    super.dispose();
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
    if (!_formKey.currentState!.validate()) return;

    final outletId = widget.outlet.id;
    final businessId = widget.outlet.businessId;

    if (outletId == null || businessId == null || businessId == 0) {
      _showMessage(
        'Data outlet tidak lengkap. Muat ulang halaman lalu coba lagi.',
        ds.AppColors.error500,
      );
      return;
    }

    final data = OutletRequestModel(
      name: _outletNameController.text.trim(),
      address: _outletAddressController.text.trim(),
      phone: _outletPhoneController.text.trim(),
      description: _outletDescController.text.trim(),
      businessId: businessId,
    );

    setState(() {
      _isSubmitting = true;
    });

    context.read<OutletBloc>().add(OutletEvent.editOutlet(data, outletId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OutletBloc, OutletState>(
      listener: (context, state) {
        if (!_isSubmitting) return;

        state.maybeWhen(
          orElse: () {},
          error: (message) {
            setState(() {
              _isSubmitting = false;
            });
            _showMessage(message, ds.AppColors.error500);
          },
          loaded: (_) {
            setState(() {
              _isSubmitting = false;
            });
            context.showSnackBar(
              'Outlet berhasil diperbarui',
              ds.AppColors.success500,
            );
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      },
      child: Scaffold(
        backgroundColor: ds.AppColors.background,
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'Edit Outlet',
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
              color: Colors.white,
            ),
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
                          'Informasi Outlet',
                          style: ds.AppTypography.titleLarge.copyWith(
                            color: ds.AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SpaceHeight(4),
                        Text(
                          'Perbarui nama, alamat, kontak, dan deskripsi outlet.',
                          style: ds.AppTypography.bodySmall.copyWith(
                            color: ds.AppColors.textSecondary,
                          ),
                        ),
                        const SpaceHeight(16),
                        ds.AppTextField(
                          controller: _outletNameController,
                          label: 'Nama Outlet',
                          hint: 'Masukkan nama outlet',
                          prefixIcon: const Icon(Icons.storefront_outlined),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Nama outlet tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SpaceHeight(16),
                        ds.AppTextField(
                          controller: _outletAddressController,
                          label: 'Alamat Outlet',
                          hint: 'Masukkan alamat outlet',
                          prefixIcon: const Icon(Icons.location_on_outlined),
                          textInputAction: TextInputAction.next,
                          minLines: 2,
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Alamat outlet tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SpaceHeight(16),
                        ds.AppTextField(
                          controller: _outletPhoneController,
                          label: 'Nomor Telepon',
                          hint: 'Masukkan nomor telepon outlet',
                          prefixIcon: const Icon(Icons.phone_outlined),
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Nomor telepon tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SpaceHeight(16),
                        ds.AppTextField(
                          controller: _outletDescController,
                          label: 'Deskripsi Outlet',
                          hint: 'Tambahkan deskripsi singkat outlet',
                          prefixIcon: const Icon(Icons.description_outlined),
                          textInputAction: TextInputAction.done,
                          minLines: 3,
                          maxLines: 4,
                          onSubmitted: (_) => _handleSubmit(),
                        ),
                      ],
                    ),
                  ),
                  const SpaceHeight(24),
                  ds.AppButton.filled(
                    onPressed: _isSubmitting ? null : _handleSubmit,
                    label: 'Simpan Perubahan',
                    size: ds.AppButtonSize.large,
                    width: double.infinity,
                    isLoading: _isSubmitting,
                    prefixIcon: const Icon(Icons.save_outlined),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
