import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const rouuteName = '/user/products';

  Future<void> _refreshProducts(context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetproducts();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('My products'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () =>
                  Navigator.pushNamed(context, EditproductScreen.routeName))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return _refreshProducts(context);
        },
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: productProvider.items.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  UserProductItem(product: productProvider.items[index]),
                  Divider()
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
