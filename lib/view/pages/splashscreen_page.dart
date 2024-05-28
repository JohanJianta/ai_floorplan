part of 'pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Const.initializeCache();
    // Tunda navigasi ke halaman beranda selama 4 detik
    Future.delayed(const Duration(seconds: 4), () async {
      if (Const.userId != 0 && Const.auth.isNotEmpty) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/register');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222831),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'lib/assets/logo.svg',
              width: 171,
              height: 114,
            ),
            const SizedBox(height: 24),
            const Text(
              'AI Floorplan',
              style: TextStyle(
                fontSize: 32,
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE1CDB5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
