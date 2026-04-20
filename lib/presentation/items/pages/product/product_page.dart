import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/constants/variables.dart';
import 'package:pos_kita/core/design_system/tokens/colors.dart';
import 'package:pos_kita/core/extensions/string_ext.dart';
import 'package:pos_kita/presentation/items/bloc/category/category_bloc.dart';
import 'package:pos_kita/presentation/items/pages/product/add_product_page.dart';
import 'package:pos_kita/presentation/items/pages/product/detail_product_page.dart';

import '../../../home/bloc/online_checker/online_checker_bloc.dart';
import '../../bloc/category_local/category_local_bloc.dart';
import '../../bloc/product/product_bloc.dart';
import '../../bloc/product_local/product_local_bloc.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool _hasFetchedOnlineData = false;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();

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
    if (mounted) {
      context.read<OnlineCheckerBloc>().add(OnlineCheckerEvent.check(isOnline));
    }

    if (isOnline) {
      // hanya sinkron produk & kategori sekali
      if (mounted) {
        if (!_hasFetchedOnlineData) _fetchOnlineProductOnce();
      }
    } else {
      if (mounted) {
        context.read<CategoryLocalBloc>().add(
          const CategoryLocalEvent.fetchLocal(),
        );
        context.read<ProductLocalBloc>().add(
          const ProductLocalEvent.fetchLocal(),
        );
      }
    }
  }

  void _fetchOnlineProductOnce() {
    _hasFetchedOnlineData = true;
    context.read<CategoryBloc>().add(const CategoryEvent.getCategories());
    context.read<ProductBloc>().add(ProductEvent.getProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
        ),
      ),
      body: BlocBuilder<OnlineCheckerBloc, OnlineCheckerState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => Center(child: CircularProgressIndicator()),
            online: () {
              return BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () {
                      return Center(child: CircularProgressIndicator());
                    },
                    loading: () {
                      return Center(child: CircularProgressIndicator());
                    },
                    error: (message) {
                      return Center(child: Text(message));
                    },
                    success: (data) {
                      if (data.isEmpty) {
                        return Center(child: Text("No data"));
                      }
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          final product = data[index];
                          return Column(
                            children: [
                              ListTile(
                                leading: product.image != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          '${Variables.baseUrl}${product.image!}',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          color: AppColors.changeStringtoColor(
                                            product.color ?? "",
                                          ),
                                        ),
                                      ),
                                title: Text(product.name ?? ""),
                                subtitle: Text(
                                  "Category: ${product.category?.name}",
                                ),
                                trailing: Text(
                                  product.price!.currencyFormatRpV3,
                                  style: TextStyle(fontSize: 14),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return DetailProductPage(data: product);
                                      },
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Divider(),
                              ),
                            ],
                          );
                        },
                        itemCount: data.length,
                      );
                    },
                  );
                },
              );
            },
            offline: () {
              return BlocBuilder<ProductLocalBloc, ProductLocalState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () {
                      return Center(child: CircularProgressIndicator());
                    },
                    loading: () {
                      return Center(child: CircularProgressIndicator());
                    },
                    error: (message) {
                      return Center(child: Text(message));
                    },
                    success: (data) {
                      if (data.isEmpty) {
                        return Center(child: Text("No data"));
                      }
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          final product = data[index];
                          return Column(
                            children: [
                              ListTile(
                                leading: product.image != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          '${Variables.baseUrl}${product.image!}',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          color: AppColors.changeStringtoColor(
                                            product.color ?? "",
                                          ),
                                        ),
                                      ),
                                title: Text(product.name ?? ""),
                                // subtitle: _hasFetchedOnlineData
                                //     ? Text(
                                //         "Category: ${product.category?.name}")
                                //     : SizedBox(),
                                trailing: Text(
                                  product.price!.currencyFormatRpV3,
                                  style: TextStyle(fontSize: 14),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return DetailProductPage(data: product);
                                      },
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Divider(),
                              ),
                            ],
                          );
                        },
                        itemCount: data.length,
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: BlocBuilder<OnlineCheckerBloc, OnlineCheckerState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => Center(child: CircularProgressIndicator()),
            online: () {
              return BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  final categories = state.maybeWhen(
                    orElse: () => [],
                    success: (data) => data,
                  );
                  return FloatingActionButton(
                    onPressed: () {
                      if (categories.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please add category first"),
                            backgroundColor: AppColors.red,
                          ),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AddProductPage();
                          },
                        ),
                      );
                    },
                    backgroundColor: AppColors.primary,
                    child: const Icon(Icons.add, color: AppColors.white),
                  );
                },
              );
            },
            offline: () {
              return BlocBuilder<CategoryLocalBloc, CategoryLocalState>(
                builder: (context, state) {
                  final categories = state.maybeWhen(
                    orElse: () => [],
                    success: (data) => data,
                  );
                  return FloatingActionButton(
                    onPressed: () {
                      if (categories.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please add category first"),
                            backgroundColor: AppColors.red,
                          ),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AddProductPage();
                          },
                        ),
                      );
                    },
                    backgroundColor: AppColors.primary,
                    child: const Icon(Icons.add, color: AppColors.white),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
