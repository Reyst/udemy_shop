import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/products_provider.dart';
import '../global/dialogs.dart';
import '../models/product.dart';
import '../widgets/app_drawer.dart';
import '../widgets/product_list_item.dart';
import 'edit_product_screen.dart';

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
            onPressed: () => Navigator.of(context).pushNamed(EditProductScreen.route),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Consumer<ProductProvider>(
        builder: (_, provider, __) {
          return RefreshIndicator(
            onRefresh: provider.fetchData,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: provider.loadedProducts.length,
              itemBuilder: (ctx, index) => ProductListItem(
                product: provider.loadedProducts[index],
                onDeleteAction: (product) => _confirmAndDelete(ctx, product),
                onEditAction: (product) => _editProduct(ctx, product),
              ),
            ),
          );
        },
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

  void _editProduct(BuildContext context, Product product) {
    Navigator.of(context).pushNamed(EditProductScreen.route, arguments: product);
  }
}
