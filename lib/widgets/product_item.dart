import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
/*   final String id;
  final String title;
  final String imageUrl;

  ProductItem(this.id, this.title, this.imageUrl); */
  @override
  Widget build(BuildContext context) {
    final singleProduct = Provider.of<Product>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,arguments: singleProduct.id);
          },
          child: Image.network(
            singleProduct.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(singleProduct.isFavorite ? Icons.favorite: Icons.favorite_border),
            color: Theme.of(context).accentColor,
            onPressed: () {
              singleProduct.toggleFavorite();
            },
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {},
          ),
          title: Text(
            singleProduct.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
