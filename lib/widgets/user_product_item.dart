import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  const UserProductItem({Key key, @required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {},
              icon: Icon(Icons.edit, color: Colors.purple,),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete, color: Colors.red,),
            )
          ],
        ),
      ),
    );
  }
}
