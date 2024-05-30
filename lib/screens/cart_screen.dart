import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/cart_item.dart';
import '../providers/order_provider.dart';
import '../providers/cart_provider.dart' hide CartItem;

class CartScreen extends StatefulWidget {
  static const routeName = '/Cart';

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    final cartList = cartData.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: const Color(0xFFF9F9F9),
      ),
      body: Column(children: [
        Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 18),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    child: Chip(
                      label: Text('\$${cartData.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .titleLarge
                                  ?.color)),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: cartList.isEmpty
                        ? null
                        : () async {
                            if (cartList.isNotEmpty) {
                              setState(() {
                                _isLoading = true;
                              });
                              try {
                                await Provider.of<Order>(context, listen: false)
                                    .addOrder(
                                  OrderItem(
                                    cartProducts: cartList,
                                    total: cartData.totalPrice,
                                    dateTime: DateTime.now(),
                                  ),
                                );
                                cartData.clearCart();
                                setState(() {
                                  _isLoading = false;
                                });
                              } catch (error) {
                                if (context.mounted) {
                                  await showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title:
                                          const Text('Adding orders failed.'),
                                      content:
                                          const Text('Please try again later.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Ok',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
                            }
                          },
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(Colors.grey),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          )
                        : Text(
                            'ORDER NOW',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                  ),
                ]),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (_, index) => CartItem(
              cartList[index].id,
              cartList[index].title,
              cartList[index].price,
              cartList[index].price * cartList[index].quantity,
              cartList[index].quantity,
            ),
            itemCount: cartData.itemCount,
          ),
        ),
      ]),
    );
  }
}
