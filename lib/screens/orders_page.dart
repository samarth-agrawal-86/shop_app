// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';

class OrdersPage extends StatefulWidget {
  static const routeName = '/orders';
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  var _isExpanded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Orders>(context, listen: false).fetchAndSetOrder();
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context).allOrders;
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders Page'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
          itemCount: ordersData.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 6,
              margin: EdgeInsets.all(8),
              child: Column(
                children: [
                  ListTile(
                    isThreeLine: true,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order id: ${ordersData[index].id}'),
                        Text(
                            'Order Amount : \$${ordersData[index].orderAmount.toStringAsFixed(2)}'),
                      ],
                    ),
                    subtitle: Text(
                        'Placed on:${intl.DateFormat('dd/MM/yyyy h:mm a').format(ordersData[index].orderDate)}'),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      icon: Icon(
                          _isExpanded ? Icons.expand_less : Icons.expand_more),
                    ),
                  ),
                  if (_isExpanded)
                    Container(
                      height: min(ordersData.length * 30.0, 150),
                      child: ListView(
                          children: ordersData[index].products.map((cartItem) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                cartItem.title,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Text('${cartItem.quantity} x'),
                                  SizedBox(width: 6),
                                  Text('${cartItem.price}')
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList()),
                    )
                ],
              ),
            );
          }),
    );
  }
}
