import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import '../providers/products.dart';
import './product_grid_item.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This is where we are setting the provider listener.
    // Hence this widget and all the child below it will get re built
    // Nothing will happen to products_overview_page because listener is not set at that page
    // In the provider of <> here in the angular bracket we can define the type of data we want to listen to
    // we mark them as listen: true
    final productsData = Provider.of<Products>(context, listen: true);
    print(productsData);
    //* Instance of 'Products'

    final products = productsData.items;
    print(products);
    //* [Instance of 'Product', Instance of 'Product', Instance of 'Product', Instance of 'Product']

    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        //mainAxisSpacing: 10,
        //crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return ProductGridItem(
          id: products[index].id,
          title: products[index].title,
          imageUrl: products[index].imageUrl,
        );
      },
    );
  }
}
