part of 'pages.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF222831),
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Color(0xFFE1CDB5),
          ), // Icon hamburger
          onPressed: () {
            scaffoldkey.currentState!.openDrawer(); // Buka drawer saat ditekan
          },
        ),
        title: const Text(
          'AI Floorplan',
          style: TextStyle(color: Color(0xFFE1CDB5)), // Change title text color
        ),
      ),
      backgroundColor: const Color(0xFF222831),
      drawer: const HamburgerButton(), //Drawer
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: SvgPicture.asset(
                'lib/assets/logo.svg',
                width: 70,
                height: 58,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 270,
                  height: 30,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200],
                  ),
                  child: const TextField(
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFE1CDB5), // Color E1CDB5
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your text here',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ClipOval(
                  child: Container(
                    color: const Color(0xFFE1CDB5),
                    width: 37,
                    height: 37,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt),
                      iconSize: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ClipOval(
                  child: Container(
                    color: const Color(0xFFE1CDB5),
                    width: 37,
                    height: 37,
                    child: IconButton(
                      onPressed: () {
                        // Mic function
                      },
                      icon: const Icon(Icons.mic),
                      iconSize: 22,
                      // mini: true,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
