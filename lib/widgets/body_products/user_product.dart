// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/http_exception.dart';

import 'package:shop_app/providers/productObj.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

import '../../providers/products.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem({
    Key? key,
    required this.productId,
    required this.productTitle,
    required this.productImageUrl,
  }) : super(key: key);
  final String productId;
  final String productTitle;
  final String productImageUrl;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: ListTile(
            title: const Text('Edit Product'),
            trailing: IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.purple,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                  arguments: productId,
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: ListTile(
            title: const Text('Delete Product'),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () async {
                try {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: Text('Delete Product!'),
                          content:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Divider(
                              color: Colors.purple,
                            ),
                            Text('Are you sure to delete the Product ?')
                          ]),
                          actions: [
                            TextButton(
                                onPressed: () async {
                                  await Provider.of<Products>(context,
                                          listen: false)
                                      .deleteProduct(productId);
                                },
                                child: Text('Okay!'))
                          ],
                        );
                      });
                } on HttpException catch (exp) {
                  return showDialog(
                      context: context,
                      builder: (cyx) {
                        return AlertDialog(
                          title: const Text('Deleting faild'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(cyx).pop();
                                },
                                child: const Text('Cancel'))
                          ],
                        );
                      });
                } catch (e) {
                  showDialog(
                      context: context,
                      builder: (cyx) {
                        return AlertDialog(
                          title: Text('Deleting faild'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(cyx).pop();
                                },
                                child: Text('Cancel'))
                          ],
                        );
                      });
                }
              },
            ),
          ),
        ),
      ],
      leading: CircleAvatar(
        foregroundImage: NetworkImage(productImageUrl),
        radius: 25,
      ),
      title: Text(
        productTitle,
      ),
    );
  }
}
