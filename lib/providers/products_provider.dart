import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import './product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

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

  // to initialize data at the begining of the app
  Future<void> fetchAndSetData([bool creatorOnly = false]) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    /// initialize firebase realtime database instance
    final database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);

    final Map<String, Product> loadedProducts = {};

    // initialize a stream of products that will update whenever there is an
    // update in the database
    final ref = database.ref('products');
    ref.onValue.listen((event) {
      final values = event.snapshot.value as Map?;
      if (values != null) {
        final loadedProductKeys = loadedProducts.keys.toList();

        // delete no longer existing products from the local list
        loadedProductKeys.map((key) {
          if (!values.containsKey(key)) {
            loadedProducts.remove(key);
          }
        });

        values.forEach(
          (key, value) {
            loadedProducts[key] = Product(
              id: key,
              title: values[key]['title'],
              description: values[key]['description'],
              price: values[key]['price'].toDouble(),
              imageUrl: values[key]['imageUrl'],
            );
          },
        );
      }

      // set the items list to the extracted list of products
      _items = loadedProducts.values.toList();

      notifyListeners();
    });

    // create a stream of favorite items
    final userFavoriteRef = database.ref('userFavorites/$uid/');
    userFavoriteRef.onValue.listen((event) {
      final favoriteValues = event.snapshot.value as Map?;
      if (favoriteValues != null) {
        favoriteValues.forEach((favoriteKey, favoriteValue) {
          // update favorite state if the item is in the loaded products
          if (loadedProducts.keys.contains(favoriteKey)) {
            loadedProducts[favoriteKey]!.isFavorite = favoriteValue;
          }
        });
      }
      // set the items list to the extracted list of products
      _items = loadedProducts.values.toList();

      notifyListeners();
    });
  }

  Future<void> addItem(Product product) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // create an instance of the firebase database
    final database = FirebaseDatabase.instance;
    await database.ref('products/').push().set({
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'creatorId': uid,
    });

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
