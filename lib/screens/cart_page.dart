// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';

  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //? Cart Contaier
    final cartData = Provider.of<Cart>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Total', style: Theme.of(context).textTheme.headline6),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartData.totalAmount}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                      onPressed: () {
                        Provider.of<Orders>(context, listen: false).addOrder(
                          cartData.totalAmount,
                          cartData.cartItems.values.toList(),
                        );
                        cartData.cartClear();
                      },
                      child: Text('ORDER NOW'))
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cartData.cartItemsCount,
                itemBuilder: (context, index) {
                  //print(cartData.cartItems);
                  // cartItems is a dictionary
                  // {p2: Instance of 'CartItem', p1: Instance of 'CartItem'}

                  //print(cartData.cartItems.values);
                  // .values convert to Iterables
                  // (Instance of 'CartItem', Instance of 'CartItem')

                  //print(cartData.cartItems.values.toList());
                  // We are converting into a list
                  // [Instance of 'CartItem', Instance of 'CartItem']

                  //print(cartData.cartItems.values.toList()[index]);
                  // Instance of 'CartItem'
                  //print(cartData.cartItems.values.toList()[index].id);
                  // Red Shirt
                  //print(cartData.cartItems.keys.toList()[index]);

                  final cartItem = cartData.cartItems.values.toList()[index];
                  return Dismissible(
                    key: ValueKey(cartItem.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      color: Theme.of(context).errorColor,
                      child: Icon(
                        Icons.delete,
                        size: 40,
                        color: Colors.white,
                      ),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                    ),
                    confirmDismiss: (direction) {
                      return showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: Text('Are you Sure!'),
                            content: Text('Do you want to delete?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop(false);
                                },
                                child: Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop(true);
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.red.shade400,
                                  primary: Colors.white,
                                ),
                                child: Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (direction) {
                      cartData.removeProduct(
                          cartData.cartItems.keys.toList()[index]);
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      elevation: 6,
                      child: ListTile(
                        leading: CircleAvatar(
                          child: FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('\$${cartItem.price}'),
                            ),
                          ),
                        ),
                        title: Text(cartItem.title),
                        subtitle: Text(
                            'Total : \$${cartItem.price * cartItem.quantity}'),
                        trailing: Text('${cartItem.quantity} x'),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
