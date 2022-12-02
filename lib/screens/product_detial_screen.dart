import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/productObj.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';

import '../widgets/appBar-widget/badge_appBar.dart';

class ProductDetialScreen extends StatelessWidget {
  const ProductDetialScreen({Key? key}) : super(key: key);

  static const routeName = '/product_detial_screen';

  @override
  Widget build(BuildContext context) {
    String? _authToken = Provider.of<Auth>(context, listen: false).token;
    String? _userId = Provider.of<Auth>(context, listen: false).userId;

    final dataScreen =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String id = dataScreen['id'];
    ProductObj loadedProdcut =
        Provider.of<Products>(context, listen: true).findById(id);
    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: false,
        slivers: [
          SliverAppBar(
            expandedHeight: 310,
            actions: [
              // Consumer<Cart>(
              //     child: Transform.scale(
              //       scale: 1.3,
              //       child: IconButton(
              //           onPressed: () {
              //             Navigator.of(context).pushNamed(CartScreen.routeName);
              //           },
              //           icon: const Icon(
              //             Icons.shopping_cart,
              //             color: Colors.deepOrange,
              //           )),
              //     ),
              //     builder: (ctx, cart, child) {
              //       return BadgeAppBar(
              //         countOfCart: cart.itemCount.toString(),
              //         newChild: child!,
              //       );
              //     }),
            ],
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: FloatingActionButton(
                mini: true,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.arrow_back),
              ),
            ),
            leadingWidth: 42,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: loadedProdcut.id!,
                child: InteractiveViewer(
                  child: Image.network(
                    loadedProdcut.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  alignment: Alignment.center,
                  // margin: EdgeInsets.only(top: 10 ),
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    loadedProdcut.title,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  minLeadingWidth: 10,
                  minVerticalPadding: 18,
                  title: Text(
                    loadedProdcut.description,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.start,
                  ),
                  leading: CustomContainer(),
                ),
                ListTile(
                  minLeadingWidth: 0,
                  leading: CustomContainer(),
                  title: Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: '\$',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  '${loadedProdcut.priceAfDiscount.toStringAsFixed(2)}  ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // if(loadedProdcut. ppp)
                      if (loadedProdcut.price != loadedProdcut.priceAfDiscount)
                        RichText(
                          text: TextSpan(
                            text: '\$',
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '${loadedProdcut.price}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Consumer<ProductObj>(
        builder: (ctx, val, _) {
          return FloatingActionButton(
            backgroundColor: Colors.deepOrange,
            heroTag: val.id,
            onPressed: () {
              val.toggleFavoriteStatus(
                _authToken!,
                _userId!,
                loadedProdcut.id!,
              );
            },
            child: Provider.of<ProductObj>(context, listen: true).isFavorite
                ? Icon(
                    Icons.favorite,
                  )
                : Icon(Icons.favorite_border_outlined),
          );
        },
      ),
    );
  }
  // IconButton(
  //                     icon: productsData[index].isFavorite
  //                         ? const Icon(
  //                             Icons.favorite,
  //                             color: Colors.deepOrange,
  //                           )
  //                         : const Icon(
  //                             Icons.favorite_border,
  //                             color: Colors.deepOrange,
  //                           ),
  //                     onPressed: () {
  //                       Provider.of<ProductObj>(context, listen: false)
  //                           .toggleFavoriteStatus(
  //                               authData.token!, authData.userId!);
  //                     },
  //                   )

  Container CustomContainer() {
    return Container(
      margin: EdgeInsets.only(top: 9),
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
        color: Colors.deepOrangeAccent,
        shape: BoxShape.circle,
      ),
    );
  }
}
