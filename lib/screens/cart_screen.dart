import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/cart_provider.dart';
import '../data/orders_provider.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/cart_summary.dart';

class CartScreen extends StatefulWidget {
  static const String route = "/cart";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your cart")),
      body: Column(
        children: [
          Consumer<CartProvider>(
            builder: (ctx, provider, child) {
              return CartSummary(
                total: provider.total,
                onCreateOrderAction: () => _createOrder(),
                inProgress: _inProgress,
              );
            },
          ),
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

  void _createOrder() {
    setState(() => _inProgress = true);
    final cartProvider = context.read<CartProvider>();

    context.read<OrdersProvider>().createOrder(cartProvider.items).then((_) {
      cartProvider.clear();
      setState(() => _inProgress = false);
    }).catchError((e) => setState(() => _inProgress = false));
  }
}
