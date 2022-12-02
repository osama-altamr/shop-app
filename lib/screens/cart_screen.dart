import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/body_products/cart-item.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart_screen';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Icon(
            Icons.share_outlined,
            color: Colors.grey,
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(
          left: 10,
          top: 8,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'Shopping Cart',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            cart.itemCount == 0
                                ? Colors.grey
                                : Colors.redAccent),
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(13),
                        )))),
                    onPressed: cart.itemCount == 0
                        ? null
                        : (isloading
                            ? null
                            : () async {
                                setState(() {
                                  isloading = true;
                                });
                                await Provider.of<Orders>(context,
                                        listen: false)
                                    .addProducts(cart.itemsCart.values.toList(),
                                        cart.totalAmount);
                                setState(() {
                                  isloading = false;
                                });
                                cart.clearCart();
                              }),
                    child: isloading
                        ? Transform.scale(
                            scale: 1.5,
                            child: Center(
                              child: LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          )
                        : Text('ORDER NOW'))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '${cart.itemCount}  items',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Divider(
              thickness: 3,
              endIndent: 9,
              color: Colors.purple,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                'Sub total',
                style: TextStyle(fontSize: 15),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            Expanded(
                flex: 2,
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return CartItem(
                      id: cart.itemsCart.values.toList()[index].id,
                      title: cart.itemsCart.values.toList()[index].title,
                      productId: cart.itemsCart.keys.toList()[index],
                      price: cart.itemsCart.values.toList()[index].price,
                      quantity: cart.itemsCart.values.toList()[index].quantity,
                      imageUrl: cart.itemsCart.values.toList()[index].imageUrl,
                    );
                  },
                  itemCount: cart.itemsCart.length,
                )),
          ],
        ),
      ),
    );
  }
}
