import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/product.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context, listen: false);

    // previousProductItem = ClipRRect(
    //   borderRadius: BorderRadius.circular(10),
    //   child: GestureDetector(
    //     child: GridTile(
    //       footer: GridTileBar(
    //         backgroundColor: Colors.black87,
    //         leading: IconButton(
    //           icon: Icon(
    //             product.isFavorite
    //                 ? Icons.favorite
    //                 : Icons.favorite_border_outlined,
    //           ),
    //           color: Theme.of(context).colorScheme.secondary,
    //           onPressed: () async {
    //             await product.toggleFavorite();
    //           },
    //         ),
    //         trailing: IconButton(
    //           icon: const Icon(Icons.shopping_cart),
    //           color: Theme.of(context).colorScheme.secondary,
    //           onPressed: () {
    //             cartData.addItem(
    //               itemId: product.id,
    //               itemPrice: product.price,
    //               itemTitle: product.title,
    //             );
    //             ScaffoldMessenger.of(context).clearSnackBars();
    //             ScaffoldMessenger.of(context).showSnackBar(
    //               SnackBar(
    //                 content: const Text('Item added to Cart!'),
    //                 duration: const Duration(seconds: 2),
    //                 action: SnackBarAction(
    //                   label: 'UNDO',
    //                   onPressed: () {
    //                     cartData.removeSingleItem(product.id);
    //                   },
    //                 ),
    //               ),
    //             );
    //           },
    //         ),
    //       ),
    //       child: const Placeholder(),
    //     ),
    //   ),
    // );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey, width: 3),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                ProductDetailsScreen.routeName,
                arguments: product.id,
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Hero(
                tag: product.id,
                child: FadeInImage(
                  placeholder: const AssetImage('assets/placeholder.png'),
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          product.title,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text('\$ ${product.price}', textAlign: TextAlign.left),
      ],
    );
  }
}
