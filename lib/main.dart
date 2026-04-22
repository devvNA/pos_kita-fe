import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/data/datasources/auth_local_datasource.dart';
import 'package:pos_kita/data/datasources/auth_remote_datasource.dart';
import 'package:pos_kita/data/datasources/business_setting_local_datasource.dart';
import 'package:pos_kita/data/datasources/business_setting_remote_datasource.dart';
import 'package:pos_kita/data/datasources/category_remote_datasource.dart';
import 'package:pos_kita/data/datasources/db_local_datasource.dart';
import 'package:pos_kita/data/datasources/order_remote_datasource.dart';
import 'package:pos_kita/data/datasources/outlet_remote_datasource.dart';
import 'package:pos_kita/data/datasources/printer_remote_datasource.dart';
import 'package:pos_kita/data/datasources/product_remote_datasource.dart';
import 'package:pos_kita/data/datasources/sales_report_remote_datasource.dart';
import 'package:pos_kita/data/datasources/staff_remote_datasource.dart';
import 'package:pos_kita/data/models/responses/auth_response_model.dart';
import 'package:pos_kita/presentation/auth/bloc/account/account_bloc.dart';
import 'package:pos_kita/presentation/auth/bloc/login/login_bloc.dart';
import 'package:pos_kita/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:pos_kita/presentation/auth/pages/splash_page.dart';
import 'package:pos_kita/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:pos_kita/presentation/home/bloc/online_checker/online_checker_bloc.dart';
import 'package:pos_kita/presentation/home/bloc/order/order_bloc.dart';
import 'package:pos_kita/presentation/home/bloc/order_offline/order_offline_bloc.dart';
import 'package:pos_kita/presentation/home/bloc/transaction/transaction_bloc.dart';
import 'package:pos_kita/presentation/home/bloc/transaction_offline/transaction_offline_bloc.dart';
import 'package:pos_kita/presentation/home/pages/home_page.dart';
import 'package:pos_kita/presentation/items/bloc/category/category_bloc.dart';
import 'package:pos_kita/presentation/items/bloc/product/product_bloc.dart';
import 'package:pos_kita/presentation/outlet/bloc/outlet/outlet_bloc.dart';
import 'package:pos_kita/presentation/printer/bloc/printer/printer_bloc.dart';
import 'package:pos_kita/presentation/sales_report/bloc/sales_report/sales_report_bloc.dart';
import 'package:pos_kita/presentation/scanner/blocs/get_qrcode/get_qrcode_bloc.dart';
import 'package:pos_kita/presentation/staff/bloc/staff/staff_bloc.dart';
import 'package:pos_kita/presentation/tax_discount/bloc/business_setting/business_setting_bloc.dart';
import 'package:pos_kita/presentation/tax_discount/bloc/business_setting_local/business_setting_local_bloc.dart';
import 'package:pos_kita/presentation/transaction/blocs/sync_order/sync_order_bloc.dart';

import 'presentation/auth/bloc/register/register_bloc.dart';
import 'presentation/items/bloc/category_local/category_local_bloc.dart';
import 'presentation/items/bloc/product_local/product_local_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
      isToolbarVisible: true,
      availableLocales: const [Locale('id', 'ID')],
      backgroundColor: Colors.white,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RegisterBloc(AuthRemoteDataSource())),
        BlocProvider(create: (context) => LoginBloc(AuthRemoteDataSource())),
        BlocProvider(create: (context) => LogoutBloc(AuthRemoteDataSource())),
        BlocProvider(
          create: (context) => CategoryBloc(
            CategoryRemoteDataSource(),
            DBLocalDatasource.instance,
          ),
        ),
        BlocProvider(
          create: (context) => ProductBloc(
            ProductRemoteDataSource(),
            DBLocalDatasource.instance,
          ),
        ),
        BlocProvider(create: (context) => CheckoutBloc()),
        BlocProvider(create: (context) => OrderBloc(OrderRemoteDatasource())),
        BlocProvider(
          create: (context) => TransactionBloc(OrderRemoteDatasource()),
        ),
        BlocProvider(create: (context) => AccountBloc(AuthLocalDatasource())),
        BlocProvider(create: (context) => OutletBloc(OutletRemoteDatasource())),
        BlocProvider(create: (context) => StaffBloc(StaffRemoteDatasource())),
        BlocProvider(
          create: (context) => PrinterBloc(PrinterRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) =>
              BusinessSettingBloc(BusinessSettingRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => SalesReportBloc(SalesReportRemoteDatasource()),
        ),
        BlocProvider(create: (context) => GetQrcodeBloc()),
        BlocProvider(create: (context) => OnlineCheckerBloc()),
        BlocProvider(create: (context) => OrderOfflineBloc()),
        BlocProvider(create: (context) => TransactionOfflineBloc()),
        BlocProvider(
          create: (context) => SyncOrderBloc(
            DBLocalDatasource.instance,
            OrderRemoteDatasource(),
          ),
        ),
        BlocProvider(
          create: (context) =>
              BusinessSettingLocalBloc(BusinessSettingLocalDatasource()),
        ),
        BlocProvider(
          create: (context) => CategoryLocalBloc(DBLocalDatasource.instance),
        ),
        BlocProvider(
          create: (context) => ProductLocalBloc(DBLocalDatasource.instance),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Jago POS',
        theme: _buildTheme(context),
        home: FutureBuilder<AuthResponseModel?>(
          future: AuthLocalDatasource().getUserData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null && snapshot.data!.accessToken != null) {
                return const HomePage();
              } else {
                return const SplashPage();
              }
            } else {
              return const SplashPage();
            }
          },
        ),
      ),
    );
  }

  ThemeData _buildTheme(BuildContext context) {
    final baseTheme = ThemeData.light(useMaterial3: true);
    final textTheme = AppTypography.textTheme;

    return baseTheme.copyWith(
      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primary100,
        onPrimaryContainer: AppColors.primary900,
        secondary: AppColors.info500,
        onSecondary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.textSecondary,
        error: AppColors.error500,
        onError: Colors.white,
        outline: AppColors.border,
      ),

      // Typography
      textTheme: textTheme,

      // Scaffold Background
      scaffoldBackgroundColor: AppColors.background,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 24),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        color: AppColors.surface,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: AppTypography.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.border, width: 1.5),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: AppTypography.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTypography.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: AppColors.error500, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: AppColors.error500, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: AppColors.disabled),
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textTertiary,
        ),
        errorStyle: AppTypography.bodySmall.copyWith(color: AppColors.error500),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        titleTextStyle: AppTypography.bodyLarge.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        iconColor: AppColors.textTertiary,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        selectedColor: AppColors.primary,
        labelStyle: AppTypography.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.modal),
        ),
        titleTextStyle: AppTypography.headlineSmall,
        contentTextStyle: AppTypography.bodyMedium,
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.neutral800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: Colors.white,
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.neutral200,
        circularTrackColor: AppColors.neutral200,
      ),

      // Drawer Theme
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColors.surface,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(AppRadius.lg),
          ),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
    );
  }
}
