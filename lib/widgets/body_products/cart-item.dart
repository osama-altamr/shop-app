import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final int quantity;
  final double price;
  final String title;
  final String imageUrl;

  const CartItem({
    required this.id,
    required this.title,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 160,
                  width: 120,
                  child: imageUrl == null
                      ? Container()
                      : Image.network(
                          imageUrl,
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      child: Text(
                        title,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "\$ ${(price * quantity).toStringAsFixed(2)} ",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade300,
                ),
                child: Row(
                  children: [
                    IconButton(
                      iconSize: 20,
                      alignment: Alignment.center,
                      onPressed: () {
                        Provider.of<Cart>(context, listen: false)
                            .removeSingleItem(productId);         
                      },
                      icon: const Icon(
                        Icons.remove,
                      ),
                    ),
                    Text(
                      " $quantity ",
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    IconButton(
                      iconSize: 20,
                      onPressed: () {
                        Provider.of<Cart>(context, listen: false).addItemToCart(
                          productId,
                          title,
                          price,
                          imageUrl,
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 10)
            ]),
            const Divider(
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}
