import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool _showFavoritesOnly;
  ProductsGrid(this._showFavoritesOnly);

  @override
  Widget build(BuildContext context) {
    // This is where we are setting the provider listener.
    // Hence this widget and all the child below it will get re built
    // Nothing will happen to products_overview_page because listener is not set at that page
    // In the provider of <> here in the angular bracket we can define the type of data we want to listen to
    // we mark them as listen: true
    final productsData = Provider.of<Products>(context, listen: true);
    //print(productsData);
    //* Instance of 'Products'

    final products = _showFavoritesOnly == true
        ? productsData.favoriteItems
        : productsData.allItems;
    //print(products);
    //* [Instance of 'Product', Instance of 'Product', Instance of 'Product', Instance of 'Product']

    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        //mainAxisSpacing: 10,
        //crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
          //create: (context) => products[index],

          // Flutter doesn't re build the widget. It recycles it. only the data in the widget changes and widget does not.
          // Provide with create and context is not a good solution here. hence we use .value
          child: ProductItem(),
        );
      },
    );
  }
}
