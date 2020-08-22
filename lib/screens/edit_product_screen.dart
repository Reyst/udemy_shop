import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../data/products_provider.dart';
import '../models/product.dart';

class EditProductScreen extends StatefulWidget {
  static const String route = "/product-edit";

  final Product product;

  const EditProductScreen({this.product});

  EditProductScreen.forNavigation(BuildContext ctx) : this(product: _obtainRouteParameter(ctx));

  @override
  _EditProductScreenState createState() => _EditProductScreenState();

  static Product _obtainRouteParameter(BuildContext ctx) {
    try {
      return ModalRoute.of(ctx).settings.arguments as Product;
    } catch (e) {
      return null;
    }
  }
}

class _EditProductScreenState extends State<EditProductScreen> {
  bool _createFlag;

  String _title;
  String _description;
  double _price;
  String _imageUrl;

  final _formKey = GlobalKey<FormState>();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    _createFlag = widget.product == null;

    _title = widget.product?.title ?? "";
    _description = widget.product?.description ?? "";
    _imageUrl = widget.product?.imageUrl ?? "";
    _price = widget.product?.price ?? 0.0;

    _imageUrlController.text = _imageUrl;
    _imageUrlFocus.addListener(_updateImage);

    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocus.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenTitle = _createFlag ? "Add product" : "Edit product";

    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitle),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveProduct)],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  initialValue: _title,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) => _title = value,
                  validator: (value) {
                    if (value.isEmpty) return "Title can't be empty";
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  initialValue: _price == 0.0 ? "" : _price.toStringAsFixed(2),
//                  onChanged: (value) => _price = double.parse(value),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) => _price = double.parse(value),
                  validator: _validatePrice,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  initialValue: _description,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  onSaved: (value) => _description = value,
                  validator: _validateDescription,
                ),
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
                      child: _imageUrl.isEmpty
                          ? Text('Enter a URL')
                          : FittedBox(
                              child: Image.network(
                                _imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocus,
                        onEditingComplete: _saveProduct,
                        onSaved: (value) => _imageUrl = value,
                      ),
                    ),
                    IconButton(icon: Icon(Icons.clear), onPressed: _clearUrl),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _validatePrice(value) {
    if (value.isEmpty) return 'Please enter a price.';

    var price = double.tryParse(value);
    if (price == null) return 'Please enter a valid number.';
    if (price <= 0) return 'Please enter a number greater than zero.';

    return null;
  }

  String _validateDescription(String value) {
    if (value.isEmpty) return 'Please enter a description.';
    if (value.length < 10) return 'Description must be at least 10 characters long.';

    return null;
  }

  void _saveProduct() {
    var formState = _formKey.currentState;

    if (formState.validate()) {
      formState.save();

      final product = Product(
        id: _createFlag ? Uuid().v4().toUpperCase() : widget.product.id,
        title: _title,
        description: _description,
        imageUrl: _imageUrl,
        price: _price,
      );

      context.read<ProductProvider>().setProduct(product);
      Navigator.of(context).pop();
    }
  }

  void _updateImage() {
    if (!_imageUrlFocus.hasFocus)
      setState(() {
        _imageUrl = _imageUrlController.text;
      });
  }

  void _clearUrl() {
    setState(() {
      _imageUrl = "";
      _imageUrlController.text = "";
    });
  }
}
