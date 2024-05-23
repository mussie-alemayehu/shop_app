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
    // final uid = FirebaseAuth.instance.currentUser!.uid;

    // database.ref('orders/$uid').onValue.listen(
    //       (event) {},
    //     );
    //   var url = Uri.parse(
    //       'https://flutter-app-d20fe-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');
    //   try {
    //     final response = await http.get(url);
    //     if (response.statusCode >= 400) {
    //       throw HttpException('Loading orders from server failed.');
    //     }
    //     final loadedOrders = jsonDecode(response.body) as Map<String, dynamic>?;
    //     if (loadedOrders == null) {
    //       _orders = [];
    //       return;
    //     }
    //     final List<OrderItem> extractedOrders = [];
    //     loadedOrders.forEach(
    //       (key, order) => extractedOrders.add(
    //         OrderItem(
    //           id: key,
    //           cartProducts: convertToListOfCartItem(order['cartProducts']),
    //           total: order['totalAmount'],
    //           dateTime: DateTime.parse(order['dateTime']),
    //         ),
    //       ),
    //     );
    //     _orders = extractedOrders;
    //     notifyListeners();
    //   } catch (error) {
    //     rethrow;
    //   }
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

    //   var url = Uri.parse(
    //       'https://flutter-app-d20fe-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');
    //   try {
    //     final response = await http.post(
    //       url,
    //       body: json.encode({
    //         'cartProducts': cart.cartProducts
    //             .map(
    //               (cartItem) => {
    //                 'id': cartItem.id,
    //                 'title': cartItem.title,
    //                 'price': cartItem.price,
    //                 'quantity': cartItem.quantity,
    //               },
    //             )
    //             .toList(),
    //         'totalAmount': cart.total,
    //         'dateTime': cart.dateTime.toIso8601String(),
    //       }),
    //     );
    //     cart.id = json.decode(response.body)['name'];
    //     _orders.insert(0, cart);
    //     notifyListeners();
    //   } catch (error) {
    //     rethrow;
    //   }
  }
}
