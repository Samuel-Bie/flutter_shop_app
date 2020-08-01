import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Your cart')),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    shape: null,
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      '\$${cart.totalAmount}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {},
                    child: Text('ORDER NOW',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (BuildContext context, int index) {
                final cIten = cart.items.values.toList()[index];
                return CartItemWidget(item: cIten);
              },
            ),
          )
        ],
      ),
    );
  }
}
