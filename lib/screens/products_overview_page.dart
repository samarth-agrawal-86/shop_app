// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_page.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { favorites, all }

class ProductOverviewPage extends StatefulWidget {
  static const routeName = '/products-overview';
  @override
  State<ProductOverviewPage> createState() => _ProductOverviewPageState();
}

class _ProductOverviewPageState extends State<ProductOverviewPage> {
  var _showFavoritesOnly = false;
  var _initFlag = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();

    //Provider.of<Products>(context).fetchAndSetProducts(); // WON'T WORK

    // Technically this also runs immediately.
    // .delayed is a helper constructor and we have put duration as zero
    // but technically this is registered as TO DO item by dart and it executes after initilization
    // hence .of(context) gets available
    // This all happens very fast but technically it is different from executing this line of code only
    //
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context, listen: false).fetchAndSetProducts();
    // });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initFlag) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context)
          .fetchAndSetProducts(userProducts: false)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _initFlag = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          Consumer<Cart>(
            builder: (context, cart, child) => Badge(
              child: child!,
              value: cart.cartItemsCount.toString(),
            ),
            // I'm defining this child here because only the text is changing not the Icon button widget
            // that icon widget i can define in the child and it will not rebuild when any changes in cart happens
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartPage.routeName);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorites) {
                  _showFavoritesOnly = true;
                } else if (selectedValue == FilterOptions.all) {
                  _showFavoritesOnly = false;
                }
              });
              //print(selectedValue);
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.favorites,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOptions.all,
                ),
              ];
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(_showFavoritesOnly),
    );
  }
}
