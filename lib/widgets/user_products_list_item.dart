import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../screens/edit_products_screen.dart';

class UserProductsListItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductsListItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.black12,
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(title),
          trailing: Container(
            width: 100,
            child: Row(children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductsScreen.routeName, arguments: id);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.error,
                ),
                onPressed: () async {
                  try {
                    await Provider.of<ProductsProvider>(context, listen: false)
                        .deleteItem(id);
                  } catch (error) {
                    scaffoldMessenger.hideCurrentSnackBar();
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text(
                          'Deleting failed.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
              ),
            ]),
          ),
        ),
        const Divider(),
      ]),
    );
  }
}
