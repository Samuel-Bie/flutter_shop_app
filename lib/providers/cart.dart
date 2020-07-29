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
      total = total + value.quant * value.price;
    });
    return total;
  }

  void addItem(Product product, int quant) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (value) => CartItem(
          id: value.id,
          product: product,
          quant: (quant + value.quant),
          price: value.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
            id: DateTime.now().toString(),
            product: product,
            quant: quant,
            price: product.price),
      );
    }
    notifyListeners();
  }
}
