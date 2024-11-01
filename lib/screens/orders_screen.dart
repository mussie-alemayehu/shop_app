import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './drawer_screen.dart';
import '../widgets/orders_list_item.dart';
import '../providers/order_provider.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    // we want to check if we are on the first build of this screen before we
    // initialize our items because we won't need to do that if we have already
    // initialized them
    if (_isInit) {
      setState(() => _isLoading = true);
      Provider.of<Order>(context, listen: false).fetchAndSetOrders().then((_) {
        setState(() => _isLoading = false);
      }).catchError((error) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occured.'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok')),
            ],
          ),
        ).then(
          (_) => setState(
            () => _isLoading = false,
          ),
        );
      });
      _isInit = false;
      super.didChangeDependencies();
    }
  }

  Widget _getBody() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
        ),
      );
    } else {
      return Consumer<Order>(
        builder: (ctx, orderData, _) {
          return (orderData.orders.isEmpty)
              ? Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.15),
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
  }

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
      body: _getBody(),
      drawer: AppDrawer(context),
    );
  }
}
