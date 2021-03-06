import 'package:flutter/cupertino.dart';
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
    isFavorite: false,
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

  Future<void> saveForm() async {
    if (form.currentState.validate()) {
      form.currentState.save();
      setState(() {
        isLoading = true;
      });

      try {
        await Provider.of<Products>(context, listen: false)
            .updateList(targetProduct);
      } catch (e) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error occorred'),
            content: Text('Something went wrong'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              )
            ],
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
      }
    }
  }

  bool isInit = true;
  bool isEdit = true;
  bool isLoading = false;
  @override
  void didChangeDependencies() {
    if (isInit) {
      isInit = false;
      final args = ModalRoute.of(context).settings.arguments as Product;
      if (args != null) {
        targetProduct = args;
        isEdit = true;
        _imageURLController.text = targetProduct.imageUrl;
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isEdit ? const Text('Edit product') : const Text('Add product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: saveForm)
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : buildProductForm(context),
    );
  }

  Padding buildProductForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: form,
        // autovalidate: true,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_priceFocusNode),
                validator: titleValidator,
                initialValue: targetProduct.title,
                onSaved: (value) {
                  targetProduct = Product(
                    id: targetProduct.id,
                    title: value,
                    description: targetProduct.description,
                    price: targetProduct.price,
                    imageUrl: targetProduct.imageUrl,
                    isFavorite: targetProduct.isFavorite,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_descriptionFocusNode),
                validator: _priceValidator,
                initialValue: targetProduct.price.toString(),
                onSaved: (value) {
                  targetProduct = Product(
                    id: targetProduct.id,
                    title: targetProduct.title,
                    description: targetProduct.description,
                    price: double.parse(value),
                    imageUrl: targetProduct.imageUrl,
                    isFavorite: targetProduct.isFavorite,
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
                initialValue: targetProduct.description,
                onSaved: (value) {
                  targetProduct = Product(
                    id: targetProduct.id,
                    title: targetProduct.title,
                    description: value,
                    price: targetProduct.price,
                    imageUrl: targetProduct.imageUrl,
                    isFavorite: targetProduct.isFavorite,
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
                          isFavorite: targetProduct.isFavorite,
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
    );
  }
}
