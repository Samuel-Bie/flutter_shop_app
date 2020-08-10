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
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: 300.0,
              title: Text(product.title),
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: product.id,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(product.title,
                            style: Theme.of(context).textTheme.headline5),
                        // Spacer(),
                        Text('\$${product.price}',
                            style: Theme.of(context).textTheme.headline6),
                        Text(product.description)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
