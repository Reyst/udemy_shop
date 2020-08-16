import 'package:flutter/material.dart';

import 'screens/product_detail_screen.dart';
import 'screens/product_list_screen.dart';

Map<String, WidgetBuilder> routes = <String, WidgetBuilder> {
  ProductListScreen.route: (ctx) => ProductListScreen(),
  ProductDetailScreen.route: (ctx) => ProductDetailScreen.forNavigation(ctx),
};