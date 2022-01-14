// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { favorites, all }

class ProductOverviewPage extends StatefulWidget {
  @override
  State<ProductOverviewPage> createState() => _ProductOverviewPageState();
}

class _ProductOverviewPageState extends State<ProductOverviewPage> {
  var _showFavoritesOnly = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
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
      body: ProductsGrid(_showFavoritesOnly),
    );
  }
}
