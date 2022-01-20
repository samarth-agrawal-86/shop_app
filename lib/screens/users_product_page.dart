// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_page.dart';
import 'package:shop_app/widgets/app_drawer.dart';

class UserProductsPage extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductPage.routeName);
              },
              icon: Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: productsData.allItems.length,
        itemBuilder: (context, index) {
          var prod = productsData.allItems[index];
          return Column(
            children: [
              SizedBox(height: 4),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(prod.imageUrl),
                ),
                title: Text(prod.title),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        productsData.deleteProduct(prod.id);
                      },
                      icon: Icon(Icons.delete, color: Colors.red.shade600),
                    ),
                  ],
                ),
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}
