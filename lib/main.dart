// main.dart
import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'splashpage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Solar PUMP',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Inter', // Vous pouvez utiliser Google Fonts
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}