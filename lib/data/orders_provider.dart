import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as Http;

import '../global/constants.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class OrdersProvider with ChangeNotifier {
  Future<List<Order>> get orders async => _getOrders();

  Future<List<Order>> _getOrders() async {
    List<Order> result = [];
    final url = "${BASE_URL}orders.json";
    try {
      final response = await Http.get(url);

      if (response.statusCode >= 400) throw Exception('Something went wrong');
      if (response.body == null) return result;

      print(response.body);

      final Map<String, dynamic> decodedResponse = json.decode(response.body);
      if (decodedResponse == null) return result;

      decodedResponse.forEach((orderId, orderData) {
        result.add(
          Order.full(
            id: orderId,
            orderDate: DateTime.parse(orderData['date']),
            amount: orderData['amount'],
            items: (orderData['items'] as List<dynamic>)
                .map((item) => CartItem(
                      id: item['id'],
                      productId: item['productId'],
                      title: item['title'],
                      price: item['price'],
                      quantity: item['quantity'],
                    ))
                .toList(),
          ),
        );
      });
    } catch (error) {
//      throw error;
      return result;
    }

    result.sort((a, b) => -a.orderDate.compareTo(b.orderDate));
    return result;
  }

  Future<void> createOrder(List<CartItem> items) async {
    final order = Order(items);
    final url = "${BASE_URL}orders/${order.id}.json";

    try {
      await Http.patch(
        url,
        body: json.encode({
          'date': order.orderDate.toIso8601String(),
          'amount': order.amount,
          'items': order.items.map(_cartItemToMap).toList(),
        }),
      );

      notifyListeners();
    } catch (error) {
//      return [];
      throw error;
    }
  }

  Map<String, dynamic> _cartItemToMap(CartItem rec) {
    return {
      'id': rec.id,
      'productId': rec.productId,
      'title': rec.title,
      'price': rec.price,
      'quantity': rec.quantity,
    };
  }
}
