import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/orders_provider.dart';
import '../models/order.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

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
        builder: (consumerContext, provider, child) => FutureBuilder<List<Order>>(
            future: provider.orders,
            builder: (ctx, snap) {
              if (snap.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

              final orderList = snap.data ?? [];
              return ListView.builder(
                itemCount: orderList.length,
                itemBuilder: (ctx, index) => OrderItem(orderList[index]),
              );
            }),
      ),
    );
  }
}
