import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';

import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext _) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (BuildContext _, value, previousPrdProvider) =>
              Products(authInfo: value, items: previousPrdProvider.items),
          create: (BuildContext _) => Products(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext _) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (BuildContext _, Auth value, Orders __) => Orders(
            authInfo: value,
          ),
          create: (BuildContext _) => Orders(),
        ),
      ],
      child: Consumer<Auth>(builder: (ctx, authData, child) {
        return MaterialApp(
          title: 'Shop App',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.orange,
            fontFamily: 'Lato',
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: authData.isAuthenticated
              ? ProductsOverViewScreen()
              : AuthScreen(),
          routes: {
            ProductDetails.routeName: (ctx) => ProductDetails(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.rouuteName: (ctx) => UserProductsScreen(),
            EditproductScreen.routeName: (ctx) => EditproductScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
          },
        );
      }),
    );
  }
}
