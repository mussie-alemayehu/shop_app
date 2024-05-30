import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

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
