import 'package:flutter/material.dart';

import 'screens/auth_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/order_list_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/product_list_screen.dart';
import 'screens/products_management_screen.dart';

Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  ProductListScreen.route: (ctx) => ProductListScreen(),
  AuthScreen.route: (ctx) => AuthScreen(),
  ProductDetailScreen.route: (ctx) => ProductDetailScreen.forNavigation(ctx),
  CartScreen.route: (ctx) => CartScreen(),
  OrderListScreen.route: (ctx) => OrderListScreen(),
  ProductsManagementScreen.route: (ctx) => ProductsManagementScreen(),
  EditProductScreen.route: (ctx) => EditProductScreen.forNavigation(ctx),
};
