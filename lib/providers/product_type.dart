// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ProductType {
  final String id;
  final String imageUrl;
  final String title;

  ProductType({
    required this.id,
    required this.imageUrl,
    required this.title,
  });
}

class ProductTypeProvider with ChangeNotifier {
  List<ProductType> _itemsType = [];
  
  String? authToken;
  String? userId;

  getData(String token, String uId, List<ProductType> products) {
    authToken = token;
    userId = uId;
    _itemsType = products;
    notifyListeners();
  }

  List<ProductType> get itemsType {
    return [..._itemsType];
  }

  // addProductType() async {
  //   try {
  //     String url =
  //         'https://shopping-ef355-default-rtdb.firebaseio.com/categories.json';

  //     final res = await http.post(Uri.parse(url),
  //         body: json.encode({
  //           'title': 'headphones',
  //           'imageUrl':
  //               'https://cdn.pixabay.com/photo/2017/01/18/17/14/girl-1990347_960_720.jpg',
  //         }));
  //     print('hello product type is added');
  //   } catch (error) {}
  // }

  Future fetchAndSetProductsType() async {
    String url =
        'https://shopping-ef355-default-rtdb.firebaseio.com/categories.json';

    try {
      final res = await http.get(Uri.parse(url));
      Map<String, dynamic> extractedData = json.decode(res.body);
      List<ProductType> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(ProductType(
          id: prodId,
          title: prodData['title'],
          imageUrl: prodData['imageUrl'],
        ));
      });

      _itemsType = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
