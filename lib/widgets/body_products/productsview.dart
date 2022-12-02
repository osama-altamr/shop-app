import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';

import '../../providers/productObj.dart';
import '../../providers/products.dart';
import '../../screens/product_detial_screen.dart';

class AllProductsGrid extends StatefulWidget {
  String? idOfType;
  final bool isFavorite;
  AllProductsGrid({
    Key? key,
    required this.isFavorite,
    this.idOfType,
  }) : super(key: key);

  @override
  State<AllProductsGrid> createState() => _AllProductsGridState();
}

class _AllProductsGridState extends State<AllProductsGrid> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future _refreshData() async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) {})
        .catchError((e) {
      print('catch error in favorite screen');
    });
  }

  List<ProductObj> productsData = [];

  @override
  Widget build(BuildContext context) {
    productsData = !(widget.isFavorite)
        ? Provider.of<Products>(context)
            .items
            .where((prod) => prod.idType == widget.idOfType)
            .toList()
        : (widget.idOfType == null
            ? Provider.of<Products>(context).favoritesItems
            : Provider.of<Products>(context)
                .favoritesItems
                .where((element) => element.idType == widget.idOfType)
                .toList());
    final authData = Provider.of<Auth>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return _isLoading
        ? Transform.scale(
            scale: 1.5,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.deepOrange, size: 30)),
              const SizedBox(
                height: 8,
              ),
            ]))
        : (productsData.isEmpty
            ? Center(
                child: Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(20),
                  child: Text(
                    '${widget.isFavorite == true ? "You have no favorites yet -start adding some!" : " There is no product!'"} ',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: _refreshData,
                child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: productsData.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 2 / 2.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (ctx, index) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(0),
                            ),
                            child: GridTile(
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      ProductDetialScreen.routeName,
                                      arguments: {
                                        "id": productsData[index].id,
                                      },
                                    );
                                  },
                                  child: Hero(
                                    tag: productsData[index].id!,
                                    child: FadeInImage(
                                      placeholder: const AssetImage(
                                          'assets/images/products-images/placholderproduct.png'),
                                      image: NetworkImage(
                                          productsData[index].imageUrl),
                                      fit: BoxFit.contain,
                                    ),
                                  )),
                              footer: GridTileBar(
                                backgroundColor: Colors.black87,
                                title: Text(productsData[index].title),
                                leading: IconButton(
                                    onPressed: () {
                                      cart.addItemToCart(
                                        productsData[index].id!,
                                        productsData[index].title,
                                        productsData[index].priceAfDiscount != 0
                                            ? productsData[index]
                                                .priceAfDiscount
                                            : productsData[index].price,
                                        productsData[index].imageUrl,
                                      );
                                      // ScaffoldMessenger.of(context)
                                      //     .hideCurrentSnackBar();
                                      Flushbar(
                                        title: "Added to Cart!",
                                        titleColor: Colors.deepOrange,
                                        message:
                                            "To remove the product from cart , Click undo! ",
                                        flushbarPosition:
                                            FlushbarPosition.BOTTOM,
                                        flushbarStyle: FlushbarStyle.FLOATING,
                                        reverseAnimationCurve:
                                            Curves.decelerate,
                                        forwardAnimationCurve:
                                            Curves.elasticOut,
                                        backgroundColor: Colors.red,
                                        boxShadows: const [
                                          BoxShadow(
                                              color: Colors.purple,
                                              offset: Offset(0.0, 2.0),
                                              blurRadius: 3.0)
                                        ],
                                        backgroundGradient:
                                            const LinearGradient(colors: [
                                          Colors.purpleAccent,
                                          Colors.black87
                                        ]),
                                        isDismissible: false,
                                        duration: const Duration(seconds: 4),
                                        icon: const Icon(
                                          Icons.error,
                                          color: Colors.deepOrange,
                                        ),
                                        mainButton: TextButton(
                                          onPressed: () {
                                            cart.removeSingleItem(
                                                productsData[index].id!);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            "UNDO!",
                                            style: TextStyle(
                                                color: Colors.deepOrange),
                                          ),
                                        ),
                                      ).show(context);
                                    },
                                    icon: const Icon(
                                      Icons.add_shopping_cart,
                                      color: Colors.redAccent,
                                    )),
                              ),
                            ),
                          ),
                          if (productsData[index].discount != 0)
                            Container(
                                height: 40,
                                width: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: Center(
                                    child: Text(
                                  '-${productsData[index].discount}%',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))),
                        ],
                      );
                    }),
              ));
  }
}
