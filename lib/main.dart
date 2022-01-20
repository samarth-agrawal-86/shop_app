import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_page.dart';

import './screens/users_product_page.dart';
import './screens/orders_page.dart';
import './screens/cart_page.dart';
import './screens/product_details_page.dart';
import './screens/products_overview_page.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // register a provider in our app.
    // i. import provider package provider.dart
    // ii. Wrap MaterialApp in a provider. There are bunch of providers available
    // iii. Provider we chose provides one and only instance of the Provided class to all the child
    // when we make some changes to the object of this class (and call Notify Listeners) ..
    // * All the widgets that are listening to this will re-build
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Products()),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProvider(create: (context) => Orders()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        //home: ProductOverviewPage(),
        initialRoute: '/',
        routes: {
          '/': (ctx) => ProductOverviewPage(),
          ProductDetailsPage.routeName: (ctx) => ProductDetailsPage(),
          CartPage.routeName: (ctx) => CartPage(),
          OrdersPage.routeName: (ctx) => OrdersPage(),
          UserProductsPage.routeName: (ctx) => UserProductsPage(),
          EditProductPage.routeName: (ctx) => EditProductPage(),
        },
      ),
    );
  }
}
