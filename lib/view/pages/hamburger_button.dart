import 'package:ai_floorplan_test/data/response/status.dart';
import 'package:ai_floorplan_test/viewmodel/history_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HamburgerButton extends StatefulWidget {
  const HamburgerButton({Key? key}) : super(key: key);

  @override
  State<HamburgerButton> createState() => _HamburgerButtonState();
}

class _HamburgerButtonState extends State<HamburgerButton> {
  late HistoryViewModel historyViewModel;
  bool _isHistoryLoaded = false; // Track whether history is loaded

  @override
  void initState() {
    super.initState();
    historyViewModel = HistoryViewModel();
  }

  // Method to load history
  void loadHistory(bool isExpanded) {
    if (isExpanded && !_isHistoryLoaded) {
      historyViewModel.fetchhistoryList();
      _isHistoryLoaded = true; // Update the flag
    } else if (!isExpanded) {
      historyViewModel = HistoryViewModel(); // Reinitialize the ViewModel
      _isHistoryLoaded = false; // Reset the flag
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFF393E46), // Drawer background color
        child: SingleChildScrollView( // Use SingleChildScrollView
          child: Column( // Wrap the entire content with Column
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ListTile(
                title: Text(
                  'Gallery',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  // Action when Gallery is tapped
                },
              ),
              ListTile(
                title: Text(
                  'Trash Bin',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  // Action when Trash Bin is tapped
                },
              ),
              ExpansionTile(
                title: Text(
                  'History',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Color(0xFF393E46),
                // Load history when expanded
                onExpansionChanged: loadHistory,
                children: [
                  ChangeNotifierProvider<HistoryViewModel>(
                    create: (BuildContext context) => historyViewModel,
                    child: Consumer<HistoryViewModel>(
                      builder: (context, value, _) {
                        switch (value.HistoryList.status) {
                          case Status.loading:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          case Status.error:
                            var snackBar = SnackBar(
                              content: Text(
                                value.HistoryList.message.toString(),
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                            WidgetsBinding.instance!.addPostFrameCallback(
                              (_) => ScaffoldMessenger.of(context).showSnackBar(snackBar),
                            );
                            return Container();
                          case Status.completed:
                            return Container(
                              margin: const EdgeInsets.all(16),
                              child: ListView.builder(
                                shrinkWrap: true, // Ensure ListView takes only necessary space
                                physics: NeverScrollableScrollPhysics(), // Disable ListView scrolling
                                itemCount: value.HistoryList.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      value.HistoryList.data![index].chat!,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      // Action when history item is tapped
                                      Navigator.pop(context); // Close the drawer
                                      // Add your code to handle history item selection
                                    },
                                  );
                                },
                              ),
                            );
                          default:
                            return Container();
                        }
                      },
                    ),
                  ),
                ],
              ),
              // Setting Item
              ExpansionTile(
                title: Text(
                  'Setting',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Color(0xFF393E46),
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Change Email',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      // Action when Change Email is tapped
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Change Password',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      // Action when Change Password is tapped
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Log Out',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      // Action when Log Out is tapped
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}