import 'package:flutter/material.dart';
import '../services/restaurant_service.dart';
import '../models/restaurant_detail.dart';

class DetailPage extends StatelessWidget {
  final String id;

  const DetailPage({required this.id});

  @override
  Widget build(BuildContext context) {
    final service = RestaurantService();

    return Scaffold(
      appBar: AppBar(title: Text("Detail Restaurant")),
      body: FutureBuilder<RestaurantDetail>(
        future: service.getDetail(id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final r = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ------------------- GAMBAR -------------------
                Image.network(
                  "https://restaurant-api.dicoding.dev/images/large/${r.pictureId}",
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ------------------- NAMA & RATING -------------------
                      Text(
                        r.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text("${r.city} • ${r.address}",
                          style: TextStyle(color: Colors.grey[700])),
                      SizedBox(height: 10),
                      Text("⭐ Rating: ${r.rating}", style: TextStyle(fontSize: 16)),

                      SizedBox(height: 20),

                      // ------------------- DESKRIPSI -------------------
                      Text(
                        "Deskripsi",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        r.description,
                        style: TextStyle(fontSize: 14, height: 1.4),
                        textAlign: TextAlign.justify,
                      ),

                      SizedBox(height: 25),

                      // ------------------- KATEGORI -------------------
                      Text(
                        "Kategori",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        spacing: 8,
                        children:
                            r.categories.map((c) => Chip(label: Text(c))).toList(),
                      ),

                      SizedBox(height: 20),

                      // ------------------- MENU MAKANAN -------------------
                      Text(
                        "Menu Makanan",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ...r.foods.map(
                        (food) => ListTile(
                          leading: Icon(Icons.restaurant_menu),
                          title: Text(food),
                        ),
                      ),

                      SizedBox(height: 20),

                      // ------------------- MENU MINUMAN -------------------
                      Text(
                        "Menu Minuman",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ...r.drinks.map(
                        (drink) => ListTile(
                          leading: Icon(Icons.local_drink),
                          title: Text(drink),
                        ),
                      ),

                      SizedBox(height: 20),

                      // ------------------- CUSTOMER REVIEW -------------------
                      Text(
                        "Customer Reviews",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ...r.reviews.map(
                        (rev) => Card(
                          child: ListTile(
                            title: Text(rev.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(rev.review),
                                SizedBox(height: 5),
                                Text(
                                  rev.date,
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
