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
        title: const Text('Your Products'),
        backgroundColor: const Color(0xFFF9F9F9),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductsScreen.routeName);
            },
          ),
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=56'),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : Consumer<ProductsProvider>(
                builder: (ctx, productsData, _) => RefreshIndicator(
                  onRefresh: () => _refreshProducts(context),
                  color: Theme.of(context).primaryColor,
                  child: productsData.currentUserProducts.isEmpty
                      ? Center(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.15),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'You have not added any products at the moment. Tap the add button at the top to start adding some.',
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
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
