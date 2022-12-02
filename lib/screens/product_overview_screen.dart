import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product_type.dart';
import 'package:shop_app/providers/products.dart';

import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/profile-screen.dart';

import '../providers/auth.dart';
import '../widgets/appBar-widget/badge_appBar.dart';
import '../widgets/body_products/products_type_view.dart';

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  static const routeName = '/product_overview_screen';

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _isLoading = false;
  bool isInit = true;
  bool _isExp = false;
  @override
  void initState() {
    _isLoading = true;
    if (isInit) {
      Provider.of<ProductTypeProvider>(context, listen: false)
          .fetchAndSetProductsType()
          .then((value) => setState(() {
                _isLoading = false;
              }))
          .catchError((e) {
        setState(() {
          _isLoading = false;
          _isExp = true;
        });
      });
      setState(() {
        isInit = false;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping', style: TextStyle(fontFamily: 'Anton')),
        actions: [
          // PopupMenuButton(
          //     onSelected: (FilterOption val) {
          //       if (val == FilterOption.favorites) {
          //         setState(() {
          //           _showOnlyFavorites = true;
          //         });
          //       } else {
          //         setState(() {
          //           _showOnlyFavorites = false;
          //         });
          //       }
          //     },
          //     icon: Icon(Icons.more_vert),
          //     itemBuilder: (_) => const [
          //           PopupMenuItem(
          //             child: Text('Only Favorites'),
          //             value: FilterOption.favorites,
          //           ),
          //           PopupMenuItem(
          //             child: Text('Show All'),
          //             value: FilterOption.all,
          //           ),
          //         ]),
        ],
      ),
      body: _isLoading
          ? Transform.scale(
              scale: 1.5,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: LoadingAnimationWidget.discreteCircle(
                        color: Colors.purple,
                        size: 40,
                        secondRingColor: Colors.deepOrange,
                        thirdRingColor: Colors.purple.shade600,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text('Loading...')
                  ]))
          : _isExp
              ? Container(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.scale(
                        scale: 4,
                        child: const Icon(
                          Icons.error_sharp,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      const Text(
                        "Sorry, something's not right,We cannot access our server at the moment,Please change your network connection and restart the app.",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.grey,
                            fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )),
                )
              : Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Text(
                            'Categories',
                            style: TextStyle(
                              color: Color.fromARGB(255, 241, 78, 37),
                              fontFamily: 'Anton',
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      const ProductsView(),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Center(
                          child: FloatingActionButton(
                            backgroundColor: Colors.deepOrange.shade500,
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                EditProductScreen.routeName,
                              );
                            },
                            child: const Icon(Icons.add),
                          ),
                        ),
                      )),
                    ],
                  )),
    );
  }
}
