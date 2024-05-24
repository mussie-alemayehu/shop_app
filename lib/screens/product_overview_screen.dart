import 'package:flutter/material.dart' hide Badge;
import 'package:provider/provider.dart';

import '../screens/drawer_screen.dart';
import '../screens/cart_screen.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_grid.dart';
import '../widgets/badge.dart';

enum FilterOptions {
  favorite,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _favoriteOnly = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    // we want to check if we are on the first build of this screen before we
    // initialize our items because we won't need to do that if we have already
    // initialized them
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context, listen: false)
          .fetchAndSetData()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
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
            () {
              _isLoading = false;
            },
          ),
        );
      });
      _isInit = false;
      super.didChangeDependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          PopupMenuButton(
            itemBuilder: (_) {
              return [
                // this item will display favorite items only
                PopupMenuItem(
                  onTap: () {
                    setState(() {
                      _favoriteOnly = true;
                    });
                  },
                  value: FilterOptions.favorite,
                  child: const Text('Show Favorite Only'),
                ),
                // this item will the setting to all items
                PopupMenuItem(
                  onTap: () {
                    setState(() {
                      _favoriteOnly = false;
                    });
                  },
                  value: FilterOptions.all,
                  child: const Text('Show All'),
                ),
              ];
            },
          ),
          // this icon will take the user to the cart screen
          // also, it will display how many items there are in the cart with a badge
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              itemCount: cart.itemCount,
              child: ch!,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : ProductGrid(
              _favoriteOnly
                  ? products.where((product) => product.isFavorite).toList()
                  : products,
            ),
      drawer: const AppDrawer(),
    );
  }
}
