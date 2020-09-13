import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/auth_provider.dart';
import 'data/cart_provider.dart';
import 'data/orders_provider.dart';
import 'data/products_provider.dart';
import 'shop_app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
            update: (context, authProvider, oldProvider) => oldProvider..token = authProvider.token,
            create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          update: (context, authProvider, oldProvider) => oldProvider..token = authProvider.token,
          create: (context) => OrdersProvider(),
        ),
      ],
      child: ShopApp(),
    ),
  );
}
