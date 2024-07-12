import 'package:flutter/material.dart' hide Badge;
import 'package:provider/provider.dart';

import './cart_screen.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../widgets/badge.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product_details';

  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String productId =
        ModalRoute.of(context)!.settings.arguments as String;
    final product = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findById(productId);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFFF9F9F9),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.title),
              background: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            actions: [
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
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Text(
                  '\$${product.price}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  product.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                const SizedBox(height: 800),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
