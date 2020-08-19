
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/cart_provider.dart';

class CartSummary extends StatelessWidget {

  const CartSummary({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Chip(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              label: Consumer<CartProvider>(
                builder: (ctx, value, child) {
                  return Text(
                    "\$${value.total.toStringAsFixed(2)}",
                    style: Theme.of(ctx).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                },
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            FlatButton(
              child: Text(
                "Create Order".toUpperCase(),
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
