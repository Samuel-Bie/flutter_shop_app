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
      // appBar: AppBar(
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.title, textAlign: TextAlign.start,),
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
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text(product.title,
                        style: Theme.of(context).textTheme.headline5),
                    Spacer(),
                    Text('\$${product.price}',
                        style: Theme.of(context).textTheme.headline6)
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(product.description),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
