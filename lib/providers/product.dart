import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toogleFavoriteStatus(String token, String userId) async {
    setFavorite(!this.isFavorite);
    final url =
        'https://flutter-app-7798e.firebaseio.com/users/$userId/favorites/${this.id}.json?auth=$token';
    try {
      final response = await http.put(
        url,
        body: jsonEncode(this.isFavorite),
      );
      if (response.statusCode >= 400) setFavorite(!this.isFavorite);
    } on Exception catch (e) {
      setFavorite(!this.isFavorite);
    }
  }

  void setFavorite(value) {
    this.isFavorite = value;
    notifyListeners();
  }

  Product copyWith({
    String id,
    String title,
    String description,
    double price,
    String imageUrl,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  static Product fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Product(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      price: map['price'],
      imageUrl: map['imageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  static Product fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product(id: $id, title: $title, description: $description, price: $price, imageUrl: $imageUrl ';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Product &&
        o.id == id &&
        o.title == title &&
        o.description == description &&
        o.price == price &&
        o.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        price.hashCode ^
        imageUrl.hashCode;
  }
}
