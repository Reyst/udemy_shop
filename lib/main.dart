import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/cart_provider.dart';
// import 'data/favorites_provider.dart';
import 'data/orders_provider.dart';
import 'data/products_provider.dart';
import 'shop_app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        // ChangeNotifierProvider(create: (context) => FavoritesProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => OrdersProvider()),
      ],
      child: ShopApp(),
    ),
  );
}
