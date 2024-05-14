import 'package:ai_floorplan_test/view/pages/home_page.dart';
import 'package:ai_floorplan_test/view/pages/login_page.dart';
import 'package:ai_floorplan_test/view/pages/pages.dart';
import 'package:ai_floorplan_test/view/pages/register_page.dart';
import 'package:ai_floorplan_test/view/pages/splashscreen_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menonaktifkan banner debug
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash', // Tentukan rute awal sebagai splash screen
      routes: {
        '/splash': (context) => SplashScreen(), // Rute untuk splash screen
        '/home': (context) => HomeScreen(), // Rute untuk home screen
        '/gallery': (context) =>
            GalleryPage(title: 'Gallery'), // Rute untuk gallery page
        '/login': (context) => LoginPage(), // Rute untuk home screen
        '/register': (context) => RegisterPage(), // Rute untuk home screen
      },
    );
  }
}
