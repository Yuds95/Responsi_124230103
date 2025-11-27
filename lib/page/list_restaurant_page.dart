import 'package:flutter/material.dart';
import '../services/restaurant_service.dart';
import '../models/restaurant_model.dart';
import '../services/auth_service.dart';

class ListRestaurantPage extends StatefulWidget {
  final String username;

  const ListRestaurantPage({super.key, required this.username});

  @override
  _ListRestaurantPageState createState() => _ListRestaurantPageState();
}

class _ListRestaurantPageState extends State<ListRestaurantPage> {
  final RestaurantService service = RestaurantService();
  final AuthService _authService = AuthService();

  late Future<List<Restaurant>> restaurantList;

  @override
  void initState() {
    super.initState();
    restaurantList = service.getRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello, ${widget.username}"),
        automaticallyImplyLeading: false, 
        leading: IconButton(
          icon: Icon(Icons.logout),
          tooltip: "Logout",
          onPressed: () async {
            await _authService.logout();
            
            // --- TAMBAHAN: Snackbar Logout ---
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Berhasil Logout"),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
              ),
            );

            Navigator.pushNamedAndRemoveUntil(
              context, 
              '/login', 
              (route) => false
            );
          },
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushNamed(context, "/favorite");
            },
          )
        ],
      ),

      body: FutureBuilder<List<Restaurant>>(
        future: restaurantList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      "https://restaurant-api.dicoding.dev/images/small/${r.pictureId}",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, error, _) => Container(
                        width: 60, 
                        height: 60, 
                        color: Colors.grey, 
                        child: Icon(Icons.broken_image)
                      ),
                    ),
                  ),
                  title: Text(r.name),
                  subtitle: Text("${r.city} • ⭐ ${r.rating}"),
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