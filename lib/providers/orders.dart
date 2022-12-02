import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.dateTime,
    required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  String? authToken;
  String? userId;

  getData(String token, String uId, List<OrderItem> orders) {
    authToken = token;
    userId = uId;
    _orders = orders;
    notifyListeners();
  }

  List<OrderItem> get orders {
    return [..._orders];
    // spread operator
  }

  Future fetchAndSetOrders() async {
    final url =
        'https://shopping-ef355-default-rtdb.firebaseio.com/orders/$userId.json';

    try {
      final res = await http.get(Uri.parse(url));
      Map<String, dynamic>? extractedData = json.decode(res.body);
      if (extractedData == null) {
        print('Nulllllllll');
        print('++++++++++++++++============+++++++++++++++');
        return;
      }
      /* ?auth=$authToken */

      List<OrderItem> loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                      id: item['id'],
                      title: item['title'],
                      price: double.parse(item['price']),
                      imageUrl: item['imageUrl'],
                      quantity: item['quantity'],
                    ))
                .toList(),
          ),
        );
      });

      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future addProducts(List<CartItem> cartProducts, double total) async {
    /* ?auth=$authToken */
    DateTime timeStamp = DateTime.now();
    final url =
        'https://shopping-ef355-default-rtdb.firebaseio.com/orders/$userId.json';
    try {
      /* product.idType */
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                    })
                .toList(),
          }));

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(res.body)['name'],
          amount: total,
          dateTime: timeStamp,
          products: cartProducts,
        ),
      );
      // _items.insert(0, newProd);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
