import 'package:flutter/material.dart';

import 'package:shop_app/models/product.dart';

class ProductDetails extends StatefulWidget {
  static final routeName = '/product/show';
  Product product;

  ProductDetails({
    Key key,
    this.product,
  }) : super(key: key);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    this.widget.product = ModalRoute.of(context).settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.product.title),
      ),
    );
  }
}
