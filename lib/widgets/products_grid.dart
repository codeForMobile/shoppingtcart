import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool _showFav;

  ProductsGrid(this._showFav);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = _showFav ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(
/*             products[index].id,
            products[index].title,
            products[index].imageUrl, */
          ),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
      );
  }
}