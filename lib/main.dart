import 'package:ai_floorplan_test/view/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:ai_floorplan_test/view/pages/pages.dart';

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
        // '/splash': (context) => SplashScreen(), // Rute untuk splash screen
        // '/home': (context) => HomeScreen(), // Rute untuk home screen
        // '/login': (context) => LoginPage(), // Rute untuk home screen
        // '/register': (context) => RegisterPage(), // Rute untuk home screen
         '/gallery': (context) => const GalleryPage(title: 'Gallery'),
        '/trashbin': (context) => const TrashbinPage(title: 'Trash Bin'),
      },
    );
  }
}
