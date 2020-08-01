import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/orders.dart';

class OrderItemWidget extends StatelessWidget {
  final OrderItem order;

  const OrderItemWidget({Key key, @required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
              title: Text('\$${order.amount}'),
              subtitle: Text(DateFormat('dd/MM/yyyy hh:mm')
                  .format(order.datetime)
                  .toString()),
              trailing:
                  IconButton(icon: Icon(Icons.expand_more), onPressed: () {}))
        ],
      ),
    );
  }
}
