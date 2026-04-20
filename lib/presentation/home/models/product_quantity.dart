import 'dart:convert';

import 'package:pos_kita/data/models/responses/product_response_model.dart';

class ProductQuantity {
  final Product product;
  int quantity;
  ProductQuantity({required this.product, required this.quantity});

  Map<String, dynamic> toMap() {
    final priceNum = double.tryParse(product.price ?? '') ?? 0;
    return {
      'product_id': product.id,
      'quantity': quantity,
      'price': priceNum,
      'total': priceNum * quantity,
    };
  }

  String toJson() => json.encode(toMap());
}
