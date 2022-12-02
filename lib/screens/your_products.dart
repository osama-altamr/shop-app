import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

import '../widgets/body_products/user_product.dart';

class YourProducts extends StatefulWidget {
  static const routeName = '/your_products';

  @override
  State<YourProducts> createState() => _YourProductsState();
}

class _YourProductsState extends State<YourProducts> {
  Future _refreshProducts(BuildContext ctx) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Transform.scale(
          //       scale: 1.5,
          //       child: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Center(
          //               child: LoadingAnimationWidget.discreteCircle(
          //                 color: Colors.purple,
          //                 size: 40,
          //                 secondRingColor: Colors.deepOrange,
          //                 thirdRingColor: Colors.purple.shade600,
          //               ),
          //             ),
          //             const SizedBox(
          //               height: 8,
          //             ),
          //             Text('Loading...')
          //           ]));
          // }
          return RefreshIndicator(
              child: Consumer<Products>(
                builder: (context, val, _) {
                  return Padding(
                    padding:const  EdgeInsets.all(8),
                    child: ListView.builder(
                      itemBuilder: ((context, index) {
                        return Column(
                          children: [
                            UserProductItem(
                              productId: val.items[index].id!,
                              productTitle: val.items[index].title,
                              productImageUrl: val.items[index].imageUrl,
                            ),
                            const Divider(
                              color: Colors.purple,
                            ),
                          ],
                        );
                      }),
                      itemCount: val.items.length,
                    ),
                  );
                },
              ),
              onRefresh: () => _refreshProducts(context));
        },
        future: _refreshProducts(context),
      ),
    );
  }
}
