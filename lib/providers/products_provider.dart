import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import './product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];
  List<Product> _currentUserProducts = [];

  final database = FirebaseDatabase.instance;

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

  List<Product> get currentUserProducts {
    return [..._currentUserProducts];
  }

  // to find products by id
  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  // to initialize data at the begining of the app
  Future<void> fetchAndSetData([bool creatorOnly = false]) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    database.setPersistenceEnabled(true);

    final Map<String, Product> loadedProducts = {};
    final ref = database.ref('products');

    // initialize a listener that will fire whenever a child is removed from the
    // database
    ref.onChildRemoved.listen(
      (event) {
        final value = (event.snapshot.value as Map);

        // delete the product that was just deleted from the firebase database
        // from the local list
        loadedProducts.removeWhere((id, product) {
          final bool delete = product.creatorId == value['creatorId'] &&
              product.description == value['description'] &&
              product.title == value['title'] &&
              product.price == value['price'] &&
              product.imageUrl == value['imageUrl'];
          return delete;
        });

        // set the items list to the extracted list of products
        _items = loadedProducts.values.toList();

        // update the currentUserProducts when the products change
        _currentUserProducts = loadedProducts.values
            .where((value) => value.creatorId == uid)
            .toList();

        notifyListeners();
      },
    );

    // initialize a stream of products that will update whenever there is an
    // update in the database
    ref.onValue.listen(
      (event) {
        final values = event.snapshot.value as Map?;
        if (values != null) {
          // convert the obtained values to product items
          values.forEach(
            (key, value) {
              loadedProducts[key] = Product(
                id: key,
                creatorId: value['creatorId'],
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

        // update the currentUserProducts when the products change
        _currentUserProducts = loadedProducts.values
            .where((value) => value.creatorId == uid)
            .toList();

        notifyListeners();
      },
    );

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

  // to add items to the firebase database
  Future<void> addItem(Product product) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await database.ref('products/').push().set({
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'creatorId': uid,
    });
  }

  // to delete items from the firebase database
  Future<void> deleteItem(String productId) async {
    await database.ref('products/$productId/').remove();

    notifyListeners();
  }

  // to edit items from the database
  Future<void> editItem(String id, Product newProduct) async {
    await database.ref('products/$id/').update(
      {
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
      },
    );
  }
}
