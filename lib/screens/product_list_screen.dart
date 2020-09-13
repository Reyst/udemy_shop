import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/cart_provider.dart';
import '../data/products_provider.dart';
import '../models/product.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/product_grid_item.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  static const String route = "/product-list";

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  FavoriteFilterValue _currentFilter = FavoriteFilterValue.allItems;

  Future<void> _loading;

  @override
  void initState() {
    _loading = context.read<ProductProvider>().fetchData();
    super.initState();
  }

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
      body: FutureBuilder(
        future: _loading,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          return Consumer<ProductProvider>(
            builder: (c, provider, child) {
              final products = _currentFilter == FavoriteFilterValue.allItems ? provider.loadedProducts : provider.favoriteProducts;

              return RefreshIndicator(
                onRefresh: () => _refreshData(c),
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: products.length,
                  itemBuilder: (c, index) => ProductGridItem(
                    product: products[index],
                    isFavorite: provider.isFavorite(products[index]),
                    onItemTap: _navigateToDetails,
                    onFavoriteTap: _toggleFavorite,
                    onCartTap: (product) => _addProductToCart(ctx, product),
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.0 / 3.0,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _toggleFavorite(Product product) {
    context.read<ProductProvider>().toggle(product);
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

  Future<void> _refreshData(BuildContext context) async => context.read<ProductProvider>().fetchData();
}

enum FavoriteFilterValue {
  allItems,
  onlyFavorite,
}
