import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/product.dart';
import '../providers/auth.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context, listen: false);
    final product = Provider.of<Product>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            ProductDetailsScreen.routeName,
            arguments: product.id,
          );
        },
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                icon: Icon(
                  product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border_outlined,
                ),
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () => product
                    .toggleFavorite(
                  authData.token,
                  authData.userId,
                )
                    .catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Unable to complete.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }),
              ),
            ),
            title: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                product.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    // fontFamily: 'Lato',
                    ),
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.shopping_cart),
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () {
                cartData.addItem(
                  itemId: product.id,
                  itemPrice: product.price,
                  itemTitle: product.title,
                );
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Item added to Cart!'),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cartData.removeSingleItem(product.id);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder:
                  const AssetImage('lib/images/icons8-new-product-96.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
