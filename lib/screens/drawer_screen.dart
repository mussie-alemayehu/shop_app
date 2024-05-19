import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './user_products_screen.dart';
import './orders_screen.dart';
// import '../helpers/custom_route.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: const Text('Drawer'),
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
        ),
        const Divider(),
        ListTile(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
          leading: const Icon(Icons.shop),
          title: const Text('Products Overview'),
        ),
        const Divider(),
        ListTile(
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          },
          leading: const Icon(Icons.payment),
          title: const Text('Orders'),
        ),
        const Divider(),
        ListTile(
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routeName);
          },
          leading: const Icon(Icons.edit),
          title: const Text('My Products'),
        ),
        const Divider(),
        ListTile(
          onTap: () {
            Navigator.of(context).pop();
            Provider.of<Auth>(context, listen: false).logout();
          },
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Logout'),
        ),
        const Divider(),
      ]),
    );
  }
}
