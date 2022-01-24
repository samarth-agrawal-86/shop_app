import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../providers/cart.dart';

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

  Future<void> fetchAndSetOrder() async {
    final url = Uri.parse(
        'https://shop-app-526ea-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json');
    final List<OrderItem> loadedOrders = [];
    final response = await http.get(url);

    if (response.statusCode >= 400) {
      throw 'Error';
    }
    final responseData = jsonDecode(response.body) as Map<String, dynamic>;

    //{-Mu0a2yI_XNXrRkkljcD: {order_amount: 72.98, order_date: 2022-01-22T17:12:25.063605, products: [{id: 2022-01-22 17:12:21.897551, price: 12.99, quantity: 1, title: Red Shirt}, {id: 2022-01-22 17:12:22.637527, price: 59.99, quantity: 1, title: Trousers}]},
    //-Mu0cFNkR3tiHLapTHSu: {order_amount: 19.99, order_date: 2022-01-22T17:22:00.162762, products: [{id: 2022-01-22 17:21:58.207143, price: 19.99, quantity: 1, title: Yellow Scarf}]}}
    if (responseData != null) {
      //print(responseData.runtimeType);
      //_InternalLinkedHashMap<String, dynamic>
      responseData.forEach((orderId, orderData) {
        //print(orderData['products'].runtimeType);

        final List<dynamic> orderProducts = orderData['products'];
        final List<CartItem> loadedCarts = [];
        orderProducts.forEach((cartItem) {
          final ci = CartItem(
            id: cartItem['id'],
            title: cartItem['title'],
            price: cartItem['price'],
            quantity: cartItem['quantity'],
          );
          loadedCarts.add(ci);
        });

        loadedOrders.add(
          OrderItem(
            id: orderId,
            orderAmount: orderData['order_amount'],
            orderDate: DateTime.parse(orderData['order_date']),
            products: loadedCarts,
          ),
        );
      });

      //print(loadedOrders);
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    }
  }

  Future<void> addOrder(double amount, List<CartItem> products) async {
    final url = Uri.parse(
        'https://shop-app-526ea-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json');
    // creating this so that timestamp doesn't change when load in firebase vs in local env
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          'order_date': timestamp
              .toIso8601String(), // This is standard and easily recreateable later on
          'order_amount': amount,
          'products': products.map((prod) {
            return {
              'id': prod.id,
              'title': prod.title,
              'price': prod.price,
              'quantity': prod.quantity,
            };
          }).toList(),
        },
      ),
    );

    if (response.statusCode > 400) {
      throw 'Error';
    }

    _orders.insert(
      0,
      OrderItem(
        id: jsonDecode(response.body)['name'],
        orderAmount: amount,
        products: products,
        orderDate: timestamp,
      ),
    );

    notifyListeners();
  }
}
