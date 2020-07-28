import 'package:flutter/material.dart';
import 'package:shop_app/widgets/product_grid_view_widget.dart';

class ProductsOverViewScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Shop')),
      body: ProductGrid(),
    );
  }
}
