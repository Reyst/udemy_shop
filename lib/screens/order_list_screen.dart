import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import '../data/orders_provider.dart';

class OrderListScreen extends StatelessWidget {

  static const String route = "/orders";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: Consumer<OrdersProvider>(
        builder: (consumerContext, provider, child) => ListView.builder(
          itemCount: provider.orders.length,
          itemBuilder: (ctx, index) => OrderItem(provider.orders[index]),
        ),
      ),
    );
  }
}
