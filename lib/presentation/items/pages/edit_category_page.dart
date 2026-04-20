import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/data/models/responses/category_response_model.dart';
import 'package:pos_kita/presentation/items/bloc/category/category_bloc.dart';

class EditCategoryPage extends StatefulWidget {
  final Category category;
  const EditCategoryPage({super.key, required this.category});

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.category.name ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<CategoryBloc, CategoryState>(
          listener: (context, state) {
            state.maybeWhen(
              success: (_) {
                Navigator.pop(context);
              },
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

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.35),
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.md,
                                ),
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
                              'Kategori',
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
                        'Edit kategori',
                        style: AppTypography.headlineSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      AppSpacing.vGapXs,
                      Text(
                        'Perbarui nama kategori agar daftar produk tetap rapi dan mudah dicari.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: AppSpacing.allLg,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                      child: const Icon(
                                        Icons.drive_file_rename_outline_rounded,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    AppSpacing.hGapMd,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Informasi kategori',
                                            style: AppTypography.titleLarge
                                                .copyWith(
                                                  color: AppColors.textPrimary,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                          AppSpacing.vGapXxs,
                                          Text(
                                            'Gunakan nama yang singkat, jelas, dan konsisten.',
                                            style: AppTypography.bodySmall
                                                .copyWith(
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                AppSpacing.vGapLg,
                                AppTextField(
                                  controller: _nameController,
                                  label: 'Nama kategori',
                                  hint: 'Contoh: Minuman, Snack, Makanan',
                                  prefixIcon: const Icon(
                                    Icons.category_outlined,
                                  ),
                                  textInputAction: TextInputAction.done,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Kategori tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                  onSubmitted: (_) {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<CategoryBloc>().add(
                                        CategoryEvent.updateCategory(
                                          id: widget.category.id!,
                                          name: _nameController.text.trim(),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                AppSpacing.vGapMd,
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.info50,
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.md,
                                    ),
                                    border: Border.all(
                                      color: AppColors.info100,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.tips_and_updates_outlined,
                                        color: AppColors.info600,
                                        size: 18,
                                      ),
                                      AppSpacing.hGapSm,
                                      Expanded(
                                        child: Text(
                                          'Perubahan nama kategori akan mempermudah pencarian dan pengelompokan produk di halaman item.',
                                          style: AppTypography.bodySmall
                                              .copyWith(
                                                color: AppColors.info700,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppSpacing.vGapLg,
                          AppButton.filled(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<CategoryBloc>().add(
                                  CategoryEvent.updateCategory(
                                    id: widget.category.id!,
                                    name: _nameController.text.trim(),
                                  ),
                                );
                              }
                            },
                            label: 'Simpan Perubahan',
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
