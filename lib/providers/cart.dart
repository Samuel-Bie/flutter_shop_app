import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:shop_app/providers/product.dart';

class CartItem {
  final String id;
  final Product product;
  final int quant;
  final double price;

  CartItem({
    @required this.id,
    @required this.product,
    @required this.quant,
    @required this.price,
  });

  CartItem copyWith({
    String id,
    Product product,
    int quant,
    double price,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quant: quant ?? this.quant,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product': product?.toMap(),
      'quant': quant,
      'price': price,
    };
  }

  static CartItem fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CartItem(
      id: map['id'],
      product: Product.fromMap(map['product']),
      quant: map['quant'],
      price: map['price'],
    );
  }

  String toJson() => json.encode(toMap());

  static CartItem fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'CartItem(id: $id, product: $product, quant: $quant, price: $price)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CartItem &&
      o.id == id &&
      o.product == product &&
      o.quant == quant &&
      o.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      product.hashCode ^
      quant.hashCode ^
      price.hashCode;
  }
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, value) {
      total += value.quant * value.price;
    });
    return total;
  }

  void addItem(Product product, int quant) {
    var newIten = null;
    if (_items.containsKey(product.id)) {
      newIten = _items.update(
        product.id,
        (value) => CartItem(
          id: value.id,
          product: product,
          quant: (quant + value.quant),
          price: value.price,
        ),
      );
    } else {
      newIten = _items.putIfAbsent(
        product.id,
        () => CartItem(
            id: DateTime.now().toString(),
            product: product,
            quant: quant,
            price: product.price),
      );
    }

    if (newIten.quant <= 0) this.removeItem(newIten);

    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item.product.id);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
