class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final double rating;

  final List<String> categories;
  final List<String> foods;
  final List<String> drinks;
  final List<CustomerReview> reviews;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.rating,
    required this.categories,
    required this.foods,
    required this.drinks,
    required this.reviews,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      city: json['city'],
      address: json['address'],
      pictureId: json['pictureId'],
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()
          : json['rating'] ?? 0.0,

      categories: (json['categories'] as List)
          .map((e) => e['name'].toString())
          .toList(),

      foods: (json['menus']['foods'] as List)
          .map((e) => e['name'].toString())
          .toList(),

      drinks: (json['menus']['drinks'] as List)
          .map((e) => e['name'].toString())
          .toList(),

      reviews: (json['customerReviews'] as List)
          .map((e) => CustomerReview.fromJson(e))
          .toList(),
    );
  }
}

class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json['name'],
      review: json['review'],
      date: json['date'],
    );
  }
}
