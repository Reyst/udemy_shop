import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as Http;
import 'package:udemy_shop/models/token.dart';

import '../global/constants.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {

  String _authKey;
  String _userId;

  set token(Token token) {
    _authKey = token?.idToken;
    _userId = token?.userId;
    if (_authKey != null) fetchData();
  }

  final List<Product> _loadedProducts = [];
  final Set<String> _favorites = Set();

  List<Product> get loadedProducts => [..._loadedProducts];

  List<Product> get favoriteProducts =>
      _loadedProducts.where((product) => _favorites.contains(product.id)).toList(growable: false);

  Future<void> fetchData() async {

    try {
      final prods = await _loadProducts();
      _loadedProducts.clear();
      _loadedProducts.addAll(prods);

      final favorites = await _loadFavorites();
      _favorites.clear();
      _favorites.addAll(favorites);
    } catch (error) {
      throw error;
    } finally {
      notifyListeners();
    }
  }

  Future<Set<String>> _loadFavorites() async {
    final Set<String> result = Set();
    final response = await Http.get("${BASE_URL}favorites.json?auth=$_authKey"); //

    if (response.statusCode >= 400) throw Exception();

    final Map<String, dynamic> loadedData = json.decode(response.body);

    if (loadedData != null && _userId != null) {
      final list = (loadedData[_userId] as List<dynamic>) ?? [];
      list.forEach((item) => result.add(item.toString()));
    }

    return result;
  }

  Future<List<Product>> _loadProducts() async {
    final List<Product> result = [];
    final response = await Http.get("${BASE_URL}products.json?auth=$_authKey"); //

    if (response.statusCode >= 400) throw Exception();

    final Map<String, dynamic> loadedData = json.decode(response.body);

    loadedData.entries
        .map((productEntry) => Product(
              id: productEntry.key,
              title: productEntry.value['title'],
              description: productEntry.value['description'],
              price: productEntry.value['price'],
              imageUrl: productEntry.value['imageUrl'],
            ))
        .forEach((product) => result.add(product));

    return result;
  }

  Future<void> removeProduct(Product product) async {
    final index = _loadedProducts.indexWhere((p) => p.id == product.id);

    try {
      final url = "${BASE_URL}products/${product.id}.json?auth=$_authKey";
      final response = await Http.delete(url);
      if (response.statusCode >= 400) throw Exception();
      _loadedProducts.removeWhere((item) => item.id == product.id);
    } catch (error) {
      _loadedProducts.insert(index, product);
    } finally {
      notifyListeners();
    }
  }

  Future<void> setProduct(Product product) async {
    try {
      Product updatedProduct;
      if (product.id == null)
        updatedProduct = await _postNewProduct(product);
      else
        updatedProduct = await _updateProduct(product);

      final index = _loadedProducts.indexWhere((item) => item.id == updatedProduct.id);

      if (index == -1)
        _loadedProducts.add(updatedProduct);
      else
        _loadedProducts[index] = updatedProduct;

      notifyListeners();
    } catch (error) {}
  }

  Future<Product> _postNewProduct(Product product) async {
    final url = "${BASE_URL}products.json?auth=$_authKey";

    final response = await Http.post(
      url,
      body: _encodeProduct(product),
    );

    if (response.statusCode >= 400) throw Exception();

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
    final url = "${BASE_URL}products/${product.id}.json?auth=$_authKey";

    final response = await Http.patch(
      url,
      body: _encodeProduct(product),
    );
    if (response.statusCode >= 400) throw Exception();

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

  bool isFavorite(Product product) => isFavoriteById(product.id);

  bool isFavoriteById(String id) => _favorites.contains(id);

  Future<void> toggle(Product product) async {
    return isFavorite(product) ? _removeFromFavorites(product) : _addToFavorites(product);
  }

  Future<void> _addToFavorites(Product product) => _addToFavoritesById(product.id);

  Future<void> _addToFavoritesById(String productId) async {
    if (_favorites.add(productId)) {
      try {
        await _updateRemoteFavorites();
      } catch (error) {
        _favorites.remove(productId);
      } finally {
        notifyListeners();
      }
    }
  }

  Future<void> _removeFromFavorites(Product product) => _removeFromFavoritesById(product.id);

  Future<void> _removeFromFavoritesById(String productId) async {
    if (_favorites.remove(productId)) {
      try {
        await _updateRemoteFavorites();
      } catch (error) {
        _favorites.add(productId);
      } finally {
        notifyListeners();
      }
    }
  }

  Future _updateRemoteFavorites() async {
    final response = await Http.patch(
      "${BASE_URL}favorites.json?auth=$_authKey",
      body: json.encode(
        {_userId: _favorites.toList(growable: false)},
      ),
    );
    if (response.statusCode >= 400) throw Exception();
  }
}
