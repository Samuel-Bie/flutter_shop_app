import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class ProductDetails extends StatelessWidget {
  static final routeName = '/product/show';

  Widget build(BuildContext context) {
    var product = ModalRoute.of(context).settings.arguments
        as Product; //Passing as Arguments
    product = Provider.of<Products>(context).findByid(product.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text(product.title,
                      style: Theme.of(context).textTheme.headline4),
                  Spacer(),
                  Text('\$${product.price}',
                      style: Theme.of(context).textTheme.headline6)
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
