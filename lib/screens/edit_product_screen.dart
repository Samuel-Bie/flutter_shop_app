import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:uuid/uuid.dart';
import 'package:validators/validators.dart';

import 'package:shop_app/providers/product.dart';
import 'package:shop_app/validators/validators.dart';

class EditproductScreen extends StatefulWidget {
  static const routeName = '/edit/product';
  @override
  _EditproductScreenState createState() => _EditproductScreenState();
}

class _EditproductScreenState extends State<EditproductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLFocusNode = FocusNode();
  final _imageURLController = TextEditingController();

  final titleValidator = MultiValidator([
    RequiredValidator(errorText: 'Title is required'),
    MinLengthValidator(4, errorText: 'Title must be at least 4 digits long'),
  ]);

  final _priceValidator = MultiValidator([
    RequiredValidator(errorText: 'Price is required'),
    PriceValidator(errorText: 'Enter a valid price'),
  ]);

  final _imageValidator = MultiValidator([
    RequiredValidator(errorText: 'Image URL is required'),
    UrlValidator(errorText: 'Enter a valid image url'),
  ]);

  Product targetProduct = Product(
    id: Uuid().v4(),
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );

  final form = GlobalKey<FormState>();

  @override
  void initState() {
    _imageURLFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void dispose() {
    _imageURLFocusNode.removeListener(_updateImageURL);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLFocusNode.dispose();
    super.dispose();
  }

  void _updateImageURL() {
    if (!_imageURLFocusNode.hasFocus) if (isURL(_imageURLController.text))
      setState(() {});
  }

  void saveForm() {
    if (form.currentState.validate()) {
      form.currentState.save();
      Provider.of<Products>(context, listen: false).addProduct(targetProduct);
      Navigator.pop(context);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: saveForm)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: form,
          autovalidate: true,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_priceFocusNode),
                  validator: titleValidator,
                  onSaved: (value) {
                    targetProduct = Product(
                      id: targetProduct.id,
                      title: value,
                      description: targetProduct.description,
                      price: targetProduct.price,
                      imageUrl: targetProduct.imageUrl,
                    );
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) => FocusScope.of(context)
                      .requestFocus(_descriptionFocusNode),
                  validator: _priceValidator,
                  onSaved: (value) {
                    targetProduct = Product(
                      id: targetProduct.id,
                      title: targetProduct.title,
                      description: targetProduct.description,
                      price: double.parse(value),
                      imageUrl: targetProduct.imageUrl,
                    );
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  validator: MinLengthValidator(4,
                      errorText: 'Description must be at least 4 digits long'),
                  onSaved: (value) {
                    targetProduct = Product(
                      id: targetProduct.id,
                      title: targetProduct.title,
                      description: value,
                      price: targetProduct.price,
                      imageUrl: targetProduct.imageUrl,
                    );
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: _imageURLController.text.isEmpty
                          ? Text('Enter a URL')
                          : FittedBox(
                              child: Image.network(_imageURLController.text),
                              fit: BoxFit.cover),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageURLController,
                        focusNode: _imageURLFocusNode,
                        validator: _imageValidator,
                        onFieldSubmitted: (_) => saveForm(),
                        onSaved: (value) {
                          targetProduct = Product(
                            id: targetProduct.id,
                            title: targetProduct.title,
                            description: targetProduct.description,
                            price: targetProduct.price,
                            imageUrl: value,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
