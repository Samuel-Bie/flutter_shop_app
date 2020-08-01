import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  const CartItemWidget({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      key: ValueKey(item.id),
      onDismissed: (direction) {
        final cart = Provider.of<Cart>(context, listen: false);
        cart.removeItem(item);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(child: Text('\$${item.price}')),
              ),
            ),
            title: Text(item.product.title),
            subtitle: Text('\$${item.price * item.quant}'),
            trailing: Text('\$${item.quant} x'),
          ),
        ),
      ),
    );
  }
}
