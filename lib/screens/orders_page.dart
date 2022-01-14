// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';

class OrdersPage extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersPage({Key? key}) : super(key: key);

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
              child: ListTile(
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
                  onPressed: () {},
                  icon: Icon(Icons.expand_more),
                ),
              ),
            );
          }),
    );
  }
}
