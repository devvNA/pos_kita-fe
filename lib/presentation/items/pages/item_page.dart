import 'package:flutter/material.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/presentation/home/widgets/drawer_widget.dart';
import 'package:pos_kita/presentation/items/pages/category_page.dart';
import 'package:pos_kita/presentation/items/pages/product/product_page.dart';
import 'package:pos_kita/presentation/items/pages/stock/stock_page.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: const DrawerWidget(),
      body: SafeArea(
        child: Column(
          children: [
            // ── Gradient Header ──
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
                boxShadow: AppShadows.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _HeaderIconButton(
                        icon: Icons.menu_rounded,
                        onTap: () =>
                            _scaffoldKey.currentState?.openDrawer(),
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
                          'Manajemen',
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
                    'Kelola item',
                    style: AppTypography.headlineMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AppSpacing.vGapXs,
                  Text(
                    'Atur produk, kategori, dan stok dari satu tempat.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.92),
                    ),
                  ),
                ],
              ),
            ),

            // ── Menu Items ──
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.allLg,
                child: Column(
                  children: [
                    _MenuCard(
                      icon: Icons.inventory_2_outlined,
                      iconColor: AppColors.primary,
                      iconBgColor: AppColors.primary50,
                      title: 'Produk',
                      subtitle: 'Lihat, tambah, dan edit daftar produk.',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProductPage(),
                          ),
                        );
                      },
                    ),
                    AppSpacing.vGapMd,
                    _MenuCard(
                      icon: Icons.category_outlined,
                      iconColor: AppColors.info600,
                      iconBgColor: AppColors.info50,
                      title: 'Kategori',
                      subtitle:
                          'Kelompokkan produk berdasarkan kategori.',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CategoryPage(),
                          ),
                        );
                      },
                    ),
                    AppSpacing.vGapMd,
                    _MenuCard(
                      icon: Icons.warehouse_outlined,
                      iconColor: AppColors.success600,
                      iconBgColor: AppColors.success50,
                      title: 'Stok',
                      subtitle:
                          'Pantau dan perbarui jumlah stok barang.',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StockPage(),
                          ),
                        );
                      },
                    ),
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

// ─────────────────────────────────────────────────────────────────────────────
// Private widgets
// ─────────────────────────────────────────────────────────────────────────────

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onTap});

  final IconData icon;
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
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: AppSpacing.allLg,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          AppSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppSpacing.vGapXxs,
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.hGapSm,
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textTertiary,
            size: 24,
          ),
        ],
      ),
    );
  }
}
