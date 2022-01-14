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
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: 300,
            width: double.infinity,
            child: Image.network(
              item.imageUrl,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            child: Text(
              '\$${item.price}',
              style: TextStyle(color: Colors.grey, fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Text(
              '${item.description}',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ],
      )),
    );
  }
}
