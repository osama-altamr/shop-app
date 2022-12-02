import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProductObj with ChangeNotifier {
  final String? id;
  String idType;
  final String title;
  final String description;
  final double price;
  final double priceAfDiscount;
  final int discount;
  final String imageUrl;
  bool isFavorite;

  ProductObj({
    this.isFavorite = false,
    required this.idType,
    required this.id,
    required this.discount,
    required this.priceAfDiscount,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  void _setFavoriteValue(bool newVal) {
    isFavorite = newVal;
    notifyListeners();
  }

  Future toggleFavoriteStatus(
    String token,
    String userId,
    String idProduct,
  ) async {
    final bool oldStatusFav = isFavorite;
    isFavorite =!isFavorite;
    notifyListeners();
    try {
      // ?auth=$token
      String url =
          'https://shopping-ef355-default-rtdb.firebaseio.com/userFavorites/$userId/$idProduct.json';
      final res = await http.put(Uri.parse(url), body: json.encode(isFavorite));
      if (res.statusCode >= 400) {
        _setFavoriteValue(oldStatusFav);
      }
    } catch (error) {
      _setFavoriteValue(oldStatusFav);
    }
  }
}
