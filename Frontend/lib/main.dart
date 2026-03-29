import 'package:flutter/material.dart';
import 'service/api_service.dart';
import 'auth/signup_screen.dart';
import 'auth/login_screen.dart';
import 'screen/home_screen.dart';
import 'screen/free_fire_screen.dart';
import 'screen/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ ADD

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLogin") ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tournament App',
      theme: ThemeData.dark(),
      home: FutureBuilder(
        future: checkLogin(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return snapshot.data == true
              ? HomeScreen()
              : SignupScreen();
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/freefire': (context) => FreeFireTournamentsScreen(),
      },
    );
  }
}