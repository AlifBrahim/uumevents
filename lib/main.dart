import 'package:flutter/material.dart';
import 'pages/page1.dart';
import 'pages/page2.dart';
import 'pages/page3.dart';
import 'pages/page4.dart';
import 'pages/page5.dart';

/// Flutter code sample for [NavigationBar].

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: NavigationExample());
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;
  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return Page1();
      case 1:
        return Page2();
      case 2:
        return Page3();
      case 3:
        return Page4();
      case 4:
        return Page5();
    // Add cases for other pages as needed
      default:
        return Container(); // Handle an invalid index gracefully
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 4.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: NavigationBar(
          backgroundColor: Colors.white,
          height: 50,
          elevation: 1000,
          shadowColor: Colors.red,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.amber[800],
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.search),
              selectedIcon: Icon(Icons.search_outlined),
              label: '',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.favorite),
              icon: Icon(Icons.favorite_border),
              label: '',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.width_full),
              icon: Icon(Icons.width_full_outlined),
              label: '',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.account_circle),
              icon: Icon(Icons.account_circle_outlined),
              label: '',
            ),
          ],
        ),
      ),
      body: _buildPage(currentPageIndex),
    );
  }
}