import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/data/datasources/auth_local_datasource.dart';
import 'package:pos_kita/data/models/requests/outlet_request_model.dart';
import 'package:pos_kita/presentation/outlet/bloc/outlet/outlet_bloc.dart';

class AddOutletPage extends StatefulWidget {
  const AddOutletPage({super.key});

  @override
  State<AddOutletPage> createState() => _AddOutletPageState();
}

class _AddOutletPageState extends State<AddOutletPage> {
  final _formKey = GlobalKey<FormState>();
  final _outletNameController = TextEditingController();
  final _outletAddressController = TextEditingController();
  final _outletPhoneController = TextEditingController();
  final _outletDescController = TextEditingController();

  @override
  void dispose() {
    _outletNameController.dispose();
    _outletAddressController.dispose();
    _outletPhoneController.dispose();
    _outletDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Tambah Outlet',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.onPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informasi Outlet',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.vGapSm,
              AppCard(
                variant: AppCardVariant.elevated,
                padding: AppSpacing.allMd,
                child: Column(
                  children: [
                    AppTextField(
                      controller: _outletNameController,
                      label: 'Nama Outlet',
                      hint: 'Masukkan nama outlet',
                      prefixIcon: const Icon(Icons.storefront_rounded),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama Outlet tidak boleh kosong';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    AppSpacing.vGapMd,
                    AppTextField(
                      controller: _outletAddressController,
                      label: 'Alamat Outlet',
                      hint: 'Masukkan alamat lengkap',
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Alamat Outlet tidak boleh kosong';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    AppSpacing.vGapMd,
                    AppTextField(
                      controller: _outletPhoneController,
                      label: 'Nomor Telepon',
                      hint: '0812xxxx',
                      prefixIcon: const Icon(Icons.phone_outlined),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor Telepon tidak boleh kosong';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    AppSpacing.vGapMd,
                    AppTextField(
                      controller: _outletDescController,
                      label: 'Deskripsi',
                      hint: 'Tambahkan deskripsi singkat',
                      prefixIcon: const Icon(Icons.description_outlined),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Deskripsi Outlet tidak boleh kosong';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                ),
              ),
              AppSpacing.vGapXl,
              BlocConsumer<OutletBloc, OutletState>(
                listener: (context, state) {
                  state.maybeWhen(
                    orElse: () {},
                    error: (message) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            message,
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: AppColors.error500,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                      );
                    },
                    loaded: (_) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Outlet berhasil ditambahkan',
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: AppColors.success600,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                      );
                    },
                  );
                },
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () {
                      return AppButton.filled(
                        width: double.infinity,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final authData = await AuthLocalDatasource()
                                .getUserData();
                            final businessId = authData?.data?.businessId;
                            final data = OutletRequestModel(
                              name: _outletNameController.text,
                              address: _outletAddressController.text,
                              phone: _outletPhoneController.text,
                              description: _outletDescController.text,
                              businessId: businessId!,
                            );

                            if (context.mounted) {
                              context.read<OutletBloc>().add(
                                OutletEvent.addOutlet(data),
                              );
                            }
                          }
                        },
                        label: 'Simpan Outlet',
                        prefixIcon: const Icon(Icons.save_rounded),
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
