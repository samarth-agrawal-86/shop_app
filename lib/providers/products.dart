import 'package:flutter/material.dart';
import '../dummy_data.dart';
import '../models/product.dart';

// Thus now we have a class and extended with ChangeNotifier which uses InheretidWidget in the background
// We have to convert this into a Data Container, into a Provider.
// Which we can use in our app, in various parts of our app
// For this we will go in our main and create a Provider and instantiate this class

class Products with ChangeNotifier {
  // this would not be final. because this will change over item
  List<Product> _items = dummyProducts;

  List<Product> get items {
    return [..._items];
  }

  Product findById(String productId) {
    return _items.firstWhere((item) => item.id == productId);
  }
}
