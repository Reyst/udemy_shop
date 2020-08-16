import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItem._internal({
    @required this.id,
    @required this.productId,
    @required this.title,
    @required this.price,
    @required this.quantity,
  }) : assert(quantity > 0);

  factory CartItem.newItem(String productId, String title, double price, {int quantity = 1}) {
    return CartItem._internal(
      id: Uuid().v4().toString(),
      productId: productId,
      title: title,
      price: price,
      quantity: quantity,
    );
  }

  double get entryTotal => price * quantity;

  CartItem copyWithQuantity(int newQuantity) {
    assert(newQuantity > 0);
    return CartItem._internal(
      id: id,
      productId: productId,
      title: title,
      price: price,
      quantity: newQuantity,
    );
  }
}
