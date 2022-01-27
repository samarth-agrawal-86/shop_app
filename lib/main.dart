// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';

import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/users_product_page.dart';
import './screens/orders_page.dart';
import './screens/cart_page.dart';
import './screens/product_details_page.dart';
import './screens/products_overview_page.dart';
import 'screens/auth_page.dart';
import './screens/edit_product_page.dart';

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
        ChangeNotifierProvider(create: (context) => Auth()),
        // 1st argument is type of data you depend upon
        // 2nd is the data you are providing. here in case products
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products('', '', []),
          update: (context, auth, previousProducts) {
            return Products(
              auth.getToken.toString(),
              auth.getUserId.toString(),
              previousProducts == null ? [] : previousProducts.allItems,
            );
          },
        ),
        //ChangeNotifierProvider(create: (context) => Products()),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
            create: (context) => Orders('', ''),
            update: (context, auth, previousOrders) {
              return Orders(
                auth.getToken.toString(),
                auth.getUserId.toString(),
              );
            }),
        //ChangeNotifierProvider(create: (context) => Orders()),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth
                ? ProductOverviewPage()
                : FutureBuilder(
                    future: auth.userAutoLogin(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      // This is redundant. as data in userAutoLogin changes. this method will re build
                      // once it rebuilds auth.isAuth check will get ful filled
                      // if (snapshot.data == true) {
                      //   return ProductOverviewPage();
                      // }
                      return AuthScreen();
                    }),

            //initialRoute: '/',
            routes: {
              //'/': (ctx) => AuthScreen(),
              ProductOverviewPage.routeName: (ctx) => ProductOverviewPage(),
              ProductDetailsPage.routeName: (ctx) => ProductDetailsPage(),
              CartPage.routeName: (ctx) => CartPage(),
              OrdersPage.routeName: (ctx) => OrdersPage(),
              UserProductsPage.routeName: (ctx) => UserProductsPage(),
              EditProductPage.routeName: (ctx) => EditProductPage(),
            },
          );
        },
      ),
    );
  }
}
