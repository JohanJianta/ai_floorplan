import 'package:ai_floorplan_test/shared/shared.dart';
import 'package:ai_floorplan_test/themes.dart';
import 'package:ai_floorplan_test/view/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Const.instance,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Const>(
      builder: (context, constInstance, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          themeMode: Const.themeMode,
          theme: ThemeClass.lightTheme,
          darkTheme: ThemeClass.darkTheme,
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/home': (context) => const HomeScreen(),
            '/login': (context) => LoginPage(),
            '/register': (context) => RegisterPage(),
            '/gallery': (context) => const GalleryPage(),
            '/trashbin': (context) => const TrashbinPage(),
          },
        );
      },
    );
  }
}
