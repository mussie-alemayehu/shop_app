import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
    return MasonryGridView.count(
      crossAxisCount: 2,
      itemCount: products.length,
      itemBuilder: (ctx, index) => ProductItem(products[index]),
    );
  }
}
