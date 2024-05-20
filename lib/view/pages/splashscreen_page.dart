import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Tunda navigasi ke halaman beranda selama 2 detik
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/register');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF222831),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'lib/assets/logo.svg',
              width: 171,
              height: 114,
            ),
            SizedBox(height: 24),
            Text(
              'AI Floorplan',
              style: TextStyle(
                fontSize: 32,
                color: Color(0xFFE1CDB5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}