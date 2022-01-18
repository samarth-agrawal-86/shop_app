import 'package:flutter/material.dart';

class CartItem {
  // this id is not the product id, this is cart item id which comes from timestamp
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });
}

class Cart with ChangeNotifier {
  // Now the cart item can be managed in Cart class
  // Key will be product id, and value will be a CartItem object
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get cartItems {
    return {..._items};
  }

  int get cartItemsCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cart) {
      total = total + cart.price * cart.quantity;
    });
    return total;
  }

  void cartClear() {
    _items = {};
    notifyListeners();
  }

  void addItem(String productID, String title, double price) {
    if (_items.containsKey(productID)) {
      // if product already exists in cart, we should increase the quantity
      _items.update(
          productID,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity + 1,
              ));
    } else {
      // if product doesn't exist in cart, then we should add to cart
      _items.putIfAbsent(
        productID,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeProduct(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeItem(String productId) {
    // if number of items = 1 then delete product
    // else remove one quantity
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
