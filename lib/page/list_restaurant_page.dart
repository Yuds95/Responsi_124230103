import 'package:flutter/material.dart';
import '../services/restaurant_service.dart';
import '../models/restaurant_model.dart';

class ListRestaurantPage extends StatefulWidget {
  final String username;

  const ListRestaurantPage({required this.username});

  @override
  _ListRestaurantPageState createState() => _ListRestaurantPageState();
}

class _ListRestaurantPageState extends State<ListRestaurantPage> {
  final RestaurantService service = RestaurantService();

  late Future<List<Restaurant>> restaurantList;

  @override
  void initState() {
    restaurantList = service.getRestaurants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello, ${widget.username}"),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushNamed(context, "/favorite");
            },
          )
        ],
      ),

      body: FutureBuilder(
        future: restaurantList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text("Tidak ada data"));
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              final r = data[i];

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: ListTile(
                  leading: Image.network(
                    "https://restaurant-api.dicoding.dev/images/small/${r.pictureId}",
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(r.name),
                  subtitle: Text("${r.city} • ⭐ ${r.rating}"),

                  // -------------------- PENTING: BUKA DETAIL --------------------
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/detail",
                      arguments: r.id,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
