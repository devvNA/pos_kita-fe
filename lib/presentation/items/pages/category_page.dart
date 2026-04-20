import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/components/spaces.dart';
import 'package:pos_kita/core/design_system/tokens/colors.dart';
import 'package:pos_kita/presentation/items/bloc/category/category_bloc.dart';
import 'package:pos_kita/presentation/items/pages/add_category_page.dart';
import 'package:pos_kita/presentation/items/pages/edit_category_page.dart';

import '../../home/bloc/online_checker/online_checker_bloc.dart';
import '../bloc/category_local/category_local_bloc.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
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
      }
    }
  }

  void _fetchOnlineProductOnce() {
    _hasFetchedOnlineData = true;
    context.read<CategoryBloc>().add(const CategoryEvent.getCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
        ),
        title: const Text(
          'Categories',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<OnlineCheckerBloc, OnlineCheckerState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => Center(child: CircularProgressIndicator()),
            online: () {
              return BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  return state.map(
                    initial: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    loading: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error) => Center(child: Text(error.message)),
                    success: (success) {
                      if (success.data.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Center(child: Text('No Categories')),
                            SpaceHeight(30),
                            //add category button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const AddCategoryPage();
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                'Add Category',
                                style: TextStyle(color: AppColors.white),
                              ),
                            ),
                          ],
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: success.data.length + 1,
                        itemBuilder: (context, index) {
                          if (index == success.data.length) {
                            return const SizedBox();
                          }
                          final category = success.data[index];
                          return Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.category),
                                title: Text(category.name!),
                                trailing: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return EditCategoryPage(
                                            category: category,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
            offline: () {
              return BlocBuilder<CategoryLocalBloc, CategoryLocalState>(
                builder: (context, state) {
                  return state.map(
                    initial: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    loading: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error) => Center(child: Text(error.message)),
                    success: (success) {
                      if (success.categories.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Center(child: Text('No Categories')),
                            SpaceHeight(30),
                            //add category button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const AddCategoryPage();
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                'Add Category',
                                style: TextStyle(color: AppColors.white),
                              ),
                            ),
                          ],
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: success.categories.length + 1,
                        itemBuilder: (context, index) {
                          if (index == success.categories.length) {
                            return const SizedBox();
                          }
                          final category = success.categories[index];
                          return Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.category),
                                title: Text(category.name!),
                                trailing: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return EditCategoryPage(
                                            category: category,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const AddCategoryPage();
              },
            ),
          );
        },
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
