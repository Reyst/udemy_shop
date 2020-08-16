import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/cart_provider.dart';
import '../data/favorites_provider.dart';
import '../data/products_provider.dart';
import '../widgets/badge.dart';
import '../widgets/product_item.dart';

class ProductListScreen extends StatefulWidget {
  static const String route = "/";

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  FavoriteFilterValue _currentFilter = FavoriteFilterValue.allItems;

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final products = context
        .watch<ProductProvider>()
        .loadedProducts
        .where((product) => _currentFilter == FavoriteFilterValue.allItems || favorites.isFavorite(product))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        actions: [
          Consumer<CartProvider>(
            builder: (ctx, value, child) {
              return value.productAmount > 0
                  ? Badge(
                      child: child,
                      value: value.productAmount.toString(),
                      color: Colors.red[900],
                    )
                  : child;
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
          ),
          PopupMenuButton(
            onSelected: (FavoriteFilterValue selected) => _applyFilter(selected),
            icon: Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: const Text("All items"),
                value: FavoriteFilterValue.allItems,
              ),
              PopupMenuItem(
                child: const Text("Only favorite"),
                value: FavoriteFilterValue.onlyFavorite,
              ),
            ],
          )
        ],
      ),
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

  void _applyFilter(FavoriteFilterValue selected) {
    if (_currentFilter != selected) {
      setState(() {
        _currentFilter = selected;
      });
    }
  }
}

enum FavoriteFilterValue {
  allItems,
  onlyFavorite,
}
