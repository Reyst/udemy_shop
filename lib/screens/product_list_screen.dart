import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/favorites_provider.dart';
import '../data/products_provider.dart';
import '../widgets/product_item.dart';

class ProductListScreen extends StatelessWidget {
  static const String route = "/";

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>().loadedProducts;
    return Scaffold(
      appBar: AppBar(title: Text("Products")),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (ctx, index) => ProductItem(product: products[index]),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.0 / 3.0,
        ),
      ),
    );
  }
}
