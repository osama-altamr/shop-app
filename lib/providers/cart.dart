import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _itemsCart = {};

  Map<String, CartItem> get itemsCart {
    return {..._itemsCart};
  }

  int get itemCount {
    return _itemsCart.length;
  }

  double get totalAmount {
    double _total = 0.0;
    _itemsCart.forEach((key, CartItem) {
      _total += CartItem.price * CartItem.quantity;
    });
    return _total;
  }

  void addItemToCart(
      String prodId, String title, double price, String image) {
    if (_itemsCart.containsKey(prodId)) {
      _itemsCart.update(
          prodId,
          (cartItem) => CartItem(
                id: cartItem.id,
                title: cartItem.title,
                imageUrl: image,
                price: cartItem.price,
                quantity: cartItem.quantity + 1,
              ));
    } else {
      _itemsCart.putIfAbsent(
          prodId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                imageUrl: image,
                quantity: 1,
              ));
    }

    notifyListeners();
  }

  void removeItem(String prodId) {
    _itemsCart.remove(prodId);
    notifyListeners();
  }

  void removeSingleItem(String prodId) {
    if (!_itemsCart.containsKey(prodId)) {
      return;
    }
    if (_itemsCart[prodId]!.quantity > 1) {
      _itemsCart.update(
          prodId,
          (cartItem) => CartItem(
                id: cartItem.id,
                title: cartItem.title,
                price: cartItem.price,
                imageUrl: cartItem.imageUrl,
                quantity: cartItem.quantity - 1,
              ));
    } else {
      _itemsCart.remove(prodId);
    }
    notifyListeners();
  }

  void clearCart() {
    _itemsCart = {};
    notifyListeners();
  }
}
