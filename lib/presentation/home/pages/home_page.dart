import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/components/spaces.dart';
import 'package:pos_kita/core/constants/variables.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/core/design_system/tokens/colors.dart' as app_colors;
import 'package:pos_kita/core/extensions/build_context_ext.dart';
import 'package:pos_kita/core/extensions/int_ext.dart';
import 'package:pos_kita/core/extensions/string_ext.dart';
import 'package:pos_kita/core/utils/business_setting_mapper.dart';
import 'package:pos_kita/data/datasources/auth_local_datasource.dart';
import 'package:pos_kita/data/datasources/db_local_datasource.dart';
import 'package:pos_kita/data/models/requests/business_setting_request_model.dart';
import 'package:pos_kita/data/models/responses/me_response_model.dart';
import 'package:pos_kita/data/models/responses/product_response_model.dart';
import 'package:pos_kita/presentation/auth/bloc/account/account_bloc.dart';
import 'package:pos_kita/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:pos_kita/presentation/home/bloc/online_checker/online_checker_bloc.dart';
import 'package:pos_kita/presentation/home/models/product_model.dart';
import 'package:pos_kita/presentation/home/pages/checkout_page.dart';
import 'package:pos_kita/presentation/home/widgets/drawer_widget.dart';
import 'package:pos_kita/presentation/items/bloc/category/category_bloc.dart';
import 'package:pos_kita/presentation/items/bloc/product/product_bloc.dart';
import 'package:pos_kita/presentation/scanner/blocs/get_qrcode/get_qrcode_bloc.dart';
import 'package:pos_kita/presentation/scanner/pages/scanner_page.dart';
import 'package:pos_kita/presentation/tax_discount/bloc/business_setting/business_setting_bloc.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../items/bloc/category_local/category_local_bloc.dart';
import '../../items/bloc/product_local/product_local_bloc.dart';
import '../../tax_discount/bloc/business_setting_local/business_setting_local_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  OverlayEntry? _overlayEntry;
  final TextEditingController _searchController = TextEditingController();

  final GlobalKey cartKey = GlobalKey();
  bool _isAnimating = false;

  double totalPayment = 0;

  List<ProductQtyModel> orders = [];

  bool _hasFetchedOnlineData = false;
  final bool hasFetchedLocalProduct = false;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  List<Product> _filterProductsByKeyword(List<Product> products) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return products;

    return products.where((product) {
      final name = (product.name ?? '').toLowerCase();
      final category = (product.category?.name ?? '').toLowerCase();
      final barcode = (product.barcode ?? '').toLowerCase();
      final sku = (product.sku ?? '').toLowerCase();
      final description = (product.description ?? '').toLowerCase();

      return name.contains(query) ||
          category.contains(query) ||
          barcode.contains(query) ||
          sku.contains(query) ||
          description.contains(query);
    }).toList();
  }

  void addOrder(ProductModel product) {
    setState(() {
      final index = orders.indexWhere(
        (element) => element.product.id == product.id,
      );
      if (index >= 0) {
        orders[index].qty++;
      } else {
        orders.add(ProductQtyModel(product: product));
      }
      totalPayment += product.price;
    });
  }

  //category selected
  int? selectedCategory;

  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(const AccountEvent.getAccount());
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    AuthLocalDatasource().getPrinter().then((value) async {
      if (value != null) {
        await PrintBluetoothThermal.connect(
          macPrinterAddress: value.macAddress ?? "",
        );
      }
    });

    Connectivity().checkConnectivity().then(_handleConnectivity);
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      _handleConnectivity,
    );
  }

  void _handleConnectivity(List<ConnectivityResult> list) {
    final isOnline =
        list.contains(ConnectivityResult.mobile) ||
        list.contains(ConnectivityResult.wifi);

    // update status ke OnlineCheckerBloc
    context.read<OnlineCheckerBloc>().add(OnlineCheckerEvent.check(isOnline));

    if (isOnline) {
      // fetch business setting dari server (akan tersimpan ke SQLite di bloc online)
      context.read<BusinessSettingBloc>().add(
        const BusinessSettingEvent.getBusinessSetting(),
      );

      // hanya sinkron produk & kategori sekali
      if (!_hasFetchedOnlineData) {
        _fetchOnlineProductOnce();
      } else {
        context.read<CategoryBloc>().add(const CategoryEvent.getCategories());
        context.read<ProductBloc>().add(ProductEvent.getProducts());
      }
    } else {
      // ambil business setting dari SQLite
      context.read<BusinessSettingLocalBloc>().add(
        const BusinessSettingLocalEvent.getBusinessSetting(),
      );
      context.read<CategoryLocalBloc>().add(
        const CategoryLocalEvent.fetchLocal(),
      );
      context.read<ProductLocalBloc>().add(
        const ProductLocalEvent.fetchLocal(),
      );
    }
  }

  void _fetchOnlineProductOnce() {
    _hasFetchedOnlineData = true;
    context.read<CategoryBloc>().add(const CategoryEvent.getCategories());
    context.read<ProductBloc>().add(ProductEvent.getProducts());
  }

  void _startAnimation(
    BuildContext context,
    GlobalKey buttonKey,
    Widget image,
  ) {
    if (_isAnimating) return;

    final RenderBox buttonBox =
        buttonKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox cartBox =
        cartKey.currentContext!.findRenderObject() as RenderBox;
    final Offset buttonPosition = buttonBox.localToGlobal(Offset.zero);
    final Offset cartPosition = cartBox.localToGlobal(Offset.zero);

    _animation = Tween<Offset>(
      begin: buttonPosition,
      end: cartPosition,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _overlayEntry = _createFloatingIcon(buttonPosition, image);
    Overlay.of(context).insert(_overlayEntry!);

    setState(() {
      _isAnimating = true;
    });

    _controller.forward().then((_) {
      _overlayEntry?.remove();
      setState(() {
        _isAnimating = false;
        _controller.reset();
      });
    });
  }

  OverlayEntry _createFloatingIcon(Offset startPosition, Widget image) {
    return OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          final offset = Offset(_animation.value.dx, _animation.value.dy);
          return Positioned(top: offset.dy, left: offset.dx, child: image);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildStatusIndicator({
    required IconData icon,
    required Color color,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text('Penjualan'),
        centerTitle: true,
        leading: AppIconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(Icons.menu),
          variant: AppButtonVariant.filled,
          size: AppButtonSize.small,
        ),
        leadingWidth: 64,
        actions: [
          BlocBuilder<OnlineCheckerBloc, OnlineCheckerState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () => _buildStatusIndicator(
                  icon: Icons.signal_wifi_off,
                  color: AppColors.error,
                  tooltip: 'Offline',
                ),
                online: () {
                  return MultiBlocListener(
                    listeners: [
                      BlocListener<BusinessSettingBloc, BusinessSettingState>(
                        listener: (context, state) {
                          state.maybeMap(
                            orElse: () {},
                            loaded: (n) async {
                              final listLocal = n.data
                                  .map((e) => e.toTaxDiscount())
                                  .toList();
                              await DBLocalDatasource.instance
                                  .removeAllTaxDiscount();
                              await DBLocalDatasource.instance
                                  .insertAllTaxDiscount(listLocal);
                            },
                            error: (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.message),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                              debugPrint(e.message);
                            },
                          );
                        },
                      ),
                    ],
                    child: _buildStatusIndicator(
                      icon: Icons.wifi,
                      color: AppColors.success,
                      tooltip: 'Online',
                    ),
                  );
                },
              );
            },
          ),
          SpaceWidth(16),
          BlocListener<GetQrcodeBloc, GetQrcodeState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                success: (value) async {
                  context.read<ProductBloc>().add(
                    ProductEvent.getProductByBarcode(value),
                  );
                },
              );
            },
            child: GestureDetector(
              onTap: () {
                context.read<GetQrcodeBloc>().add(
                  const GetQrcodeEvent.started(),
                );
                context.push(const ScannerPage());
              },
              child: Image.asset(
                'assets/images/barcode.png',
                color: AppColors.white,
                height: 28,
              ),
            ),
          ),
          SpaceWidth(16),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: AppSpacing.screenPadding,
            child: AppCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CheckoutPage()),
                );
              },
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_checkout,
                        color: Colors.white.withValues(alpha: 0.9),
                        size: 20,
                      ),
                      AppSpacing.hGapSm,
                      Text(
                        key: cartKey,
                        'BAYAR',
                        style: AppTypography.labelLarge.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  BlocBuilder<CheckoutBloc, CheckoutState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        orElse: () {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Rp 0',
                                style: AppTypography.priceMedium.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              AppSpacing.hGapMd,
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.sm,
                                  ),
                                ),
                                child: Text(
                                  '0 item',
                                  style: AppTypography.labelMedium.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        success: (orders, promo, tax, subtotal, total, qty) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                total.currencyFormatRp,
                                style: AppTypography.priceMedium.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              AppSpacing.hGapMd,
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.sm,
                                  ),
                                ),
                                child: Text(
                                  '$qty item',
                                  style: AppTypography.labelMedium.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          //  Search & Filter Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: AppSearchField(
                    controller: _searchController,
                    hint: 'Cari produk...',
                    onChanged: (_) => setState(() {}),
                    onClear: () => setState(() {}),
                  ),
                ),
                AppSpacing.hGapSm,
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.input),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: BlocBuilder<OnlineCheckerBloc, OnlineCheckerState>(
                      builder: (context, state) {
                        final bool isOnline = state.maybeWhen(
                          online: () => true,
                          orElse: () => false,
                        );

                        return isOnline
                            ? _buildOnlineCategoryDropdown()
                            : _buildOfflineCategoryDropdown();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.vGapXs,
          Expanded(
            child: BlocBuilder<AccountBloc, AccountState>(
              builder: (context, state) {
                final outletData = state.maybeWhen(
                  orElse: () => null,
                  loaded: (data, outlet) => outlet,
                );
                return BlocBuilder<OnlineCheckerBloc, OnlineCheckerState>(
                  builder: (context, state) {
                    final bool isOnline = state.maybeWhen(
                      online: () => true,
                      orElse: () => false,
                    );

                    return isOnline
                        ? BlocBuilder<
                            BusinessSettingBloc,
                            BusinessSettingState
                          >(
                            builder: (context, state) {
                              List<BusinessSettingRequestModel> taxs = state
                                  .maybeWhen(
                                    orElse: () =>
                                        <BusinessSettingRequestModel>[],
                                    loaded: (data) => data.where((element) {
                                      return element.chargeType == 'tax';
                                    }).toList(),
                                  );
                              return productSection(outletData, taxs);
                            },
                          )
                        : BlocBuilder<
                            BusinessSettingLocalBloc,
                            BusinessSettingLocalState
                          >(
                            builder: (context, state) {
                              List<BusinessSettingRequestModel> taxs = state
                                  .maybeWhen(
                                    orElse: () =>
                                        <BusinessSettingRequestModel>[],
                                    loaded: (data) => data
                                        .where((e) => e.chargeType == 'tax')
                                        .map((e) => e.toRequestModel())
                                        .toList(),
                                  );
                              return productLocalSection(outletData, taxs);
                            },
                          );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  BlocBuilder<ProductBloc, ProductState> productSection(
    Outlet? outletData,
    List<BusinessSettingRequestModel> taxs,
  ) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () {
            return const ProductListSkeleton();
          },
          loading: () {
            return const ProductListSkeleton();
          },
          success: (products) {
            final filteredProducts = _filterProductsByKeyword(products);

            if (products.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [const EmptyCategories()],
              );
            }
            if (filteredProducts.isEmpty) {
              return EmptySearchResults(
                query: _searchController.text.trim(),
                onClear: () {
                  _searchController.clear();
                  setState(() {});
                },
              );
            }
            return ListView.separated(
              padding: AppSpacing.screenPadding,
              itemBuilder: (context, index) {
                GlobalKey buttonKey = GlobalKey();
                return BlocBuilder<OnlineCheckerBloc, OnlineCheckerState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () {
                        // not check stock
                        return _buildProductCard(
                          filteredProducts[index],
                          buttonKey,
                          outletData,
                          taxs,
                          true,
                          false,
                        );
                      },
                      offline: () {
                        // offline, tetap cek stok tersimpan lokal
                        return _buildProductCard(
                          filteredProducts[index],
                          buttonKey,
                          outletData,
                          taxs,
                          true,
                          false,
                        );
                      },
                      online: () {
                        // online, check stock
                        return _buildProductCard(
                          filteredProducts[index],
                          buttonKey,
                          outletData,
                          taxs,
                          true,
                          true,
                        );
                      },
                    );
                  },
                );
              },
              itemCount: filteredProducts.length,
              separatorBuilder: (context, index) {
                return AppSpacing.vGapSm;
              },
            );
          },
        );
      },
    );
  }

  BlocBuilder<ProductLocalBloc, ProductLocalState> productLocalSection(
    Outlet? outletData,
    List<BusinessSettingRequestModel> taxs,
  ) {
    return BlocBuilder<ProductLocalBloc, ProductLocalState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () {
            return const ProductListSkeleton();
          },
          loading: () {
            return const ProductListSkeleton();
          },
          success: (products) {
            final filteredProducts = _filterProductsByKeyword(products);

            if (products.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [const EmptyCategories()],
              );
            }
            if (filteredProducts.isEmpty) {
              return EmptySearchResults(
                query: _searchController.text.trim(),
                onClear: () {
                  _searchController.clear();
                  setState(() {});
                },
              );
            }
            return ListView.separated(
              padding: AppSpacing.screenPadding,
              itemBuilder: (context, index) {
                GlobalKey buttonKey = GlobalKey();
                return BlocBuilder<OnlineCheckerBloc, OnlineCheckerState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () {
                        // not check stock
                        return _buildProductCard(
                          filteredProducts[index],
                          buttonKey,
                          outletData,
                          taxs,
                          true,
                          false,
                        );
                      },
                      offline: () {
                        // offline, tetap cek stok tersimpan lokal
                        return _buildProductCard(
                          filteredProducts[index],
                          buttonKey,
                          outletData,
                          taxs,
                          true,
                          false,
                        );
                      },
                      online: () {
                        // online, check stock
                        return _buildProductCard(
                          filteredProducts[index],
                          buttonKey,
                          outletData,
                          taxs,
                          true,
                          true,
                        );
                      },
                    );
                  },
                );
              },
              itemCount: filteredProducts.length,
              separatorBuilder: (context, index) {
                return AppSpacing.vGapSm;
              },
            );
          },
        );
      },
    );
  }

  Widget _buildOnlineCategoryDropdown() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => _buildDropdownPlaceholder(),
          success: (data) => DropdownButton<int>(
            isExpanded: true,
            value: selectedCategory,
            underline: const SizedBox(),
            dropdownColor: AppColors.surface,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textTertiary,
              size: 20,
            ),
            items: [
              DropdownMenuItem<int>(
                value: null,
                child: Text(
                  'Semua',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              ...data.map(
                (e) => DropdownMenuItem<int>(
                  value: e.id,
                  child: Text(
                    e.name ?? "",
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() => selectedCategory = value);
              if (value == null) {
                context.read<ProductBloc>().add(
                  const ProductEvent.getProducts(),
                );
              } else {
                context.read<ProductBloc>().add(
                  ProductEvent.getProductsByCategory(value),
                );
              }
            },
            hint: Text(
              'Kategori',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOfflineCategoryDropdown() {
    return BlocBuilder<CategoryLocalBloc, CategoryLocalState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => _buildDropdownPlaceholder(),
          success: (data) => DropdownButton<int>(
            isExpanded: true,
            value: selectedCategory,
            underline: const SizedBox(),
            dropdownColor: AppColors.surface,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textTertiary,
              size: 20,
            ),
            items: [
              DropdownMenuItem<int>(
                value: null,
                child: Text(
                  'Semua',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              ...data.map(
                (e) => DropdownMenuItem<int>(
                  value: e.categoryId,
                  child: Text(
                    e.name ?? "",
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() => selectedCategory = value);
              if (value == null) {
                context.read<ProductLocalBloc>().add(
                  const ProductLocalEvent.fetchLocal(),
                );
              } else {
                context.read<ProductLocalBloc>().add(
                  ProductLocalEvent.getProductsByCategoryLocal(value),
                );
              }
            },
            hint: Text(
              'Kategori',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdownPlaceholder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Loading...',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
        Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.textTertiary,
          size: 20,
        ),
      ],
    );
  }

  Widget _buildProductCard(
    Product product,
    GlobalKey buttonKey,
    dynamic outletData,
    List<BusinessSettingRequestModel> taxs,
    bool validateStock,
    bool showStock,
  ) {
    int getStock() {
      if (product.stocks == null || product.stocks!.isEmpty) {
        return product.stock ?? 0;
      }

      final match = product.stocks!
          .firstWhere(
            (e) => e.outletId == outletData?.id,
            orElse: () => product.stocks!.first,
          )
          .quantity;

      return match ?? 0;
    }

    int getCartQuantity() {
      return context.read<CheckoutBloc>().state.maybeWhen(
        success: (cart, _, _, _, _, _) {
          final index = cart.indexWhere(
            (item) => item.product.id == product.id,
          );
          if (index == -1) {
            return 0;
          }

          return cart[index].quantity;
        },
        orElse: () => 0,
      );
    }

    // Hanya hitung stok bila diperlukan
    final int stock = (validateStock || showStock) ? getStock() : 0;

    return InkWell(
      key: buttonKey,
      onTap: () async {
        final cartQuantity = validateStock ? getCartQuantity() : 0;

        if (validateStock && stock <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Stok Habis"),
              backgroundColor: AppColors.error,
            ),
          );
          return;
        }

        if (validateStock && cartQuantity >= stock) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Stok ${product.name ?? 'produk'} tidak mencukupi'),
              backgroundColor: AppColors.error,
            ),
          );
          return;
        }

        _startAnimation(
          context,
          buttonKey,
          product.image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: Variables.baseUrl + product.image!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: app_colors.AppColors.changeStringtoColor(
                      product.color ?? "",
                    ),
                  ),
                ),
        );

        await Future.delayed(const Duration(milliseconds: 700));
        if (!mounted) return;

        context.read<CheckoutBloc>().add(
          CheckoutEvent.addToCart(
            product: product,
            businessSetting: taxs,
            maxStock: stock,
          ),
        );
      },
      child: Card(
        color: AppColors.surface,
        child: ListTile(
          leading: product.image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: Variables.baseUrl + product.image!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: app_colors.AppColors.changeStringtoColor(
                      product.color ?? "",
                    ),
                  ),
                ),
          title: Text(
            product.name ?? "",
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: showStock
              ? Text(
                  "Stock: $stock",
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                )
              : null,
          trailing: Text(
            product.price!.currencyFormatRpV3,
            style: AppTypography.priceSmall.copyWith(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}
