class Restaurant {
  final String id;
  final String name;
  final String city;
  final String description;
  final double rating;
  final String pictureId;

  Restaurant({
    required this.id,
    required this.name,
    required this.city,
    required this.description,
    required this.rating,
    required this.pictureId,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      description: json['description'],
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()
          : json['rating'] ?? 0.0, // ← FIX ERROR “int is not subtype of double”
      pictureId: json['pictureId'],
    );
  }
}
