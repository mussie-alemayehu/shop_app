import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './drawer_screen.dart';
import '../widgets/orders_list_item.dart';
import '../providers/order_provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
        backgroundColor: const Color(0xFFF9F9F9),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=56'),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future:
              Provider.of<Order>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              );
            } else if (dataSnapshot.error != null) {
              return const Center(
                child: Text('An error occured.'),
              );
            } else {
              return Consumer<Order>(
                builder: (ctx, orderData, _) {
                  return (orderData.orders.isEmpty)
                      ? Center(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.15),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'There are no orders at the moment. You will find your orders here once you have added some.',
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: orderData.orders.length,
                          itemBuilder: (_, index) =>
                              OrdersListItem(orderData.orders[index]),
                        );
                },
              );
            }
          }),
      drawer: AppDrawer(context),
    );
  }
}
