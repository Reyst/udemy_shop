import 'package:flutter/material.dart';
import 'package:udemy_shop/screens/order_list_screen.dart';
import 'package:udemy_shop/screens/product_list_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 4,
      child: Column(
        children: [
          DrawerHeader(
            child: Text("Shop app"),
          ),
          _buildDrawerOption(context, Icons.apps, "Products", () => _switchTo(context, ProductListScreen.route)),
          _buildDrawerOption(context, Icons.description, "Orders", () => _switchTo(context, OrderListScreen.route))
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
