import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Simpan data saat register
  Future<bool> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();

    // Cek apakah username sudah terdaftar
    if (prefs.containsKey("username")) {
      return false;
    }

    await prefs.setString("username", username);
    await prefs.setString("password", password);
    return true;
  }

  // Login cek username & password
  Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();

    final savedUser = prefs.getString("username");
    final savedPass = prefs.getString("password");

    return (username == savedUser && password == savedPass);
  }

  // Cek apakah user sudah login
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLoggedIn") ?? false;
  }

  // Simpan status login
  Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", value);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("username");
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", false);
  }
}
