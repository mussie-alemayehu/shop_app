import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './edit_products_screen.dart';
import './drawer_screen.dart';
import '../widgets/user_products_list_item.dart';
import '../providers/products_provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user_products';

  const UserProductsScreen({super.key});

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).fetchAndSetData(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductsScreen.routeName);
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : Consumer<ProductsProvider>(
                    builder: (ctx, productsData, _) => RefreshIndicator(
                      onRefresh: () => _refreshProducts(context),
                      color: Theme.of(context).primaryColor,
                      child: ListView.builder(
                        itemCount: productsData.currentUserProducts.length,
                        itemBuilder: (_, index) => UserProductsListItem(
                          productsData.currentUserProducts[index].id,
                          productsData.currentUserProducts[index].title,
                          productsData.currentUserProducts[index].imageUrl,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
