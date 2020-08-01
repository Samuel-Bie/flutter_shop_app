import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

import 'package:shop_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.datetime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> items, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: Uuid().v4(),
        amount: total,
        products: items,
        datetime: DateTime.now(),
      ),
    );
    notifyListeners();
  }


}
