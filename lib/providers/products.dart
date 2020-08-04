import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shop_app/exceptions/http_exception.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/product.dart';

class Products with ChangeNotifier {
  final Auth authInfo;
  Products({this.authInfo, List<Product> items = const []}) {
    _items = items;
  }

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> updateList(Product product) async {
    final index = _items.indexWhere((element) => element.id == product.id);
    if (index == -1)
      return this._addProduct(product);
    else
      return this._updateProductAt(index, product);
  }

  Future<void> fetchAndSetproducts() async {
    final products =
        'https://flutter-app-7798e.firebaseio.com/products.json?auth=${authInfo.token}';

    final favorites =
        'https://flutter-app-7798e.firebaseio.com/users/${authInfo.userId}/favorites.json?auth=${authInfo.token}';
    try {
      final productsResponse = await http.get(products);

      final extratedData =
          jsonDecode(productsResponse.body) as Map<String, dynamic>;

      final favoritesResponse = await http.get(favorites);
      final favoriteExtratedData =
          jsonDecode(favoritesResponse.body) as Map<String, dynamic>;

      final List<Product> loadedProducts = [];

      if (productsResponse.statusCode == HttpStatus.accepted ||
          productsResponse.statusCode == HttpStatus.ok) {
        if (extratedData != null)
          extratedData.forEach((key, value) {
            value["id"] = key;
            loadedProducts.add(Product.fromMap(value)
              ..isFavorite = favoriteExtratedData == null ? false:favoriteExtratedData[key]??  false;
          });
      }

      _items = loadedProducts;
      notifyListeners();
    } on Exception catch (e) {
      // TODO
    }
  }

  Future<void> _addProduct(Product product) async {
    final url =
        'https://flutter-app-7798e.firebaseio.com/products.json?auth=${authInfo.token}';
    try {
      final response = await http.post(
        url,
        headers: {},
        body: product.toJson(),
      );

      final name = json.decode(response.body)["name"];
      final newProduct = Product(
        id: name,
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<void> _updateProductAt(index, Product product) async {
    final url =
        'https://flutter-app-7798e.firebaseio.com/products/${product.id}.json?auth=${authInfo.token}';
    try {
      await http.patch(
        url,
        headers: {},
        body: product.toJson(),
      );

      _items[index] = product;
      notifyListeners();
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<void> delete(Product product) async {
    final url =
        'https://flutter-app-7798e.firebaseio.com/products/${product.id}.json?auth=${authInfo.token}';

    final response = await http.delete(url);

    if (response.statusCode >= 400) throw HttpExeception('Product not found');
    _items.removeWhere((element) => element.id == product.id);
    notifyListeners();
  }

  Product findByid(String id) {
    return this.items.firstWhere((element) => element.id == id);
  }
}
