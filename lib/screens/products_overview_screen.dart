import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/product_grid_view_widget.dart';

enum FilterOptions { Favorites, All }

class ProductsOverViewScreen extends StatefulWidget {
  @override
  _ProductsOverViewScreenState createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectdValue) {
              if (FilterOptions.Favorites == selectdValue)
                setState(() {
                  _showOnlyFavorites = true;
                });
              // products.showFavoritesOnly();
              else if (FilterOptions.All == selectdValue)
                setState(() {
                  _showOnlyFavorites = false;
                });
              // products.showAll();
            },
            itemBuilder: (BuildContext _) => [
              PopupMenuItem(
                child: Text('Only favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: FilterOptions.All,
              ),
            ],
            icon: Icon(
              Icons.more_vert,
            ),
          )
        ],
      ),
      body: ProductGrid(_showOnlyFavorites),
    );
  }
}
