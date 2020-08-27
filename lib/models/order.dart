import 'package:uuid/uuid.dart';

import 'cart_item.dart';

class Order {
  final String id;
  final DateTime orderDate;
  final double amount;
  final List<CartItem> items;

  Order.full({
    this.id,
    this.orderDate,
    this.amount,
    this.items,
  });

  Order(List<CartItem> items)
      : this.full(
          id: Uuid().v4().toUpperCase().toString(),
          orderDate: DateTime.now(),
          amount: items.fold(0.0, (previousValue, record) => previousValue + record.price * record.quantity),
          items: items,
        );
}
