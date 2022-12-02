import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_type.dart';
import 'package:shop_app/widgets/body_products/indicator.dart';

import '../../screens/prodcuts_screen.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    List<ProductType> productTypeData =
        Provider.of<ProductTypeProvider>(context, listen: false).itemsType;
    return Expanded(
      flex: 5,
      child: Column(children: [
        CarouselSlider.builder(
          itemCount: productTypeData.length,
          itemBuilder: (ctx, index, _) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(ProductsScreen.routeName, arguments: {
                  'id': productTypeData[index].id,
                  'title': productTypeData[index].title,
                });
              },
              child: Container(
                width: 230,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  shadowColor: Colors.purple,
                  margin: const EdgeInsets.all(10),
                  child: Stack(fit: StackFit.expand, children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      child: FadeInImage(
                        height: 280,
                        fit: BoxFit.cover,
                        placeholder: const AssetImage(
                            'assets/images/products-images/fade-prodcut.png'),
                        image: NetworkImage(
                          '${productTypeData[index].imageUrl}',
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(15),
                          ),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.only(
                            left: 15, bottom: 10, right: 20, top: 8),
                        child: Row(children: [
                          Text(
                            productTypeData[index].title,
                            style: const TextStyle(
                                color: Colors.deepOrange,
                                fontFamily: 'Anton',
                                fontSize: 16),
                          ),
                          const Spacer(),
                          Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color: Colors.purple, shape: BoxShape.circle),
                              child: const Icon(
                                Icons.forward_outlined,
                                color: Colors.white,
                              )),
                        ]),
                      ),
                    )
                  ]),
                ),
              ),
            );
          },
          options: CarouselOptions(
              viewportFraction: .65,
              onScrolled: (val) {},
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              aspectRatio: 2.7 / 2.6,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Indicator(
          index: _current,
        ),
      ]),
    );
  }
}



/* 
 */