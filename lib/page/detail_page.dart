import 'package:flutter/material.dart';
import '../models/restaurant_detail.dart';
import '../models/restaurant_fav.dart';
import '../services/restaurant_service.dart';
import '../services/favorite_service.dart';

class DetailPage extends StatefulWidget {
  final String id;

  const DetailPage({super.key, required this.id});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final RestaurantService _restaurantService = RestaurantService();
  final FavoriteService _favoriteService = FavoriteService();

  // Variabel untuk menyimpan status favorit
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Cek apakah restoran ini sudah ada di daftar favorit saat halaman dibuka
    isFavorite = _favoriteService.isFavorite(widget.id);
  }

  void _toggleFavorite(RestaurantDetail restaurant) {
    setState(() {
      if (isFavorite) {
        // Jika sudah favorit, hapus dari favorit
        _favoriteService.removeFavorite(restaurant.id);
        isFavorite = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Dihapus dari favorit"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        // Jika belum, tambahkan ke favorit
        // Kita perlu mapping dari RestaurantDetail ke RestaurantFav (Model Hive)
        final favData = RestaurantFav(
          id: restaurant.id,
          name: restaurant.name,
          city: restaurant.city,
          rating: restaurant.rating,
          pictureId: restaurant.pictureId,
        );

        _favoriteService.addFavorite(favData);
        isFavorite = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Ditambahkan ke favorit"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RestaurantDetail>(
      future: _restaurantService.getDetail(widget.id),
      builder: (context, snapshot) {
        // 1. Tampilkan Loading jika data belum ada
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text("Loading...")),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. Tampilkan Error jika gagal mengambil data
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text("Detail Restaurant")),
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        // 3. Jika data berhasil diambil
        if (snapshot.hasData) {
          final RestaurantDetail r = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              title: Text(r.name),
              actions: [
                // --- ICON FAVORITE (KANAN ATAS) ---
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: () {
                    _toggleFavorite(r);
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ------------------- GAMBAR -------------------
                  Hero(
                    tag: r.id, // Efek animasi transisi gambar
                    child: Image.network(
                      "https://restaurant-api.dicoding.dev/images/large/${r.pictureId}",
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, error, _) => Container(
                        height: 250,
                        color: Colors.grey,
                        child: Center(child: Icon(Icons.broken_image)),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ------------------- NAMA & RATING -------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                r.name,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 20),
                                SizedBox(width: 4),
                                Text(
                                  r.rating.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "${r.city}, ${r.address}",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        // ------------------- DESKRIPSI -------------------
                        Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          r.description,
                          style: TextStyle(fontSize: 14, height: 1.5),
                          textAlign: TextAlign.justify,
                        ),

                        SizedBox(height: 20),

                        // ------------------- KATEGORI -------------------
                        Text(
                          "Categories",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: r.categories
                              .map(
                                (c) => Chip(
                                  label: Text(c),
                                  backgroundColor: Colors.blue.withOpacity(0.1),
                                ),
                              )
                              .toList(),
                        ),

                        SizedBox(height: 20),

                        // ------------------- MENU -------------------
                        Text(
                          "Foods",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildMenuList(r.foods),

                        SizedBox(height: 10),
                        Text(
                          "Drinks",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildMenuList(r.drinks),

                        SizedBox(height: 20),

                        // ------------------- CUSTOMER REVIEWS -------------------
                        Text(
                          "Customer Reviews",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        ...r.reviews.map(
                          (rev) => Card(
                            margin: EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(rev.name[0].toUpperCase()),
                              ),
                              title: Text(rev.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(rev.review),
                                  SizedBox(height: 4),
                                  Text(
                                    rev.date,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(body: Center(child: Text("No Data")));
      },
    );
  }

  // Helper widget untuk menampilkan list menu mendatar/simple
  Widget _buildMenuList(List<String> items) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(items[index]),
          );
        },
      ),
    );
  }
}
