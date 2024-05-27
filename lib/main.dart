import 'package:ai_floorplan_test/view/pages/pages.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/splash', // Tentukan rute awal sebagai splash screen
      routes: {
        '/splash': (context) => const SplashScreen(), // Rute untuk splash screen
        '/home': (context) => const HomeScreen(), // Rute untuk home screen
        '/login': (context) => LoginPage(), // Rute untuk login screen
        '/register': (context) => RegisterPage(), // Rute untuk register screen
        '/gallery': (context) => const GalleryPage(), // Rute untuk gallery screen
        '/trashbin': (context) => const TrashbinPage(), // Rute untuk trashbin screen
      },
    );
  }
}
