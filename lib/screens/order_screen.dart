import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

// Approach 1
/* class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchOrders();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: ordersData.orders.length,
              itemBuilder: (ctx, i) => OrderItem(ordersData.orders[i]),
            ),
    );
  }
} */

// Approach 2

/* class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: Provider.of<Orders>(context, listen: false).fetchOrders(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (dataSnapshot.error != null) {
                  return Center(
                    child: Text('An error occurred'),
                  );
                } else {
                  return Consumer<Orders>(
                      builder: (ctx, orderData, _) => ListView.builder(
                            itemCount: orderData.orders.length,
                            itemBuilder: (ctx, i) =>
                                OrderItem(orderData.orders[i]),
                          ));
                }
              }
            }));
  }
} */

// Approach 3

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future _orderState;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchOrders();
  }

  @override
  void initState() {
    _orderState = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: _orderState,
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (dataSnapshot.error != null) {
                  return Center(
                    child: Text('An error occurred'),
                  );
                } else {
                  return Consumer<Orders>(
                      builder: (ctx, orderData, _) => ListView.builder(
                            itemCount: orderData.orders.length,
                            itemBuilder: (ctx, i) =>
                                OrderItem(orderData.orders[i]),
                          ));
                }
              }
            }));
  }
}
