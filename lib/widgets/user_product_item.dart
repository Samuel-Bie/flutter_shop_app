import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  const UserProductItem({Key key, @required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scafolld = Scaffold.of(context);
    return ListTile(
      title: Text(product.title),
      subtitle: Text(product.price.toStringAsFixed(2)),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () => Navigator.pushNamed(
                  context, EditproductScreen.routeName,
                  arguments: product),
              icon: Icon(
                Icons.edit,
                color: Colors.purple,
              ),
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .delete(product);
                } catch (e) {
                  print('here');
                  scafolld.showSnackBar(SnackBar(
                    content: Text('Failed to delete'),
                    duration: Duration(seconds: 2),
                  ));
                }
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
