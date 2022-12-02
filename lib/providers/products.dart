import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/productObj.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<ProductObj> _items = [];

  String? authToken;
  String? userId;

  getData(String token, String uId, List<ProductObj> products) {
    authToken = token;
    userId = uId;
    _items = products;
    notifyListeners();
  }

  List<ProductObj> get items {
    return [..._items];
    // spread operator
  }

  List<ProductObj> get favoritesItems {
    return _items.where((prod) => prod.isFavorite == true).toList();
  }

  ProductObj findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future fetchAndSetProducts([bool filterByUser = false]) async {
    final filteredString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    /*?auth=$authToken&$filteredString*/
    String url =
        'https://shopping-ef355-default-rtdb.firebaseio.com/products.json';

    try {
      final res = await http.get(Uri.parse(url));
      Map<String, dynamic>? extractedData = json.decode(res.body);
      if (extractedData == null) {
        print('Nulllllllll');
        print('++++++++++++++++============+++++++++++++++');
        return;
      }
      /* ?auth=$authToken */
      url =
          'https://shopping-ef355-default-rtdb.firebaseio.com/userFavorites/$userId.json';
      final resFavorites = await http.get(Uri.parse(url));
      final extractedFavoritesData = json.decode(resFavorites.body);
      List<ProductObj> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(ProductObj(
          idType: prodData['idType'],
          id: prodId,
          discount: prodData['discount'] ?? 0,
          priceAfDiscount: prodData['priceAfDiscount'] ?? prodData['price'],
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: extractedFavoritesData == null
              ? false
              : extractedFavoritesData[prodId] ?? false,
        ));
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future addProducts(
      ProductObj product, String category, int getDiscount) async {
    /* ?auth=$authToken */
    String url =
        'https://shopping-ef355-default-rtdb.firebaseio.com/products.json';
    try {
      /* product.idType */
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'idType': categoryToFirebase(category),
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
            'priceAfDiscount': discountToFirebase(
              getDiscount,
              product.price,
            ),
            'discount': getDiscount,
          }));
      final newProd = ProductObj(
        id: json.decode(res.body)['name'],
        idType: categoryToFirebase(category),
        title: product.title,
        discount: getDiscount,
        description: product.description,
        price: product.price,
        priceAfDiscount: discountToFirebase(getDiscount, product.price),
        imageUrl: product.imageUrl,
      );

      _items.add(newProd);
      // _items.insert(0, newProd);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future updateProduct(
      String id, ProductObj newProduct, String cagteg, int getDiscount) async {
    String url =
        'https://shopping-ef355-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    int prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      try {
        await http.patch(Uri.parse(url),
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'price': newProduct.price,
              'imageUrl': newProduct.imageUrl,
              'idType': categoryToFirebase(cagteg),
              'priceAfDiscount':
                  discountToFirebase(getDiscount, newProduct.price),
              'discount': getDiscount,
            }));
        _items[prodIndex] = ProductObj(
          idType: newProduct.idType,
          id: newProduct.id,
          discount: getDiscount,
          priceAfDiscount: discountToFirebase(getDiscount, newProduct.price),
          title: newProduct.title,
          description: newProduct.description,
          price: newProduct.price,
          imageUrl: newProduct.imageUrl,
        );
        notifyListeners();
      } catch (error) {
        throw error;
      }
    } else {
      print('...');
    }
  }

  Future deleteProduct(String id) async {
    String url =
        'https://shopping-ef355-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    int indexProd = _items.indexWhere((prod) => prod.id == id);
    ProductObj? oldProduct = _items[indexProd];
    _items.removeAt(indexProd);
    notifyListeners();
    try {
      final res = await http.delete(Uri.parse(url));
      if (res.statusCode >= 400) {
        _items.insert(indexProd, oldProduct);

        notifyListeners();
        throw HttpException('DELETED_FAILED');
      }
    } catch (error) {
      _items.insert(indexProd, oldProduct);
      notifyListeners();
    }
    oldProduct = null;
  }

  String categoryToFirebase(String cat) {
    if (cat == 'Laptop') {
      return '-NDynAESyXi4hf3pUZn2';
    }
    if (cat == 'Mobile') {
      return '-NDyo0OF92oWBjIDQ0sQ';
    }
    if (cat == 'Watch') {
      return '-NDyr2FtTTsbZDH3IrWk';
    }
    if (cat == 'Headphone') {
      return '-NEq6EVsuzNzghSV65_t';
    }
    print('Error in method category');
    return '';
  }

  double discountToFirebase(int discount, double price) {
    return (price - (price * (discount / 100)));
  }
}
