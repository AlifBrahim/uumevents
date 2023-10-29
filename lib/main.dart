import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'pages/homepage.dart';
import 'pages/search_page.dart';
import 'pages/favorites_page.dart';
import 'pages/tickets_page.dart';
import 'pages/profile_page.dart';
import '../components/ticket/ticket_icon.dart';

// Import the LoginRequired widget from login_required.dart
import 'components/login_required.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const NavigationBarApp());
}
// Create a GlobalKey for the NavigationExample widget
final GlobalKey<_NavigationExampleState> navigationExampleKey =
GlobalKey<_NavigationExampleState>();

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Pass the GlobalKey to the NavigationExample widget
    return MaterialApp(home: NavigationExample(key: navigationExampleKey));
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
    // Check if the user is logged in
    final User? user = FirebaseAuth.instance.currentUser;

    switch (index) {
      case 0:
        return Homepage();
      case 1:
        return SearchPage();
      case 2:
      // Only show Page3 if the user is logged in, otherwise show LoginRequired
        return user != null ? FavoritesPage(key: page3Key) : LoginRequired();
      case 3:
      // Only show Page4 if the user is logged in, otherwise show LoginRequired
        return user != null ? TicketsPage() : LoginRequired();
      case 4:
      // Only show Page5 if the user is logged in, otherwise show LoginRequired
        return user != null ? ProfilePage() : LoginRequired();
      // case 5:
      //   return TicketUi();

      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
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
                // NavigationDestination(
                //   icon: Icon(Icons.tiktok),
                //   label: 'Account',
                // ),
              ],
            ),
          ),
          body: _buildPage(currentPageIndex),
        );
      },
    );
  }
}
