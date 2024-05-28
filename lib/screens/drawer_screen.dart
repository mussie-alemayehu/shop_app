import 'package:flutter/material.dart';

import './user_products_screen.dart';
import './orders_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: const Text('Menu'),
          // automaticallyImplyLeading: false,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(
            color: Colors.grey,
            thickness: 0.5,
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
          leading: const Icon(Icons.shop),
          title: const Text('Products Overview'),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          },
          leading: const Icon(Icons.payment),
          title: const Text('Orders'),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routeName);
          },
          leading: const Icon(Icons.edit),
          title: const Text('My Products'),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pop();
            Auth.logout();
          },
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Logout'),
        ),
      ]),
    );
  }
}
