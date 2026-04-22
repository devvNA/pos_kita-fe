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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompactHeight = constraints.maxHeight < 760;
              final horizontalPadding = constraints.maxWidth >= 600
                  ? AppSpacing.xxxl
                  : AppSpacing.xxl;
              final topHeight =
                  (constraints.maxHeight * (isCompactHeight ? 0.58 : 0.65))
                      .clamp(360.0, 560.0)
                      .toDouble();
              final logoWidth = constraints.maxWidth < 360 ? 148.0 : 180.0;
              final titleSpacing = isCompactHeight
                  ? AppSpacing.xs
                  : AppSpacing.sm;
              final descriptionSpacing = isCompactHeight
                  ? AppSpacing.sm
                  : AppSpacing.md;
              final bottomTopSpacing = isCompactHeight
                  ? AppSpacing.lg
                  : AppSpacing.xxl;
              final bottomBottomSpacing = isCompactHeight
                  ? AppSpacing.md
                  : AppSpacing.lg;

              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    height: topHeight,
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
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Hero(
                              tag: 'app_logo',
                              child: Image.asset(
                                'assets/images/logo/poskita.png',
                                color: Colors.white,
                                width: logoWidth,
                              ),
                            ),
                            SizedBox(height: titleSpacing),
                            Text(
                              'UMKM',
                              style: AppTypography.titleLarge.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                                letterSpacing: isCompactHeight ? 4 : 6,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: descriptionSpacing),
                            Text(
                              'Solusi POS terpadu untuk pertumbuhan usaha mikro, kecil, dan menengah.',
                              textAlign: TextAlign.center,
                              maxLines: isCompactHeight ? 3 : 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodyMedium.copyWith(
                                color: Colors.white,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        bottomTopSpacing,
                        horizontalPadding,
                        bottomBottomSpacing,
                      ),
                      child: Column(
                        children: [
                          const Spacer(),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 420),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppButton.filled(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterPage(),
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
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Versi 1.0.1',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
