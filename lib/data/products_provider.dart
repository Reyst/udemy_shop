import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as Http;

import '../global/constants.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _loadedProducts = [];

  Future<List<Product>> get loadedProducts async => await _loadProducts();

  Future<List<Product>> _loadProducts() async {
//    if (_loadedProducts.isEmpty) {

    _loadedProducts.clear();
    try {
      final response = await Http.get("${BASE_URL}products.json"); //
      final Map<String, dynamic> loadedData = json.decode(response.body);

      loadedData.entries
          .map(
            (productEntry) => Product(
              id: productEntry.key,
              title: productEntry.value['title'],
              description: productEntry.value['description'],
              price: productEntry.value['price'],
              imageUrl: productEntry.value['imageUrl'],
            ),
          )
          .forEach((product) => _loadedProducts.add(product));
    } catch (error) {
      throw error;
    }
//    }

    return [..._loadedProducts];
  }

  Future<void> removeProduct(Product product) async {
    try {

      final url = "${BASE_URL}products/${product.id}.json";
      await Http.delete(url);

      _loadedProducts.removeWhere((item) => item.id == product.id);
      notifyListeners();
    } catch (error) {}
  }

  Future<void> setProduct(Product product) async {
    try {
      Product updatedProduct;
      if (product.id == null)
        updatedProduct = await _postNewProduct(product);
      else
        updatedProduct = await _updateProduct(product);

      final index = _loadedProducts.indexWhere((item) => item.id == updatedProduct.id);

      if (index == -1) _loadedProducts.add(updatedProduct);
      else _loadedProducts[index] = updatedProduct;

      notifyListeners();
    } catch (error) {}
  }

  Future<Product> _postNewProduct(Product product) async {
    final url = "${BASE_URL}products.json";

    final response = await Http.post(
      url,
      body: _encodeProduct(product),
    );

    final data = json.decode(response.body);

    return Product(
      id: data['name'],
      title: product.title,
      description: product.description,
      imageUrl: product.imageUrl,
      price: product.price,
    );
  }

  Future<Product> _updateProduct(Product product) async {
    final url = "${BASE_URL}products/${product.id}.json";

    await Http.patch(
      url,
      body: _encodeProduct(product),
    );

    return product;
  }

  String _encodeProduct(Product product) {
    return json.encode(
      {
        "title": product.title,
        "description": product.description,
        "price": product.price,
        "imageUrl": product.imageUrl,
      },
    );
  }
}
