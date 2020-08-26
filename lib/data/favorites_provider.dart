import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as Http;

import '../global/constants.dart';
import '../models/product.dart';

class FavoritesProvider with ChangeNotifier {
  final Set<String> _favorites = Set();

  Future<Set<String>> get favoritesIds async => _loadFavorites();

  Future<Set<String>> _loadFavorites() async {
    if (_favorites.isEmpty) {
      try {
        final response = await Http.get("${BASE_URL}favorites.json"); //
        final Map<String, dynamic> loadedData = json.decode(response.body);

        if (loadedData != null) {
          final list = (loadedData["ids"] as List<dynamic>) ?? [];
          list.forEach((item) => _favorites.add(item.toString()));
        }
      } catch (error) {
        throw error;
      }
    }

    return [..._favorites].toSet();
  }

  Future<bool> isFavorite(Product product) async => isFavoriteById(product.id);

  Future<bool> isFavoriteById(String id) async => (await _loadFavorites()).contains(id);

  Future<void> toggle(Product product) async =>
      (await isFavorite(product)) ? removeFromFavorites(product) : addToFavorites(product);

  Future<void> addToFavorites(Product product) => addToFavoritesById(product.id);

  Future<void> addToFavoritesById(String productId) async {
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

  Future<void> removeFromFavorites(Product product) => removeFromFavoritesById(product.id);

  Future<void> removeFromFavoritesById(String productId) async {
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
      "${BASE_URL}favorites.json",
      body: json.encode(
        {"ids": _favorites.toList(growable: false)},
      ),
    );
    if (response.statusCode >= 400) throw Exception();
  }
}
