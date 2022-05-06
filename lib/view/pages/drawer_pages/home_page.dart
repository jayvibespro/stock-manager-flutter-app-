import 'package:flutter/material.dart';

import '../bottom_navigation_bar_pages/conversation_page.dart';
import '../bottom_navigation_bar_pages/hesabu_page.dart';
import '../bottom_navigation_bar_pages/profile_page.dart';
import '../bottom_navigation_bar_pages/settings_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String title = 'Stocks Manager';
  int currentIndex = 0;
  final screens = [
    ConversationPage(),
    HesabuPage(),
    ProfilePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.black,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          if (currentIndex == 1) {
            setState(() {
              title = "Hesabu";
            });
          } else if (currentIndex == 2) {
            setState(() {
              title = "Profile";
            });
          } else if (currentIndex == 3) {
            setState(() {
              title = "Settings";
            });
          } else {
            setState(() {
              title = "Stocks Manager";
            });
          }
        },
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'hesabu',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'profile',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'settings',
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
