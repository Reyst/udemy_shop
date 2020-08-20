import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/cart_provider.dart';
import '../data/favorites_provider.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GridTile(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          header: GridTileBar(
            backgroundColor: Colors.black54,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(
              product.price.toStringAsFixed(2),
              textAlign: TextAlign.center,
            ),
            leading: IconButton(
              iconSize: 16,
              icon: _obtainFavoriteIcon(),
              onPressed: () => context.read<FavoritesProvider>().toggle(product),
            ),
            trailing: IconButton(
              iconSize: 16,
              onPressed: () => _addProductToCart(context),
              icon: Icon(Icons.shopping_cart),
            ),
          ),
        ),
      ),
      onTap: () => _navigateToDetails(context),
    );
  }

  void _addProductToCart(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final parentScaffold = Scaffold.of(context);

    cartProvider.addProduct(product);

    parentScaffold.hideCurrentSnackBar();
    parentScaffold.showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            '${product.title} has been added to cart!',
            style: TextStyle(fontSize: 24),
          ),
        ),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () => cartProvider.removeProduct(product),
        ),
      ),
    );
  }

  Widget _obtainFavoriteIcon() {
    return Consumer<FavoritesProvider>(
      builder: (ctx, provider, child) => Icon(provider.isFavorite(product) ? Icons.favorite : Icons.favorite_border),
    );
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.of(context).pushNamed(ProductDetailScreen.route, arguments: product);
  }
}
