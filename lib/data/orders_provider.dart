
import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class OrdersProvider with ChangeNotifier {

  List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  void createOrder(List<CartItem> items) {
    _orders.insert(0, Order(items));
    notifyListeners();
  }

}