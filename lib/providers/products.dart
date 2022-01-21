// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import '../dummy_data.dart';
import 'product.dart';

// Thus now we have a class and extended with ChangeNotifier which uses InheretidWidget in the background
// We have to convert this into a Data Container, into a Provider.
// Which we can use in our app, in various parts of our app
// For this we will go in our main and create a Provider and instantiate this class

class Products with ChangeNotifier {
  // this would not be final. because this will change over item
  List<Product> _items = [];

  List<Product> get allItems {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite == true).toList();
  }

  Product findById(String productId) {
    return _items.firstWhere((item) => item.id == productId);
  }
/* With then method
  Future<void> addProduct(Product product) {
    // In the firebase realtime database.
    // we get a link that is our base location,
    // then we add /products to create a folder.
    // Special firestore format is to add .json after the folder name
    // Hence /products.json
    final url = Uri.parse(
        'https://shop-app-526ea-default-rtdb.asia-southeast1.firebasedatabase.app/products');
    // body requires data in JSON format
    // it is created using jsonEncode method available in convert package
    return http
        .post(
      url,
      body: jsonEncode(
        {
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'image_url': product.imageUrl
        },
      ),
    )
        .then(
      (response) {
        // print(response);
        // print(response.body);
        //{"name":"-MtsHBE1kChcLeijPHJN"}
        // print(jsonDecode(response.body)['name']);
        var newProduct = Product(
          id: jsonDecode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
        );
        _items.add(newProduct);
        notifyListeners();
      },
    ).catchError((onError) {
      print(onError);
      throw onError;
    });
  }
*/
// With async-await combination
// Instead of catcherror now we have try-catch combination

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shop-app-526ea-default-rtdb.asia-southeast1.firebasedatabase.app/products.json');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'image_url': product.imageUrl
          },
        ),
      );

      var newProduct = Product(
        id: jsonDecode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (onError) {
      print(onError);
      throw onError;
    }
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://shop-app-526ea-default-rtdb.asia-southeast1.firebasedatabase.app/products.json');
    try {
      final response = await http.get(url);
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      //print(responseData);
      // Out put is nested Map: {id, Map of Product data}
      final List<Product> loadedProducts = [];
      responseData.forEach((prodId, prodData) {
        var newProd = Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['image_url'],
        );
        loadedProducts.add(newProd);
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (onError) {
      print(onError);
    }
  }

  Future<void> updateProduct(String productId, Product updatedProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == productId);
    final url = Uri.parse(
        'https://shop-app-526ea-default-rtdb.asia-southeast1.firebasedatabase.app/products/$productId.json');
    try {
      final response = await http.patch(
        url,
        body: jsonEncode(
          {
            'title': updatedProduct.title,
            'description': updatedProduct.description,
            'price': updatedProduct.price,
            'image_url': updatedProduct.imageUrl
          },
        ),
      );
      if (response.statusCode >= 400) {
        throw 'Error';
      }
      _items[prodIndex] = updatedProduct;
      notifyListeners();
    } catch (onError) {
      print(onError);
    }
  }

  Future<void> deleteProduct(String productId) async {
    final url = Uri.parse(
        'https://shop-app-526ea-default-rtdb.asia-southeast1.firebasedatabase.app/products/$productId.json');

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      throw HttpException('Could not delete product');
      // throw is like return.
      // it cancels the code execution
      // code further will not get executed
    }
    _items.removeWhere((prod) => prod.id == productId);

    notifyListeners();
  }
}
