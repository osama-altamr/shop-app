import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/productObj.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/editprodcut_screen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final globalKey = GlobalKey<FormState>();
  var _editedProduct = ProductObj(
    idType: '',
    id: null,
    discount: 0,
    priceAfDiscount: 0.0,
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );
  var _intialValues = {
    'title': '',
    'description': '',
    'price': 0.0,
  };
  List<String> categoryList = ['Mobile', 'Laptop', 'Watch', 'Headphone'];
  List<int> discountList = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
  int discount = 0;
  String category = 'Mobile';
  bool isLoading = false;
  bool _isInit = true;
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImage);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlController.removeListener(_updateImage);
    _imageUrlFocusNode.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImage() {
    if (_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              _imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.jpeg') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.png'))) {
        return;
      }
      setState(() {});
    }
  }

  Future _saveForm() async {
    if (!globalKey.currentState!.validate()) {
      return;
    }
    globalKey.currentState!.save();

    setState(() {
      isLoading = true;
    });
    try {
      if (_editedProduct.id == null) {
        await Provider.of<Products>(context, listen: false)
            .addProducts(_editedProduct, category, discount);
      } else {
        await Provider.of<Products>(context, listen: false).updateProduct(
            _editedProduct.id!, _editedProduct, category, discount);
      }
    } catch (e) {
      await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text('An error occurred '),
              content: Text('Something went wrong '),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Okay!'))
              ],
            );
          });
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      String? prodId = ModalRoute.of(context)!.settings.arguments as String?;
      if (prodId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(prodId);
        _intialValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price,
          'priceAfDiscount': _editedProduct.priceAfDiscount,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${_editedProduct.id == null ? 'Add Product' : 'Edit Product'}'),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: const Text('Note'),
                        content: const Text(
                            'Do you want to add any discount on the product ?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                showDialog(
                                    context: context,
                                    builder: (cyx) {
                                      return AlertDialog(
                                        content: Container(
                                          height: 60,
                                          padding:
                                              const EdgeInsets.only(left: 12),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                '$discount%',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              Spacer(),
                                              DropdownButton<int>(
                                                  underline: Container(),
                                                  icon: const Icon(
                                                    Icons.keyboard_arrow_down,
                                                    size: 30,
                                                  ),
                                                  items: discountList
                                                      .map(
                                                        (element) =>
                                                            DropdownMenuItem(
                                                          value: element,
                                                          child: Text(
                                                            '$element%',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      discount = val!;
                                                    });
                                                  }),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(cyx).pop();
                                                _saveForm();
                                              },
                                              child: Text('Okay!'))
                                        ],
                                      );
                                    });
                              },
                              child: Text('Yes')),
                          TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();

                                _saveForm();
                              },
                              child: Text('No')),
                        ],
                      );
                    });
              },
              icon: const Icon(
                Icons.save,
              )),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.purple,
              ),
            )
          : Padding(
              padding: EdgeInsets.all(
                10,
              ),
              child: Form(
                  key: globalKey,
                  child: ListView(
                    children: [
                      const Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Title',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextFormField(
                        initialValue: _intialValues['title'].toString(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey)),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please provide a value.';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _editedProduct = ProductObj(
                            idType: _editedProduct.idType,
                            id: _editedProduct.id,
                            title: val!,
                            discount: _editedProduct.discount,
                            priceAfDiscount: _editedProduct.priceAfDiscount,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                          );
                        },
                      ),
                      const Padding(
                        padding:
                            const EdgeInsets.only(left: 6.0, bottom: 9, top: 9),
                        child: Text(
                          'Price',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextFormField(
                        initialValue: _intialValues['price'].toString(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey)),
                        ),
                        focusNode: _priceFocusNode,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please enter a price.';
                          }
                          if (double.tryParse(val) == null) {
                            return 'Please enter a valid number.';
                          }
                          if (double.parse(val) <= 0) {
                            return 'Please enter a  number greater than Zero.';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _editedProduct = ProductObj(
                            idType: _editedProduct.idType,
                            id: _editedProduct.id,
                            discount: _editedProduct.discount,
                            priceAfDiscount: _editedProduct.priceAfDiscount,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(val!),
                            imageUrl: _editedProduct.imageUrl,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _intialValues['description'].toString(),
                        maxLines: 4,
                        focusNode: _descriptionFocusNode,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          label: Text(
                            'description',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please enter a description';
                          }
                          if (val.length < 10) {
                            return 'Should be at least 10 characters long';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _editedProduct = ProductObj(
                            idType: _editedProduct.idType,
                            id: _editedProduct.id,
                            discount: _editedProduct.discount,
                            title: _editedProduct.title,
                            description: val!,
                            price: _editedProduct.price,
                            priceAfDiscount: _editedProduct.priceAfDiscount,
                            imageUrl: _editedProduct.imageUrl,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 60,
                        padding: EdgeInsets.only(left: 12),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            Text(
                              '$category ',
                              style: TextStyle(fontSize: 18),
                            ),
                            Spacer(),
                            DropdownButton<String>(
                                underline: Container(),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 30,
                                ),
                                items: categoryList
                                    .map(
                                      (element) => DropdownMenuItem(
                                        value: element,
                                        child: Text(
                                          '$element',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    category = val!;
                                  });
                                }),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            margin: const EdgeInsets.only(top: 20, right: 10),
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                topLeft: Radius.circular(10),
                              ),
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ?const  Center(child: Text('Enter a URL'))
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                              child: TextFormField(
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            keyboardType: TextInputType.url,
                            decoration: const InputDecoration(
                              label: Text(
                                'Image URL',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter a image URL';
                              }
                              if (!val.startsWith('http') &&
                                  !val.startsWith('https')) {
                                return 'Please enter a valid URL';
                              }
                              if (!val.endsWith('.png') &&
                                  !val.endsWith('.jpg') &&
                                  !val.endsWith('.jpeg')) {
                                return 'Please enter a valid URL';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              _editedProduct = ProductObj(
                                idType: _editedProduct.idType,
                                id: _editedProduct.id,
                                discount: _editedProduct.discount,
                                title: _editedProduct.title,
                                priceAfDiscount: _editedProduct.priceAfDiscount,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: val!,
                              );
                            },
                          ))
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}

dialogShow(BuildContext ctx) {
  return showDialog(
      context: ctx,
      builder: (_) {
        return AlertDialog(
          title: Text('An Error Occurred!'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Okay!'))
          ],
        );
      });
}
