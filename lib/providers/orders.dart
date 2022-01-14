import 'package:flutter/material.dart';

import 'package:shop_app/providers/cart.dart';

class OrderItem {
  // this id is not the product id, this is Order id which comes from timestamp
  final String id;
  final double orderAmount;
  final List<CartItem> products;
  final DateTime orderDate;

  OrderItem({
    required this.id,
    required this.orderAmount,
    required this.products,
    required this.orderDate,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get allOrders {
    return [..._orders];
  }

  void addOrder(double amount, List<CartItem> products) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toIso8601String(),
        orderAmount: amount,
        products: products,
        orderDate: DateTime.now(),
      ),
    );

    notifyListeners();
  }
}
