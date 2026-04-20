import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/presentation/items/bloc/category/category_bloc.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  /// Guards against reacting to stale [CategoryState.success] emissions
  /// that occurred before the user submitted the form.
  bool _didSave = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    _didSave = true;
    context.read<CategoryBloc>().add(
      CategoryEvent.addCategory(name: _nameController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<CategoryBloc, CategoryState>(
          listenWhen: (prev, curr) => prev != curr,
          listener: (context, state) {
            state.maybeWhen(
              success: (_) {
                if (!_didSave) return;
                _didSave = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Kategori berhasil ditambahkan'),
                    backgroundColor: AppColors.success600,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.pop(context);
              },
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
                        'Tambah kategori',
                        style: AppTypography.headlineSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      AppSpacing.vGapXs,
                      Text(
                        'Buat kategori baru untuk mengelompokkan produk.',
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
                                        Icons.category_outlined,
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
                                            'Nama kategori',
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
                                  onSubmitted: (_) => _handleSave(),
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
                                          'Kategori membantu mengelompokkan produk di halaman item agar lebih mudah dicari.',
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
                            onPressed: isLoading ? null : _handleSave,
                            label: 'Simpan Kategori',
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
