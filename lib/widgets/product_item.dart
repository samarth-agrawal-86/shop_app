// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../screens/product_details_page.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cartData = Provider.of<Cart>(context, listen: true);
    final authData = Provider.of<Auth>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GridTile(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailsPage.routeName,
                  arguments: product.id);
            },
            splashColor: Colors.black45,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black45,
            leading: Consumer<Product>(
              builder: (context, product, child) {
                return IconButton(
                  onPressed: () {
                    product.toggleFavoriteStatus(
                        authData.getToken!, authData.getUserId!);
                  },
                  icon: Icon(product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                );
              },
            ),
            title: Text(product.title),
            trailing: IconButton(
              onPressed: () {
                cartData.addItem(product.id, product.title, product.price);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Item Added to Cart'),
                    duration: Duration(seconds: 1),
                    action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cartData.removeItem(product.id);
                        }),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ),
      ),
    );
  }
}
