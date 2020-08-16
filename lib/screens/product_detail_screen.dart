import 'package:flutter/material.dart';
import 'package:udemy_shop/models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String route = "/product/details";

  final Product product;

  const ProductDetailScreen({Key key, @required this.product})
      : assert(product != null),
        super(key: key);

  ProductDetailScreen.forNavigation(BuildContext context) : this(product: _obtainNavigationParameters(context));

  static Product _obtainNavigationParameters(BuildContext context) =>
      ModalRoute.of(context).settings.arguments as Product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Center(
        child: Text("Details of ${product.title}"),
      ),
    );
  }
}
