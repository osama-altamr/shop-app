import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' hide OrderItem show Orders;

import '../widgets/body_products/order-item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/order_screen';

  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Transform.scale(
                scale: 1.5,
                child: Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              );
            } else {
              if (snapshot.error != null) {
                return Center(
                  child: Text('An Error Occurred'),
                );
              } else {
                return Consumer<Orders>(builder: (context, orderData, child) {
                  return ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: (ctx, index) {
                        return OrderItem(order: orderData.orders[index]);
                      });
                });
              }
            }
          }),
    );
  }
}
