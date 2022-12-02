import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';

import '../widgets/body_products/badge.dart';
import '../widgets/body_products/productsview.dart';

enum FilterFavorites {
  all,
  laptop,
  mobile,
  headphone,
  watch,
}

class FavoriteScreen extends StatefulWidget {
  static const routeName = '/favorite-screen';

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  String? type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Favorites',
          style: TextStyle(fontFamily: 'Anton'),
        ),
        actions: [
          PopupMenuButton(
            onSelected: (FilterFavorites selectedVal) {
              if (selectedVal == FilterFavorites.all) {
                type = null;
              } else if (selectedVal == FilterFavorites.laptop) {
                type = '-NDynAESyXi4hf3pUZn2';
              } else if (selectedVal == FilterFavorites.mobile) {
                type = '-NDyo0OF92oWBjIDQ0sQ';
              } else if (selectedVal == FilterFavorites.watch) {
                type = '-NDyr2FtTTsbZDH3IrWk';
              } else if (selectedVal == FilterFavorites.headphone) {
                type = '-NEq6EVsuzNzghSV65_t';
              } else {}

              setState(() {});
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (ctx) => const [
              PopupMenuItem(
                child: Text('All Favorites'),
                value: FilterFavorites.all,
              ),
              PopupMenuItem(
                child: Text('Mobiles'),
                value: FilterFavorites.mobile,
              ),
              PopupMenuItem(
                child: Text('Lapotps'),
                value: FilterFavorites.laptop,
              ),
              PopupMenuItem(
                child: Text('Watches'),
                value: FilterFavorites.watch,
              ),
              PopupMenuItem(
                child: Text('Headphones'),
                value: FilterFavorites.headphone,
              ),
            ],
          ),
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
        isFavorite: true,
        idOfType: type,
      ),
    );
  }
}
