import 'package:flutter/material.dart';

class CartSummary extends StatelessWidget {
  final double total;
  final void Function() onCreateOrderAction;
  final bool inProgress;

  const CartSummary({Key key, this.total = 0, this.onCreateOrderAction, this.inProgress = false}) : super(key: key);

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
              label: Text(
                "\$${total.toStringAsFixed(2)}",
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            _getButton(context),
          ],
        ),
      ),
    );
  }

  Widget _getButton(BuildContext context) {
    return FlatButton(
      child: (inProgress)
          ? Center(child: CircularProgressIndicator())
          : Text(
              "Create Order".toUpperCase(),
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
      onPressed: (!inProgress && total > 0) ? onCreateOrderAction : null,
    );
  }
}
