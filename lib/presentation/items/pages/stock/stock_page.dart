import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/constants/variables.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/core/extensions/string_ext.dart';
import 'package:pos_kita/presentation/items/bloc/product/product_bloc.dart';
import 'package:pos_kita/presentation/items/pages/stock/outlet_stock_page.dart';

import '../../../../data/models/responses/product_response_model.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> _filterProducts(List<Product> products) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return products;

    return products.where((product) {
      final name = (product.name ?? '').toLowerCase();
      final category = (product.category?.name ?? '').toLowerCase();
      final barcode = (product.barcode ?? '').toLowerCase();
      final sku = (product.sku ?? '').toLowerCase();

      return name.contains(query) ||
          category.contains(query) ||
          barcode.contains(query) ||
          sku.contains(query);
    }).toList();
  }

  @override
  void initState() {
    context.read<ProductBloc>().add(ProductEvent.getProducts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stock Management',
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
      body: BlocBuilder<ProductBloc, ProductState>(
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
                return Center(child: Text('Data produk kosong'));
              }

              final filteredProducts = _filterProducts(data);

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: AppSearchField(
                      controller: _searchController,
                      hint: 'Cari produk, kategori, barcode, atau SKU',
                      onChanged: (_) => setState(() {}),
                      onClear: () => setState(() {}),
                    ),
                  ),
                  Expanded(
                    child: filteredProducts.isEmpty
                        ? EmptySearchResults(
                            query: _searchController.text.trim(),
                            onClear: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : ListView.separated(
                            padding: EdgeInsets.only(bottom: 16),
                            itemCount: filteredProducts.length,
                            separatorBuilder: (_, _) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Divider(height: 1),
                            ),
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];

                              return ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
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
                                            product.color ?? '',
                                          ),
                                        ),
                                      ),
                                title: Text(product.name ?? '-'),
                                subtitle: Text(
                                  'Kategori: ${product.category?.name ?? '-'}',
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
                                        return OutletStockPage(
                                          data: product.stocks ?? [],
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
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
}
