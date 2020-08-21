import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../global/dialogs.dart';
import '../models/product.dart';
import '../data/products_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/product_list_item.dart';

class ProductsManagementScreen extends StatelessWidget {
  static const String route = "/products-management";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product management'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Consumer<ProductProvider>(
        builder: (_, provider, __) => ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: provider.loadedProducts.length,
          itemBuilder: (ctx, index) => ProductListItem(
            product: provider.loadedProducts[index],
            onDeleteAction: (product) => _confirmAndDelete(ctx, product),
          ),
        ),
      ),
    );
  }

  void _confirmAndDelete(BuildContext context, Product product) {
    showConfirmDialog(
      context,
      content: 'Do you really want to delete ${product.title}?',
    ).then((value) {
      if (value) {
        context.read<ProductProvider>().removeProduct(product);
      }
    });
  }
}
