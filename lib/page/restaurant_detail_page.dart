import 'package:flutter/material.dart';
import 'package:responsii_103/models/restaurant_model.dart';
import '../services/restaurant_service.dart';
import '../services/favorite_service.dart';
import '../models/restaurant_fav.dart';


class DetailPage extends StatefulWidget {
  final String id;

  DetailPage({required this.id});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final RestaurantService service = RestaurantService();
  final FavoriteService favoriteService = FavoriteService();
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    isFav = favoriteService.isFavorite(widget.id);
  }

  void toggleFavorite() async {
    final r = await service.getDetail(widget.id);
    setState(() {
      if (isFav) {
        favoriteService.removeFavorite(r.id);
      } else {
        final fav = RestaurantFav(
          id: r.id,
          name: r.name,
          city: r.city,
          rating: r.rating,
          pictureId: r.pictureId,
        );
        favoriteService.addFavorite(fav);
      }
      isFav = !isFav;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurant Detail"),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : null ,
            ),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: FutureBuilder(
        future: service.getDetail(widget.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final r = snapshot.data as Restaurant;

          return SingleChildScrollView(
            child: Column(
              children: [
                Image.network(
                  "https://restaurant-api.dicoding.dev/images/large/${r.pictureId}",
                ),
                ListTile(
                  title: Text(r.name),
                  subtitle: Text("${r.city} • Rating ${r.rating}"),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(r.description),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
