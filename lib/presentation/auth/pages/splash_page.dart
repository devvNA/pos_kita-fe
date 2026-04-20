import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/presentation/auth/pages/login_page.dart';
import 'package:pos_kita/presentation/auth/pages/register_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Column(
          children: [
            // Top Section with Rounded Border
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              height: MediaQuery.of(context).size.height * 0.65,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.primary500, AppColors.primary700],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowMedium,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'app_logo',
                    child: Image.asset(
                      'assets/images/logo/poskita.png',
                      color: Colors.white,
                      width: 180,
                    ),
                  ),
                  AppSpacing.vGapSm,
                  Text(
                    'UMKM',
                    style: AppTypography.titleLarge.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      letterSpacing: 6,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  AppSpacing.vGapMd,
                  Text(
                    'Solusi POS terpadu untuk pertumbuhan usaha mikro, kecil, dan menengah.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium,
                  ),
                ],
              ),
            ),

            // Bottom Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    // Action Buttons
                    AppButton.filled(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      label: 'DAFTAR SEKARANG',
                      width: double.infinity,
                      size: AppButtonSize.large,
                    ),
                    AppSpacing.vGapMd,
                    AppButton.outlined(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      label: 'MASUK',
                      width: double.infinity,
                      size: AppButtonSize.large,
                    ),
                    const Spacer(),
                    AppSpacing.vGapXl,
                    Text(
                      'Versi 1.0.1',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    AppSpacing.vGapLg,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
