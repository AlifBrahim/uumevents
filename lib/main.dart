import 'package:flutter/material.dart';
import 'pages/page1.dart';
import 'pages/page2.dart';
import 'pages/page3.dart';
import 'pages/page4.dart';
import 'pages/page5.dart';

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: NavigationExample());
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({Key? key}) : super(key: key);

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;
  Key page3Key = UniqueKey(); // Add a key for the Page3 widget

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return Page1();
      case 1:
        return Page2();
      case 2:
        return Page3(key: page3Key); // Pass the key to the Page3 widget
      case 3:
        return Page4();
      case 4:
        return Page5();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Material(
        elevation: 25.0,
        child: NavigationBar(
          elevation: 25.0,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          backgroundColor: Colors.white,
          height: 40,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
              if (index == 2) {
                page3Key = UniqueKey();
              }
            });
          },
          selectedIndex: currentPageIndex,
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            NavigationDestination(
              icon: Icon(Icons.width_full),
              label: 'Tickets',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_circle),
              label: 'Account',
            ),
          ],
        ),
      ),
      body: _buildPage(currentPageIndex),
    );
  }
}