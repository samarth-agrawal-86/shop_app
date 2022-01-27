// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_page.dart';
import 'package:shop_app/widgets/app_drawer.dart';

class UserProductsPage extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductsPage({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(userProducts: true);
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<Products>(context, listen: false);
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
      body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: Consumer<Products>(
                builder: (context, productsData, _) {
                  return ListView.builder(
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
                                  onPressed: () async {
                                    try {
                                      await productsData.deleteProduct(prod.id);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Item deleted',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    } catch (onError) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Item could not be deleted',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  icon: Icon(Icons.delete,
                                      color: Colors.red.shade600),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                        ],
                      );
                    },
                  );
                },
              ),
            );
          }),
    );
  }
}
