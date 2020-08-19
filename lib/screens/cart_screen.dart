import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/cart_item_widget.dart';
import '../data/cart_provider.dart';
import '../widgets/cart_summary.dart';

class CartScreen extends StatelessWidget {
  static const String route = "/cart";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your cart")),
      body: Column(
        children: [
          CartSummary(),
          Expanded(
            flex: 1,
            child: Consumer<CartProvider>(builder: (ctx, value, child) {
              final items = value.items;
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (ctx, index) => CartItemWidget(
                  item: items[index],
                  onDismiss: (productId) => value.removeRecord(productId),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
