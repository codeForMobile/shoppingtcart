import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
/*   final String id;
  final String title;
  final String imageUrl;

  ProductItem(this.id, this.title, this.imageUrl); */
  @override
  Widget build(BuildContext context) {
    final singleProduct = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: singleProduct.id);
          },
          child: Image.network(
            singleProduct.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(singleProduct.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                singleProduct.toggleFavorite(auth.token);
              },
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.addItem(singleProduct.id, singleProduct.price, singleProduct.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added item to cart',),
                duration: Duration(seconds: 2),
                action: SnackBarAction(label: 'UNDO', onPressed: () {
                  cart.removeSingleItem(singleProduct.id);
                },),
                )
              );
            },
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
