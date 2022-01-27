import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String authtoken, String userId) async {
    isFavorite = !isFavorite;
    final url = Uri.parse(
        'https://shop-app-526ea-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$authtoken');

    final response = await http.put(url, body: jsonEncode(isFavorite));
    final responseData = jsonDecode(response.body);

    notifyListeners();
  }
}
