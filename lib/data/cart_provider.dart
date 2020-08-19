import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _cart = {};

  Map<String, CartItem> get cart => Map.from(_cart);

  int get productAmount => _cart.length;

  double get total => _cart.entries.fold(0.0, (value, entry) => value + entry.value.entryTotal);

  List<CartItem> get items => _cart.values.toList();

  void addProduct(Product product, {int quantity = 1}) {
    if (_cart.containsKey(product.id)) {
      _cart.update(
        product.id,
        (current) => current.copyWithQuantity(current.quantity + quantity),
      );
    } else {
      _cart.putIfAbsent(
        product.id,
        () => CartItem.newItem(
          product.id,
          product.title,
          product.price,
          quantity: quantity,
        ),
      );
    }

    notifyListeners();
  }

  void removeRecord(String productId) {
    if (_cart.containsKey(productId)) {
      _cart.remove(productId);
      notifyListeners();
    }
  }
}
