import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/data/datasources/auth_local_datasource.dart';
import 'package:pos_kita/data/datasources/auth_remote_datasource.dart';
import 'package:pos_kita/presentation/auth/bloc/login/login_bloc.dart';
import 'package:pos_kita/presentation/auth/pages/register_page.dart';
import 'package:pos_kita/presentation/home/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _isObscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(
        LoginEvent.login(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          state.maybeWhen(
            loading: () => setState(() => _isLoading = true),
            success: (data) async {
              final navigator = Navigator.of(context);
              setState(() => _isLoading = false);
              await AuthLocalDatasource().saveUserData(data);
              final response = await AuthRemoteDataSource().myoutlet();
              await response.fold(
                (l) async => debugPrint(l),
                (r) => AuthLocalDatasource().saveOutletData(r),
              );
              if (mounted) {
                navigator.pushReplacement(
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              }
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
                  top: -80,
                  right: -36,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary200.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                Positioned(
                  top: 120,
                  left: -72,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary100.withValues(alpha: 0.85),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  padding: AppSpacing.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (canPop)
                        AppIconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                          variant: AppButtonVariant.ghost,
                          size: AppButtonSize.small,
                        )
                      else
                        AppSpacing.gapNone,
                      SizedBox(height: canPop ? AppSpacing.xl : AppSpacing.xxl),
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
                                'Masuk ke Akun',
                                style: AppTypography.titleLarge.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              AppSpacing.vGapXs,
                              Text(
                                'Gunakan email dan password Anda untuk mulai mengelola transaksi, stok, dan laporan toko.',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              AppSpacing.vGapLg,
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
                              AppSpacing.vGapLg,
                              AppTextField(
                                controller: _passwordController,
                                label: 'Password',
                                hint: 'Masukkan password Anda',
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                ),
                                obscureText: _isObscure,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => _submit(),
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
                              AppSpacing.vGapMd,
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.sm,
                                      vertical: AppSpacing.xs,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.success50,
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.full,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.verified_user_outlined,
                                          size: 16,
                                          color: AppColors.success700,
                                        ),
                                        AppSpacing.hGapXs,
                                        Text(
                                          'Login aman',
                                          style: AppTypography.labelMedium
                                              .copyWith(
                                                color: AppColors.success700,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      // TODO: Implement forgot password
                                    },
                                    child: Text(
                                      'Lupa Password?',
                                      style: AppTypography.labelMedium.copyWith(
                                        color: AppColors.primary600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              AppSpacing.vGapMd,
                              AppButton.filled(
                                onPressed: _isLoading ? null : _submit,
                                label: 'Masuk Sekarang',
                                isLoading: _isLoading,
                                size: AppButtonSize.large,
                                width: double.infinity,
                                prefixIcon: const Icon(Icons.login_rounded),
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
                                        Icons.storefront_outlined,
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
                                            'Belum punya akun?',
                                            style: AppTypography.titleSmall
                                                .copyWith(
                                                  color: AppColors.textPrimary,
                                                ),
                                          ),
                                          AppSpacing.vGapXxs,
                                          Text(
                                            'Daftarkan bisnis Anda untuk mulai memakai POS Kita.',
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
                                            builder: (_) =>
                                                const RegisterPage(),
                                          ),
                                        );
                                      },
                                      label: 'Daftar',
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


