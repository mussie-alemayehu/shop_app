import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
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
  final String token;
  final String userId;

  Order(this.token, this.userId, this._orders);

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

  Future<void> fetchAndSetOrders() async {
    var url = Uri.parse(
        'https://flutter-app-d20fe-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');
    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        throw HttpException('Loading orders from server failed.');
      }
      final loadedOrders = jsonDecode(response.body) as Map<String, dynamic>?;
      if (loadedOrders == null) {
        _orders = [];
        return;
      }
      final List<OrderItem> extractedOrders = [];
      loadedOrders.forEach(
        (key, order) => extractedOrders.add(
          OrderItem(
            id: key,
            cartProducts: convertToListOfCartItem(order['cartProducts']),
            total: order['totalAmount'],
            dateTime: DateTime.parse(order['dateTime']),
          ),
        ),
      );
      _orders = extractedOrders;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addOrder(OrderItem cart) async {
    var url = Uri.parse(
        'https://flutter-app-d20fe-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'cartProducts': cart.cartProducts
              .map(
                (cartItem) => {
                  'id': cartItem.id,
                  'title': cartItem.title,
                  'price': cartItem.price,
                  'quantity': cartItem.quantity,
                },
              )
              .toList(),
          'totalAmount': cart.total,
          'dateTime': cart.dateTime.toIso8601String(),
        }),
      );
      cart.id = json.decode(response.body)['name'];
      _orders.insert(0, cart);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
