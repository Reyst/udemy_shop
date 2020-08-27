import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../global/dialogs.dart';
import '../models/product.dart';
import '../data/cart_provider.dart';
import '../data/favorites_provider.dart';
import '../data/products_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/product_grid_item.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatefulWidget {
  static const String route = "/";

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  FavoriteFilterValue _currentFilter = FavoriteFilterValue.allItems;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
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
              onPressed: () => Navigator.of(context).pushNamed(CartScreen.route),
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
      body: Consumer2<FavoritesProvider, ProductProvider>(
        builder: (ctx, fProvider, pProvider, child) {
          return FutureBuilder<List<Product>>(
            future: _getProductListWithFilters(pProvider, fProvider),
            builder: (ctx, snapShot) {
              if (snapShot.connectionState != ConnectionState.done && !snapShot.hasData)
                return Center(child: CircularProgressIndicator());

              if (snapShot.hasError) {
                showErrorDialog(ctx, content: snapShot.error.toString());
                return null;
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: snapShot.data.length,
                itemBuilder: (c, index) => FutureBuilder<bool>(
                  future: fProvider.isFavorite(snapShot.data[index]),
                  builder: (bContext, favoriteSnap) => ProductGridItem(
                    product: snapShot.data[index],
                    isFavorite: favoriteSnap.hasData && favoriteSnap.data,
                    onItemTap: _navigateToDetails,
                    onFavoriteTap: _toggleFavorite,
                    onCartTap: (product) => _addProductToCart(bContext, product),
                  ),
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2.0 / 3.0,
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _toggleFavorite(Product product) {
    context.read<FavoritesProvider>().toggle(product);
  }

  void _addProductToCart(BuildContext ctx, Product product) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addProduct(product);

    final parentScaffold = Scaffold.of(ctx);

    parentScaffold.hideCurrentSnackBar();
    parentScaffold.showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.all(8),
          child: Text('${product.title} has been added to cart!'),
        ),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () => cartProvider.removeProduct(product),
        ),
      ),
    );
  }

  void _navigateToDetails(Product product) {
    Navigator.of(context).pushNamed(ProductDetailScreen.route, arguments: product);
  }

  void _applyFilter(FavoriteFilterValue selected) {
    if (_currentFilter != selected) {
      setState(() => _currentFilter = selected);
    }
  }

  Future<List<Product>> _getProductListWithFilters(ProductProvider pProvider, FavoritesProvider fProvider) async {
    final products = await pProvider.loadedProducts;
    final favoriteIds = await fProvider.favoritesIds;

    return products
        .where((product) => _currentFilter == FavoriteFilterValue.allItems || favoriteIds.contains(product.id))
        .toList();
  }
}

enum FavoriteFilterValue {
  allItems,
  onlyFavorite,
}
