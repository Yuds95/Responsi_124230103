import 'package:hive/hive.dart';
import '../models/restaurant_fav.dart';

class FavoriteService {
  final Box<RestaurantFav> box = Hive.box<RestaurantFav>('favorites');

  void addFavorite(RestaurantFav r) {
    box.put(r.id, r);
  }

  void removeFavorite(String id) {
    box.delete(id);
  }

  bool isFavorite(String id) {
    return box.containsKey(id);
  }

  List<RestaurantFav> getFavorites() {
    return box.values.toList();
  }
}
