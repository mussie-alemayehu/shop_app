// import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';

import './product.dart';
// import '../models/http_exception.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  // final String token;
  // final String userId;

  // ProductsProvider(
  //   this.token,
  //   this.userId,
  //   this._items,
  // );

  var _isFavorite = false;

  void setFavorite() {
    _isFavorite = true;
    notifyListeners();
  }

  void removeFavorite() {
    _isFavorite = false;
    notifyListeners();
  }

  List<Product> get items {
    if (_isFavorite) {
      return _items.where((item) => item.isFavorite).toList();
    }
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetData([bool creatorOnly = false]) async {
    final database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);

    final dataSnapshot = await database.ref('procuts').get();
    print('dataSnapshot: $dataSnapshot');

    // try {
    //   var filterOption =
    //       creatorOnly ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    //   var url = Uri.parse(
    //     'https://flutter-app-d20fe-default-rtdb.firebaseio.com/products.json?auth=$token$filterOption',
    //   );

    //   List<Product> loadedProducts = [];
    //   final response = await http.get(url);
    //   final extractedData = jsonDecode(response.body) as Map<String, dynamic>?;
    //   if (extractedData == null) {
    //     return;
    //   }

    //   url = Uri.https(
    //     'flutter-app-d20fe-default-rtdb.firebaseio.com',
    //     '/userFavorites/$userId.json',
    //     {'auth': token},
    //   );
    //   final favoriteMealsResponse = await http.get(url);
    //   final favoriteMeals = json.decode(favoriteMealsResponse.body);

    //   extractedData.forEach((key, product) {
    //     loadedProducts.add(
    //       Product(
    //         id: key,
    //         title: product['title'],
    //         description: product['description'],
    //         price: product['price'],
    //         imageUrl: product['imageUrl'],
    //         isFavorite: favoriteMeals == null
    //             ? false
    //             : favoriteMeals[key] == null
    //                 ? false
    //                 : favoriteMeals[key] as bool,
    //       ),
    //     );
    //   });
    //   _items = loadedProducts;
    //   notifyListeners();
    // } catch (error) {
    //   rethrow;
    // }
  }

  Future<void> addItem(Product product) async {
    // var url = Uri.parse(
    //     'https://flutter-app-d20fe-default-rtdb.firebaseio.com/products.json?auth=$token');
    // try {
    //   final response = await http.post(url,
    //       body: json.encode({
    //         'title': product.title,
    //         'description': product.description,
    //         'price': product.price,
    //         'imageUrl': product.imageUrl,
    //         'creatorId': userId,
    //       }));
    //   final newProduct = Product(
    //     id: json.decode(response.body)['name'],
    //     title: product.title,
    //     description: product.description,
    //     price: product.price,
    //     imageUrl: product.imageUrl,
    //   );
    //   _items.add(newProduct);
    //   notifyListeners();
    // } catch (error) {
    //   rethrow;
    // }
  }

  Future<void> deleteItem(String productId) async {
    // var url = Uri.parse(
    //     'https://flutter-app-d20fe-default-rtdb.firebaseio.com/products.json?auth=$token');

    // final existingProductIndex =
    //     _items.indexWhere((product) => product.id == productId);
    // final existingProduct = _items[existingProductIndex];
    // _items.removeAt(existingProductIndex);
    // notifyListeners();
    // try {
    //   final response = await http.delete(url);
    //   if (response.statusCode >= 400) {
    //     throw HttpException('Deleting could not be performed.');
    //   }
    // } catch (error) {
    //   _items.insert(existingProductIndex, existingProduct);
    //   notifyListeners();
    //   rethrow;
    // }
    // notifyListeners();
  }

  Future<void> editItem(String id, Product newProduct) async {
    //   final indexEdited = _items.indexWhere((product) => product.id == id);
    //   var url = Uri.parse(
    //       'https://flutter-app-d20fe-default-rtdb.firebaseio.com/products.json?auth=$token');

    //   if (indexEdited >= 0) {
    //     try {
    //       await http.patch(
    //         url,
    //         body: json.encode({
    //           'title': newProduct.title,
    //           'description': newProduct.description,
    //           'price': newProduct.price,
    //           'imageUrl': newProduct.imageUrl,
    //         }),
    //       );
    //     } catch (error) {
    //       rethrow;
    //     }
    //     _items[indexEdited] = newProduct;
    //     notifyListeners();
    //   }
  }
}
