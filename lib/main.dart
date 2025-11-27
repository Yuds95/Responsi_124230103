import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/restaurant_fav.dart';
import 'page/login_page.dart';
import 'page/register_page.dart';
import 'page/list_restaurant_page.dart';
import 'page/detail_page.dart';
import 'page/favorite_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Inisialisasi Hive untuk Flutter
    await Hive.initFlutter();

    // Daftarkan adapter jika belum terdaftar (typeId pada model harus 0)
    // NOTE: RestaurantFavAdapter harus sudah digenerate (lihat langkah di bawah)
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(RestaurantFavAdapter());
    }

    // Buka box 'favorites'
    await Hive.openBox<RestaurantFav>('favorites');
  } catch (e, st) {
    debugPrint('Hive init error: $e');
    debugPrint('$st');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',

      // Gunakan onGenerateRoute sehingga kita bisa meng-handle arguments dengan aman
      onGenerateRoute: (RouteSettings settings) {
        final name = settings.name;
        final args = settings.arguments;

        switch (name) {
          case '/login':
            return MaterialPageRoute(builder: (_) =>  LoginPage());

          case '/register':
            return MaterialPageRoute(builder: (_) =>  RegisterPage());

          case '/list':
            // Pastikan username adalah String; jika tidak, beri empty string
            final username = (args is String) ? args : '';
            return MaterialPageRoute(
              builder: (_) => ListRestaurantPage(username: username),
              settings: settings,
            );

          case '/detail':
            // Pastikan id adalah String; jika tidak, beri empty string
            final id = (args is String) ? args : '';
            return MaterialPageRoute(
              builder: (_) => DetailPage(id: id),
              settings: settings,
            );

          case '/favorite':
            return MaterialPageRoute(builder: (_) =>  FavoritePage());

          default:
            // Route tidak dikenal -> tampilkan halaman fallback sederhana
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(title: const Text('Not Found')),
                body: const Center(child: Text('Halaman tidak ditemukan')),
              ),
            );
        }
      },
    );
  }
}

