import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import './cart_provider.dart';

class OrderItem {
  String id;
  final double total;
  final List<CartItem> cartProducts;
  final DateTime dateTime;

  OrderItem({
    this.id = '',
    required this.total,
    required this.cartProducts,
    required this.dateTime,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  // create an instance of the firebase realtime database
  final database = FirebaseDatabase.instance;

  List<OrderItem> get orders {
    return [..._orders];
  }

  List<CartItem> convertToListOfCartItem(List<dynamic> list) {
    return list
        .map(
          (item) => CartItem(
            id: item['id'],
            title: item['title'],
            price: item['price'],
            quantity: item['quantity'],
          ),
        )
        .toList();
  }

  // to initialize the orders of the current user when the app starts
  Future<void> fetchAndSetOrders() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // initialize a listener that will be updated whenever there is an update
    // in the database about orders
    database.ref('orders/$uid').onValue.listen(
      (event) {
        final List<OrderItem> extractedOrders = [];
        final data = (event.snapshot.value as Map);
        data.forEach(
          (key, value) {
            extractedOrders.add(
              OrderItem(
                id: key,
                total: value['totalAmount'],
                cartProducts: convertToListOfCartItem(value['cartProducts']),
                dateTime: DateTime.parse(value['dateTime']),
              ),
            );
          },
        );

        _orders = extractedOrders;
        notifyListeners();
      },
    );
  }

  Future<void> addOrder(OrderItem cart) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // extract the cart products as a map
    final cartProducts = cart.cartProducts
        .map<Map<String, dynamic>>(
          (cartProduct) => {
            'id': cartProduct.id,
            'title': cartProduct.title,
            'price': cartProduct.price,
            'quantity': cartProduct.quantity,
          },
        )
        .toList();

    // store the cart data on the database
    await database.ref('orders/$uid').push().set({
      'cartProducts': cartProducts,
      'totalAmount': cart.total,
      'dateTime': cart.dateTime.toIso8601String(),
    });
  }
}
