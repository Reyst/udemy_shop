import 'package:flutter/foundation.dart';

import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _loadedProducts = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  final Set<String> _favorites = Set();

  List<Product> get loadedProducts => [..._loadedProducts];

  List<Product> get favoriteProducts => _loadedProducts.where((item) => _favorites.contains(item.id)).toList();

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
