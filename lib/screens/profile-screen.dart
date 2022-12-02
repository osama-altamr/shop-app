import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/screens/your_products.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(
            left: 15,
            top: 100,
            right: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 60,
                    backgroundImage: NetworkImage(
                        'https://cdn.pixabay.com/photo/2016/12/19/21/36/woman-1919143_960_720.jpg'),
                    // foregroundImage: AssetImage(''),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Center(
                    child: Text(
                  'Lydia Montgome',
                  style: TextStyle(fontSize: 20),
                )),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      YourProducts.routeName,
                    );
                  },
                  child: const Card(
                    shadowColor: Colors.deepOrange,
                    elevation: 1,
                    child: ListTile(
                      title: Text('Your Products'),
                      trailing: Icon(Icons.arrow_forward),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 12),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      EditProductScreen.routeName,
                    );
                  },
                  child: const Card(
                    shadowColor: Colors.deepOrange,
                    elevation: 1,
                    child: ListTile(
                      trailing: Icon(Icons.add),
                      title: Text('Add Product'),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 12),
                child: GestureDetector(
                  onTap: () {},
                  child: const Card(
                    shadowColor: Colors.deepOrange,
                    elevation: 1,
                    child: ListTile(
                      trailing: Icon(Icons.question_mark_rounded),
                      title: Text('About Us'),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(top: 40),
                child: GestureDetector(
                  onTap: () async {
                    Navigator.of(context)
                        .pushNamed(ProductOverviewScreen.routeName);
                    Provider.of<Auth>(context, listen: false).logout();
                  },
                  child: const Card(
                    shadowColor: Colors.deepOrange,
                    elevation: 1,
                    child: ListTile(
                      trailing: Icon(Icons.power_settings_new),
                      title: Text('Signout'),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
