import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order.dart';

class OrderItem extends StatefulWidget {
  final Order order;

  OrderItem(this.order) : super(key: ValueKey(order.id));

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(DateFormat('dd.MM.yyyy HH:mm').format(widget.order.orderDate)),
                  Spacer(),
                  Text("\$" + widget.order.amount.toStringAsFixed(2)),
                  IconButton(
                    icon: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.black87,
                    ),
                    onPressed: () => setState(() => _isExpanded = !_isExpanded),
                  ),
                ],
              ),
              if (_isExpanded) Column(children: [..._buildOrderRows()])
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOrderRows() {
    return widget.order.items
        .map(
          (item) => Column(
            children: [
              Divider(),
              ListTile(
                leading: SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        "\$${item.price}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                title: Text(item.title),
                subtitle: Text('sum: \$${item.price * item.quantity}'),
                trailing: Text('x ${item.quantity}'),
              ),
            ],
          ),
        )
        .toList(growable: false);
  }
}
