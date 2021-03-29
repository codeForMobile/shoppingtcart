import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

import '../widgets/badge.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    // Following works but still not being used to align with author.
    //Provider.of<Products>(context, listen: false).fetchProducts();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context, listen: false)
          .fetchProducts()
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MyShop'), actions: <Widget>[
        PopupMenuButton(
          onSelected: (FilterOptions selectedValue) {
            setState(() {
              if (FilterOptions.Favorites == selectedValue) {
                _showOnlyFavorites = true;
              } else if (selectedValue == FilterOptions.All) {
                _showOnlyFavorites = false;
              }
            });
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              child: Text('Only favorites'),
              value: FilterOptions.Favorites,
            ),
            PopupMenuItem(
              child: Text('Show all'),
              value: FilterOptions.All,
            ),
          ],
          icon: Icon(Icons.more_vert),
        ),
        Consumer<Cart>(
          builder: (_, cart, ch) => Badge(
            value: cart.itemCount.toString(),
            child: ch,
          ),
          child: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
        )
      ]),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
