import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              icon: _obtainFavoriteIcon(context),
              onPressed: () => context.read<FavoritesProvider>().toggle(product),
            ),
            trailing: IconButton(
              iconSize: 16,
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
          ),
        ),
      ),
      onTap: () => _navigateToDetails(context),
    );
  }

  Widget _obtainFavoriteIcon(BuildContext context) {
//    return Consumer<FavoritesProvider>(
//      builder: (ctx, provider, child) => Icon(provider.isFavorite(product) ? Icons.favorite : Icons.favorite_border),
//    );

    final isFavorite = context.watch<FavoritesProvider>().isFavorite(product);
    return Icon(isFavorite ? Icons.favorite : Icons.favorite_border);
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.of(context).pushNamed(ProductDetailScreen.route, arguments: product);
  }
}
