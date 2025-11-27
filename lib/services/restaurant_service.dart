import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant_model.dart';
import '../models/restaurant_detail.dart';

class RestaurantService {
  final String baseUrl = "https://restaurant-api.dicoding.dev";

  // -------------------------------------------------------
  // 1. GET LIST RESTAURANTS
  // -------------------------------------------------------
  Future<List<Restaurant>> getRestaurants() async {
    final response = await http.get(Uri.parse("$baseUrl/list"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List restaurants = data['restaurants'];
      return restaurants.map((e) => Restaurant.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load restaurants");
    }
  }

  // -------------------------------------------------------
  // 2. GET DETAIL RESTAURANT  (UPDATE LENGKAP)
  // -------------------------------------------------------
  Future<RestaurantDetail> getDetail(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/detail/$id"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final restaurantData = data['restaurant'];

      return RestaurantDetail.fromJson(restaurantData);
    } else {
      throw Exception("Failed to load restaurant detail");
    }
  }

  // -------------------------------------------------------
  // 3. SEARCH RESTAURANT (UNTUK FILTER)
  // -------------------------------------------------------
  Future<List<Restaurant>> searchRestaurant(String query) async {
    final response = await http.get(Uri.parse("$baseUrl/search?q=$query"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List restaurants = data['restaurants'];
      return restaurants.map((e) => Restaurant.fromJson(e)).toList();
    } else {
      throw Exception("Failed to search restaurants");
    }
  }
}
