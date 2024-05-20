import 'package:ai_floorplan_test/view/pages/hamburger_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        backgroundColor: Color(0xFF222831),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Color(0xFFE1CDB5),), // Icon hamburger
          onPressed: () {
            scaffoldkey.currentState!.openDrawer(); // Buka drawer saat ditekan
          },
        ),
        title: Text(
          'AI Floorplan',
          style: TextStyle(color: Color(0xFFE1CDB5)), // Change title text color
        ),
      ),
      backgroundColor: Color(0xFF222831),
      drawer: HamburgerButton(), //Drawer
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
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200],
                  ),
                  child: TextField(
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
                SizedBox(width: 16),
                Container(
                  width: 30,
                  height: 30,
                  child: FloatingActionButton(
                    onPressed: () {
                      // Camera function
                    },
                    child: Icon(Icons.camera_alt),
                    mini: true,
                    backgroundColor: Color(0xFFE1CDB5), // Color E1CDB5
                    shape: CircleBorder(),
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  width: 30,
                  height: 30,
                  child: FloatingActionButton(
                    onPressed: () {
                      // Mic function
                    },
                    child: Icon(Icons.mic),
                    mini: true,
                    backgroundColor: Color(0xFFE1CDB5), // Color E1CDB5
                    shape: CircleBorder(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
