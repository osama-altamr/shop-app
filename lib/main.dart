import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/productObj.dart';
import 'package:shop_app/providers/product_type.dart';
import 'package:shop_app/providers/products.dart';

import 'package:shop_app/screens/auth_screen/login.dart';
import 'package:shop_app/screens/auth_screen/sign_up.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/favorite_screen.dart';
import 'package:shop_app/screens/navigation_screen/home_page.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/prodcuts_screen.dart';
import 'package:shop_app/screens/product_detial_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/your_products.dart';

import 'screens/profile-screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(
        value: Auth(),
      ),
      ChangeNotifierProvider.value(
        value: ProductTypeProvider(),
      ),
      ChangeNotifierProvider.value(
        value: ProductObj(
          id: '',
          discount: 0,
          priceAfDiscount: 0,
          description: '',
          price: 0,
          imageUrl: '',
          idType: '',
          title: '',
        ),
      ),
      ChangeNotifierProxyProvider<Auth, Products>(
        create: (_) => Products(),
        update: (ctx, authVal, prevProducts) => prevProducts!
          ..getData(authVal.token!, authVal.userId!, prevProducts.items),
      ),
      ChangeNotifierProxyProvider<Auth, Orders>(
        create: (_) => Orders(),
        update: (ctx, authVal, prevOrders) => prevOrders!
          ..getData(authVal.token!, authVal.userId!, prevOrders.orders),
      ),
      ChangeNotifierProvider.value(
        value: Cart(),
      ),
    ],
    child: const SplashScreen(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.purple, fontFamily: 'Lato'),
     home: HomePage(),
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        HomePage.routeName: (_) => const ProductOverviewScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        SignUpScreen.routeName: (_) => SignUpScreen(),
        ProductOverviewScreen.routeName: (_) => const ProductOverviewScreen(),
        ProductsScreen.routeName: (_) => const ProductsScreen(),
        ProductDetialScreen.routeName: (_) => const ProductDetialScreen(),
        CartScreen.routeName: (_) => CartScreen(),
        OrderScreen.routeName: (_) => OrderScreen(),
        ProfileScreen.routeName: (_) => ProfileScreen(),
        EditProductScreen.routeName: (_) => EditProductScreen(),
        FavoriteScreen.routeName: (_) => FavoriteScreen(),
        YourProducts.routeName: (_) => YourProducts(),
      },
    );
  }
}
