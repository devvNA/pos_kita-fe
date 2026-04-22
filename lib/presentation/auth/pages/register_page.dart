import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/presentation/auth/bloc/register/register_bloc.dart';
import 'package:pos_kita/presentation/auth/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _nameController = TextEditingController();
  final _businessAddressController = TextEditingController();
  bool _isAgree = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _businessNameController.dispose();
    _nameController.dispose();
    _businessAddressController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_isAgree) {
        context.read<RegisterBloc>().add(
          RegisterEvent.register(
            name: _nameController.text,
            businessName: _businessNameController.text,
            businessAddress: _businessAddressController.text,
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Setujui syarat dan ketentuan terlebih dahulu'),
            backgroundColor: AppColors.warning600,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        );
      }
    }
  }

  void _toggleAgree() {
    setState(() {
      _isAgree = !_isAgree;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          state.maybeWhen(
            loading: () => setState(() => _isLoading = true),
            success: () {
              setState(() => _isLoading = false);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Registrasi berhasil, silakan masuk ke akun Anda',
                  ),
                  backgroundColor: AppColors.success600,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              );
            },
            error: (message) {
              setState(() => _isLoading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: AppColors.error500,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              );
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: -72,
                  left: -40,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary100.withValues(alpha: 0.82),
                    ),
                  ),
                ),
                Positioned(
                  top: 180,
                  right: -56,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary200.withValues(alpha: 0.45),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  padding: AppSpacing.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppIconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                        variant: AppButtonVariant.ghost,
                        size: AppButtonSize.small,
                      ),
                      AppSpacing.vGapSm,
                      Center(
                        child: Image.asset(
                          'assets/images/logo/poskita.png',
                          width: 150,
                        ),
                      ),
                      AppSpacing.vGapXl,
                      AppCard(
                        variant: AppCardVariant.elevated,
                        padding: AppSpacing.allLg,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Daftarkan Bisnis Anda',
                                style: AppTypography.titleLarge.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              AppSpacing.vGapSm,
                              Text(
                                'Lengkapi data berikut untuk mulai memakai POS Kita',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              AppSpacing.vGapSm,
                              AppTextField(
                                controller: _nameController,
                                label: 'Nama',
                                hint: 'Contoh: Ilham',
                                prefixIcon: const Icon(Icons.person_outline),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Nama owner tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                              AppSpacing.vGapSm,
                              AppTextField(
                                controller: _businessNameController,
                                label: 'Nama Bisnis',
                                hint: 'Contoh: Toko Sembako Maju',
                                prefixIcon: const Icon(
                                  Icons.storefront_outlined,
                                ),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Nama bisnis tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                              AppSpacing.vGapSm,
                              AppTextField(
                                controller: _emailController,
                                label: 'Email',
                                hint: 'contoh@bisnisanda.com',
                                prefixIcon: const Icon(
                                  Icons.mail_outline_rounded,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email tidak boleh kosong';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Format email tidak valid';
                                  }
                                  return null;
                                },
                              ),
                              AppSpacing.vGapSm,
                              AppTextField(
                                controller: _passwordController,
                                label: 'Password',
                                hint: 'Minimal 6 karakter',
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                ),
                                obscureText: true,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password tidak boleh kosong';
                                  }
                                  if (value.length < 6) {
                                    return 'Password minimal 6 karakter';
                                  }
                                  return null;
                                },
                              ),
                              AppSpacing.vGapSm,
                              AppTextField(
                                controller: _businessAddressController,
                                label: 'Alamat Bisnis',
                                hint: 'Masukkan alamat lengkap bisnis Anda',
                                prefixIcon: const Icon(
                                  Icons.location_on_outlined,
                                ),
                                keyboardType: TextInputType.streetAddress,
                                textInputAction: TextInputAction.done,
                                minLines: 3,
                                maxLines: 4,
                                onSubmitted: (_) => _submit(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Alamat bisnis tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                              AppSpacing.vGapMd,
                              AppCard(
                                variant: AppCardVariant.flat,
                                padding: AppSpacing.allMd,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        checkboxTheme: CheckboxThemeData(
                                          fillColor:
                                              WidgetStateProperty.resolveWith((
                                                states,
                                              ) {
                                                if (states.contains(
                                                  WidgetState.selected,
                                                )) {
                                                  return AppColors.primary600;
                                                }
                                                return AppColors.surface;
                                              }),
                                        ),
                                      ),
                                      child: Checkbox(
                                        value: _isAgree,
                                        onChanged: (_) => _toggleAgree(),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppRadius.sm,
                                          ),
                                        ),
                                      ),
                                    ),
                                    AppSpacing.hGapXs,
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: AppSpacing.xs,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Saya setuju dengan syarat dan ketentuan.',
                                              style: AppTypography.bodyMedium
                                                  .copyWith(
                                                    color:
                                                        AppColors.textPrimary,
                                                  ),
                                            ),
                                            AppSpacing.vGapXxs,
                                            Text(
                                              'Data bisnis Anda akan digunakan untuk proses aktivasi akun dan pengelolaan toko.',
                                              style: AppTypography.bodySmall
                                                  .copyWith(
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AppSpacing.vGapMd,
                              AppButton.filled(
                                onPressed: _isLoading ? null : _submit,
                                label: 'Buat Akun',
                                isLoading: _isLoading,
                                size: AppButtonSize.large,
                                width: double.infinity,
                                prefixIcon: const Icon(
                                  Icons.person_add_alt_1_rounded,
                                ),
                              ),
                              AppSpacing.vGapMd,
                              AppCard(
                                variant: AppCardVariant.flat,
                                padding: AppSpacing.allMd,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary100,
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.md,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.login_rounded,
                                        color: AppColors.primary700,
                                      ),
                                    ),
                                    AppSpacing.hGapMd,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Sudah punya akun?',
                                            style: AppTypography.titleSmall
                                                .copyWith(
                                                  color: AppColors.textPrimary,
                                                ),
                                          ),
                                          AppSpacing.vGapXxs,
                                          Text(
                                            'Masuk ke akun Anda untuk lanjut mengelola bisnis.',
                                            style: AppTypography.bodySmall
                                                .copyWith(
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    AppSpacing.hGapSm,
                                    AppButton.outlined(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const LoginPage(),
                                          ),
                                        );
                                      },
                                      label: 'Masuk',
                                      size: AppButtonSize.small,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AppSpacing.vGapXl,
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
