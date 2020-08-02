import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item.dart';
import 'package:toast/toast.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isPlacingOder = false;

  Future<void> _placeOrder() async {
    final orders = Provider.of<Orders>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    try {
      setState(() {
        _isPlacingOder = true;
      });
      await orders.addOrder(cart.items.values.toList(), cart.totalAmount);
      cart.clearCart();
    } catch (e) {
      Toast.show("Cannot place the order now", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }

    setState(() {
      _isPlacingOder = false;
    });
  }

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
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  BtnPlaceOrder(
                      isPlacingOder: _isPlacingOder, placeOrder: _placeOrder)
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

class BtnPlaceOrder extends StatelessWidget {
  final bool isPlacingOder;
  final Function placeOrder;

  const BtnPlaceOrder({Key key, this.isPlacingOder, this.placeOrder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return FlatButton(
      onPressed: (cart.items.length <= 0 || isPlacingOder) ? null : placeOrder,
      child: cart.items.length <= 0
          ? Text(
              'Empty cart',
            )
          : isPlacingOder
              ? Center(child: CircularProgressIndicator())
              : Text(
                  'ORDER NOW',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
    );
  }
}
