import 'package:flutter/foundation.dart';

import '../models/product.dart';

class FavoritesProvider with ChangeNotifier {
  final Set<String> _favorites = Set();

  bool isFavorite(Product product) => isFavoriteById(product.id);

  bool isFavoriteById(String id) => _favorites.contains(id);

  void toggle(Product product) => isFavorite(product) ? removeFromFavorites(product) : addToFavorites(product);

  void addToFavorites(Product product) => addToFavoritesById(product.id);

  void addToFavoritesById(String productId) {
    if (_favorites.add(productId)) {
      notifyListeners();
    }
  }

  void removeFromFavorites(Product product) => removeFromFavoritesById(product.id);

  void removeFromFavoritesById(String productId) {
    if (_favorites.remove(productId)) {
      notifyListeners();
    }
  }
}
