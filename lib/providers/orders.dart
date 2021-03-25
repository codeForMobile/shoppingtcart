import 'package:flutter/cupertino.dart';

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

  void addOrder(List<CartItem> cartProducts, double total) {
    return _orders.insert(
        0,
        OrderItem(
          id: DateTime.now().toString(),
          orderTime: DateTime.now(),
          amount: total,
          products: cartProducts,
        ));
    notifyListeners();
  }
}
