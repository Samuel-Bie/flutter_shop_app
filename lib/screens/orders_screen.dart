import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(title: Text('My Orders')),
      drawer: Drawer(
        child: AppDrawer(),
      ),
      body: ListView.builder(
        itemCount: ordersProvider.orders.length,
        itemBuilder: (BuildContext context, int index) {
          return OrderItemWidget(
            order: ordersProvider.orders[index],
          );
        },
      ),
    );
  }
}
