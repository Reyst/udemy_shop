import 'package:flutter/material.dart';

import '../screens/order_list_screen.dart';
import '../screens/product_list_screen.dart';
import '../screens/products_management_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 4,
      child: Column(
        children: [
          AppBar(
            title: Text("Shop app"),
            automaticallyImplyLeading: false,
          ),
          _buildDrawerOption(context, Icons.shop_two, "Products", () => _switchTo(context, ProductListScreen.route)),
          _buildDrawerOption(context, Icons.payment, "Orders", () => _switchTo(context, OrderListScreen.route)),
          _buildDrawerOption(context, Icons.assessment, "Product management", () => _switchTo(context, ProductsManagementScreen.route)),
        ],
      ),
    );
  }

  _buildDrawerOption(BuildContext context, IconData icon, String title, Function action) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(title, style: TextStyle(fontSize: 24)),
      onTap: action,
    );
  }

  void _switchTo(BuildContext context, String route) {
    Navigator.of(context).pushReplacementNamed(route);
  }

}
