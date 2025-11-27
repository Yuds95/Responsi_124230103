import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();

  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _username,
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                bool success = await auth.login(
                  _username.text,
                  _password.text,
                );

                if (success) {
                  await auth.setLoggedIn(true);

                  Navigator.pushReplacementNamed(context, "/list",
                      arguments: _username.text);

                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Username atau password salah!"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text("Login"),
            ),

            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/register");
              },
              child: Text("Belum punya akun? Register"),
            )
          ],
        ),
      ),
    );
  }
}
