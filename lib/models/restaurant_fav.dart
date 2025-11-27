import 'package:hive/hive.dart';

part 'restaurant_fav.g.dart';

@HiveType(typeId: 0)
class RestaurantFav {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String city;

  @HiveField(3)
  final double rating;

  @HiveField(4)
  final String pictureId;

  RestaurantFav({
    required this.id,
    required this.name,
    required this.city,
    required this.rating,
    required this.pictureId,
  });
}
