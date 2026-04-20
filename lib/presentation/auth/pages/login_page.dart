import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/data/datasources/auth_local_datasource.dart';
import 'package:pos_kita/data/datasources/auth_remote_datasource.dart';
import 'package:pos_kita/presentation/auth/bloc/login/login_bloc.dart';
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          state.maybeWhen(
            loading: () => setState(() => _isLoading = true),
            success: (data) async {
              setState(() => _isLoading = false);
              await AuthLocalDatasource().saveUserData(data);
              final response = await AuthRemoteDataSource().myoutlet();
              response.fold(
                (l) => debugPrint(l),
                (r) async => await AuthLocalDatasource().saveOutletData(r),
              );
              if (mounted) {
                Navigator.pushReplacement(
                  context,
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
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  AppIconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    variant: AppButtonVariant.ghost,
                    size: AppButtonSize.small,
                  ),

                  AppSpacing.vGapXxl,

                  // Logo & Welcome
                  Center(
                    child: Column(
                      children: [
                        // Logo Container
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                          ),
                          child: const Icon(
                            Icons.point_of_sale,
                            size: 48,
                            color: AppColors.primary600,
                          ),
                        ),
                        AppSpacing.vGapLg,

                        // Title
                        Text(
                          'Selamat Datang',
                          style: AppTypography.headlineMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        AppSpacing.vGapXs,

                        // Subtitle
                        Text(
                          'Masuk untuk mengelola bisnis Anda',
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  AppSpacing.vGapXxl,

                  // Form
                  AppCard(
                    variant: AppCardVariant.elevated,
                    padding: AppSpacing.allLg,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Email Field
                          AppTextField(
                            controller: _emailController,
                            label: 'Email',
                            hint: 'Masukkan email Anda',
                            prefixIcon: const Icon(Icons.email_outlined),
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

                          // Password Field
                          AppTextField(
                            controller: _passwordController,
                            label: 'Password',
                            hint: 'Masukkan password Anda',
                            prefixIcon: const Icon(Icons.lock_outlined),
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

                          AppSpacing.vGapLg,

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
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
                          ),

                          AppSpacing.vGapMd,

                          // Login Button
                          AppButton.filled(
                            onPressed: _isLoading ? null : _submit,
                            label: 'Masuk',
                            isLoading: _isLoading,
                            size: AppButtonSize.large,
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppSpacing.vGapXl,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
