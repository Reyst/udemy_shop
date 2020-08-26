import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductGridItem extends StatelessWidget {
  final Product product;
  final bool isFavorite;
  final void Function(Product) onItemTap;
  final void Function(Product) onFavoriteTap;
  final void Function(Product) onCartTap;

  const ProductGridItem({
    Key key,
    @required this.product,
    this.isFavorite = false,
    this.onItemTap,
    this.onFavoriteTap,
    this.onCartTap,
  }) : super(key: key);

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
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () => onFavoriteTap(product),//() => context.read<FavoritesProvider>().toggle(product),
            ),
            trailing: IconButton(
              iconSize: 16,
              onPressed: () => onCartTap(product), //() => _addProductToCart(context),
              icon: Icon(Icons.shopping_cart),
            ),
          ),
        ),
      ),
      onTap: () => onItemTap(product),
    );
  }
}
