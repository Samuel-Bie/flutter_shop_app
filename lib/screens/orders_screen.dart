import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  Future<dynamic> _loadOrders(context) async {
    try {
      Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Orders')),
      drawer: Drawer(
        child: AppDrawer(),
      ),
      body: RefreshIndicator(
          onRefresh: () {
            return _loadOrders(context);
          },
          child: FutureBuilder(
            future:
                Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              else {
                if (snapshot.error != null) {
                  return Center(child: Text('Error fetching orders'));
                } else {
                  return Consumer<Orders>(
                    builder:
                        (BuildContext context, ordersProvider, Widget child) {
                      return ListView.builder(
                        itemCount: ordersProvider.orders.length,
                        itemBuilder: (BuildContext context, int index) {
                          return OrderItemWidget(
                            order: ordersProvider.orders[index],
                          );
                        },
                      );
                    },
                  );
                }
              }
            },
          )),
    );
  }
}
