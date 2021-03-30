import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime orderTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.orderTime,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url = Uri.https(
        'shoppintcart-d830a-default-rtdb.firebaseio.com', '/orders.json');
    final response = await http.get(url);
    print(json.decode(response.body));
    final List<OrderItem> loadedProducts = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((OrderId, OrderData) {
      loadedProducts.add(OrderItem(
        id: OrderId,
        amount: OrderData['amount'],
        orderTime: DateTime.parse(OrderData['orderTime']),
        products: (OrderData['products'] as List<dynamic>)
            .map((item) => CartItem(
                id: item['id'],
                title: item['title'],
                quantity: item['quantity'],
                price: item['price']))
            .toList(),
      ));
    });
    _orders = loadedProducts.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.https(
        'shoppintcart-d830a-default-rtdb.firebaseio.com', '/orders.json');
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'orderTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price
                  })
              .toList()
        }));
    _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          orderTime: timestamp,
          amount: total,
          products: cartProducts,
        ));
    notifyListeners();
  }
}
