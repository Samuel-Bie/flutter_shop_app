import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  Future<void> _loadOrders(context) async {
    try {
      Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    _loadOrders(context);
    final ordersProvider = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: Text('My Orders')),
      drawer: Drawer(
        child: AppDrawer(),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          _loadOrders(context);
        },
        child: ListView.builder(
          itemCount: ordersProvider.orders.length,
          itemBuilder: (BuildContext context, int index) {
            return OrderItemWidget(
              order: ordersProvider.orders[index],
            );
          },
        ),
      ),
    );
  }
}
