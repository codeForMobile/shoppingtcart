import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {

  final String _token;

  Products(this._token, this._items);

  List<Product> _items = [
    /* Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ), */
  ];

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return items.firstWhere((element) => element.id == id);
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> fetchProducts() async {
    final url = Uri.https(
        'shoppintcart-d830a-default-rtdb.firebaseio.com', '/products.json', {'auth':_token});
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData == null) {
        return;
      }
      final List<Product> loadedProducts = [];
      extractedData.forEach((key, value) {
        loadedProducts.add(Product(
          id: key,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          imageUrl: value['imageUrl'],
          isFavorite: value['isFavorite'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.https(
        'shoppintcart-d830a-default-rtdb.firebaseio.com', '/products.json', {'auth':_token});
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
          }));

      final newProduct = Product(
        imageUrl: product.imageUrl,
        title: product.title,
        description: product.description,
        price: product.price,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      print(newProduct.id);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product updatedProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url = Uri.https('shoppintcart-d830a-default-rtdb.firebaseio.com',
          '/products/$id.json', {'auth':_token});
      await http.patch(url,
          body: json.encode({
            'title': updatedProduct.title,
            'description': updatedProduct.description,
            'price': updatedProduct.price,
            'imageUrl': updatedProduct.imageUrl
          }));
      _items[prodIndex] = updatedProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    // Exception can only be thrown by corrupting the 2nd part of Uri.https and not the first one i.e.
    // by doing this 
    // final url = Uri.https(shoppintcart-d830a-default-rtdb.firebaseio.com', '/products/$id');
    final url = Uri.https(
        'shoppintcart-d830a-default-rtdb.firebaseio.com', '/products/$id.json', {'auth':_token});
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }
}
