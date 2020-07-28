import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductDetails extends StatelessWidget {
  static final routeName = '/product/show';
  Product product;

  Widget build(BuildContext context) {
    product = ModalRoute.of(context).settings.arguments as Product;
    product = Provider.of<ProductsProvider>(context).findByid(product.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
    );
  }
}
