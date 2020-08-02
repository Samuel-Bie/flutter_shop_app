import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/exceptions/http_exception.dart';
import 'package:uuid/uuid.dart';

import 'package:shop_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> cartItems;
  final DateTime datetime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.cartItems,
    @required this.datetime,
  });

  OrderItem copyWith({
    String id,
    double amount,
    List<CartItem> cartItems,
    DateTime datetime,
  }) {
    return OrderItem(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      cartItems: cartItems ?? this.cartItems,
      datetime: datetime ?? this.datetime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'cartItems': cartItems?.map((x) => x?.toMap())?.toList(),
      'datetime': datetime?.millisecondsSinceEpoch,
    };
  }

  static OrderItem fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OrderItem(
      id: map['id'],
      amount: map['amount'],
      cartItems: List<CartItem>.from(
          map['cartItems']?.map((x) => CartItem.fromMap(x))),
      datetime: DateTime.fromMillisecondsSinceEpoch(map['datetime']),
    );
  }

  String toJson() => json.encode(toMap());

  static OrderItem fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderItem(id: $id, amount: $amount, cartItems: $cartItems, datetime: $datetime)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OrderItem &&
        o.id == id &&
        o.amount == amount &&
        listEquals(o.cartItems, cartItems) &&
        o.datetime == datetime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        amount.hashCode ^
        cartItems.hashCode ^
        datetime.hashCode;
  }
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url = 'https://flutter-app-7798e.firebaseio.com/orders.json';
    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      List<OrderItem> tempList = [];
      data.forEach((key, value) {
        value['id'] = key;
        tempList.add(OrderItem.fromMap(value));
      });
      _orders = tempList;
      notifyListeners();
    } catch (e) {
      throw HttpExeception('Cannot place new order');
    }
  }

  Future<void> addOrder(List<CartItem> items, double total) async {
    final order = OrderItem(
      id: Uuid().v4(),
      amount: total,
      cartItems: items,
      datetime: DateTime.now(),
    );

    const url = 'https://flutter-app-7798e.firebaseio.com/orders.json';

    try {
      await http.post(url, body: order.toJson());
      _orders.insert(0, order);
      notifyListeners();
    } catch (e) {
      throw HttpExeception('Cannot place new order');
    }
  }
}
