// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/productObj.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/body_products/badge.dart';
import 'package:shop_app/widgets/body_products/productsview.dart';

import '../providers/products.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = '/products_view';

  const ProductsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    String title = arguments!['title'];
    String id = arguments['id'];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          Consumer<Cart>(
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    CartScreen.routeName,
                  );
                },
              ),
              builder: ((ctx, cart, chld) => Badge(
                    child: chld!,
                    value: cart.itemCount.toString(),
                  ))),
        ],
      ),
      body: AllProductsGrid(
        idOfType: id,
        isFavorite: false,
      ),
    );
  }
}
