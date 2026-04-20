import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/data/datasources/auth_local_datasource.dart';
import 'package:pos_kita/presentation/auth/bloc/account/account_bloc.dart';
import 'package:pos_kita/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:pos_kita/presentation/auth/pages/splash_page.dart';
import 'package:pos_kita/presentation/home/pages/home_page.dart';
import 'package:pos_kita/presentation/items/pages/item_page.dart';
import 'package:pos_kita/presentation/outlet/pages/outlet_page.dart';
import 'package:pos_kita/presentation/printer/pages/printer_page.dart';
import 'package:pos_kita/presentation/sales_report/pages/sales_report_page.dart';
import 'package:pos_kita/presentation/staff/pages/staff_page.dart';
import 'package:pos_kita/presentation/tax_discount/pages/tax_discount_page.dart';
import 'package:pos_kita/presentation/transaction/pages/history_transaction_page.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => const Center(child: CircularProgressIndicator()),
            loaded: (authData, outlet) {
              final roleName = authData.data?.roleId == 1
                ? 'Owner'
                : authData.data?.roleId == 2
                  ? 'Manager'
                  : 'Kasir';

              return Column(
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 24,
                      left: 24,
                      right: 24,
                      bottom: 24,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, AppColors.primaryDark],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Store Icon
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          child: const Icon(
                            Icons.store,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                        AppSpacing.vGapMd,
                        
                        // Outlet Name
                        Text(
                          outlet.name ?? 'Pusat',
                          style: AppTypography.titleLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        AppSpacing.vGapXs,
                        
                        // Email & Role
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                authData.data?.email ?? '',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.surface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                              ),
                              child: Text(
                                roleName,
                                style: AppTypography.labelSmall.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Menu Items
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildMenuItem(
                          icon: Icons.point_of_sale_outlined,
                          title: 'Penjualan (POS)',
                          isActive: true,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HomePage(),
                              ),
                            );
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.receipt_long_outlined,
                          title: 'Riwayat Transaksi',
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HistoryTransactionPage(),
                              ),
                            );
                          },
                        ),
                        
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        
                        if (authData.data?.roleId == 1 || authData.data?.roleId == 2) ...[
                          _buildMenuItem(
                            icon: Icons.inventory_2_outlined,
                            title: 'Produk & Stok',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ItemPage(),
                                ),
                              );
                            },
                          ),
                        ],
                        
                        _buildMenuItem(
                          icon: Icons.print_outlined,
                          title: 'Printer',
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PrinterPage(),
                              ),
                            );
                          },
                        ),
                        
                        if (authData.data?.roleId == 1 || authData.data?.roleId == 2) ...[
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          
                          _buildMenuItem(
                            icon: Icons.people_outline,
                            title: 'Manajemen Staff',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const StaffPage(),
                                ),
                              );
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.percent_outlined,
                            title: 'Pajak & Diskon',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const TaxDiscountPage(),
                                ),
                              );
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.analytics_outlined,
                            title: 'Laporan Penjualan',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SalesReportPage(),
                                ),
                              );
                            },
                          ),
                        ],
                        
                        if (authData.data?.roleId == 1) ...[
                          _buildMenuItem(
                            icon: Icons.business_outlined,
                            title: 'Manajemen Outlet',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OutletPage(
                                    outletName: outlet.name ?? 'Pusat',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  // Footer
                  Container(
                    padding: AppSpacing.allMd,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColors.divider),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMenuItem(
                          icon: Icons.logout_outlined,
                          title: 'Keluar',
                          iconColor: AppColors.error500,
                          textColor: AppColors.error500,
                          onTap: () async {
                            context.read<LogoutBloc>().add(
                              const LogoutEvent.logout(),
                            );
                            await AuthLocalDatasource().removeUserData();
                            await AuthLocalDatasource().removeOutletData();
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SplashPage(),
                                ),
                              );
                            }
                          },
                        ),
                        AppSpacing.vGapSm,
                        Text(
                          'Versi 1.0.1',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isActive = false,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isActive
            ? AppColors.primary50
            : AppColors.neutral100,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Icon(
          icon,
          size: 20,
          color: iconColor ?? (isActive ? AppColors.primary : AppColors.textSecondary),
        ),
      ),
      title: Text(
        title,
        style: AppTypography.bodyLarge.copyWith(
          color: textColor ?? (isActive ? AppColors.primary : AppColors.textPrimary),
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    );
  }
}
