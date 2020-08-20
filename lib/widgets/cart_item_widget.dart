import 'package:flutter/material.dart';

import '../models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  final Function(String id) onDismiss;

  const CartItemWidget({Key key, @required this.item, this.onDismiss}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      confirmDismiss: (direction) => showDialog(context: context, builder: _createConfirmDialog),
      onDismissed: _onDismissed,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: FittedBox(
                child: Text("\$${item.price.toStringAsFixed(2)}"),
              ),
            ),
          ),
          title: Text(item.title),
          subtitle: Text("total: \$${item.entryTotal.toStringAsFixed(2)}"),
          trailing: Text("x ${item.quantity}"),
        ),
      ),
    );
  }

  AlertDialog _createConfirmDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Are you sure?',
        textAlign: TextAlign.center,
      ),
      content: Text('Do you really want to remove ${item.title} from the cart?'),
      insetPadding: const EdgeInsets.all(8),
      actions: [
        FlatButton(onPressed: () => Navigator.of(context).pop(false), child: Text('NO')),
        FlatButton(onPressed: () => Navigator.of(context).pop(true), child: Text('YES')),
      ],
    );
  }

  void _onDismissed(DismissDirection direction) {
    if (direction == DismissDirection.endToStart) {
      onDismiss?.call(item.productId);
    }
  }
}
