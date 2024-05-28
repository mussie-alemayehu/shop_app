import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../providers/products_provider.dart';
import '../providers/product.dart';
import './product_item.dart';

class ProductGrid extends StatelessWidget {
  // final bool favoriteOnly;
  final List<Product> products;

  const ProductGrid(this.products, {super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (ctx, index) => ProductItem(products[index]),
    );
  }
}
