import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

class ProductDetailsPage extends StatelessWidget {
  static const routeName = '/product-details';
  const ProductDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    // we should move as much logic as possible out of widget to provider class
    // final item = Provider.of<Products>(context, listen: false)
    //     .items
    //     .firstWhere((item) => item.id == productId);

// Here we can provide listen: false
// if we add product somwhere else, that should not impact this screen
// this screen is just about one product and we may not want to rebuild this
    final item =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
    );
  }
}
