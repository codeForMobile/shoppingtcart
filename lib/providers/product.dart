import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _updateFav (bool fav) {
    isFavorite = fav;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.https(
        'shoppintcart-d830a-default-rtdb.firebaseio.com', '/products/$id.json', {'auth':token});
    try {
     final response = await http.patch(url, body: json.encode({
        'isFavorite': isFavorite
      }),
      );
      if (response.statusCode >=400) {
        _updateFav(oldStatus);
      }
    } catch (_) {
      _updateFav(oldStatus);
    }
  }
}
