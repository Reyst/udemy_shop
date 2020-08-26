import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/cart_provider.dart';
import '../data/favorites_provider.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String route = "/product/details";

  final Product product;

  const ProductDetailScreen({Key key, @required this.product})
      : assert(product != null),
        super(key: key);

  ProductDetailScreen.forNavigation(BuildContext context) : this(product: _obtainNavigationParameters(context));

  static Product _obtainNavigationParameters(BuildContext context) => ModalRoute.of(context).settings.arguments as Product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Stack(
                children: [
                  Image.network(
                    product.imageUrl,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                  Positioned(
                    right: 0,
                    top: 50,
                    child: Container(
                      width: 100,
                      color: Colors.black54,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Consumer<FavoritesProvider>(
                              builder: (ctx, provider, child) => FutureBuilder<bool>(
                                future: provider.isFavorite(product),
                                builder: (c, snapShot) => Icon(
                                  (snapShot.hasData && snapShot.data) ? Icons.favorite : Icons.favorite_border,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () => context.read<FavoritesProvider>().toggle(product),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                            ),
                            onPressed: () => context.read<CartProvider>().addProduct(product),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    ("\$${product.price}"),
                    style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.purple),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                product.description,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
