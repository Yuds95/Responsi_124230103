import 'package:flutter/material.dart';
import '../services/favorite_service.dart';
import '../models/restaurant_fav.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final FavoriteService favoriteService = FavoriteService();

  @override
  Widget build(BuildContext context) {
    List<RestaurantFav> favorites = favoriteService.getFavorites().cast<RestaurantFav>();

    return Scaffold(
      appBar: AppBar(title: Text("Favorite Restaurants")),
      body: favorites.isEmpty
          ? Center(child: Text("Belum ada restaurant favorit"))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final r = favorites[index];

                return ListTile(
                  leading: Image.network(
                    "https://restaurant-api.dicoding.dev/images/small/${r.pictureId}",
                    width: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, error, _) => Icon(Icons.broken_image),
                  ),
                  title: Text(r.name),
                  subtitle: Text("${r.city} • Rating ${r.rating}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      favoriteService.removeFavorite(r.id);
                      setState(() {}); // Refresh UI

                      // --- TAMBAHAN: Snackbar Hapus Favorit ---
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${r.name} dihapus dari favorit"),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/detail', arguments: r.id);
                  },
                );
              },
            ),
    );
  }
}