// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/auth.dart';
import '../dummy_data.dart';
import 'product.dart';

// Thus now we have a class and extended with ChangeNotifier which uses InheretidWidget in the background
// We have to convert this into a Data Container, into a Provider.
// Which we can use in our app, in various parts of our app
// For this we will go in our main and create a Provider and instantiate this class

class Products with ChangeNotifier {
  final String authtoken;
  final String userId;
  Products(this.authtoken, this.userId, this._items);

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
        'https://shop-app-526ea-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authtoken');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'image_url': product.imageUrl,
            'creator_id': userId,
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

  Future<void> fetchAndSetProducts({bool userProducts = false}) async {
    final filterString =
        userProducts ? 'orderBy="creator_id"&equalTo="$userId"' : '';
    final url = Uri.parse(
        'https://shop-app-526ea-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authtoken&$filterString');
    try {
      final response = await http.get(url);
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      //print(responseData);
      // Out put is nested Map: {id, Map of Product data}

      //* Now we will have favorites data of the user
      final url2 = Uri.parse(
          'https://shop-app-526ea-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$authtoken');
      final favoriteResponse = await http.get(url2);
      final favoritesData = jsonDecode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      responseData.forEach((prodId, prodData) {
        var newProd = Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['image_url'],
            isFavorite:
                favoritesData == null ? false : favoritesData[prodId] ?? false);
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
        'https://shop-app-526ea-default-rtdb.asia-southeast1.firebasedatabase.app/products/$productId.json?auth=$authtoken');
    try {
      final response = await http.patch(
        url,
        body: jsonEncode(
          {
            'title': updatedProduct.title,
            'description': updatedProduct.description,
            'price': updatedProduct.price,
            'image_url': updatedProduct.imageUrl,
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
        'https://shop-app-526ea-default-rtdb.asia-southeast1.firebasedatabase.app/products/$productId.json?auth=$authtoken');

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
