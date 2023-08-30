import 'package:flutter/material.dart';
import '../login/Screens/Login/login_screen.dart';

class LoginRequired extends StatelessWidget {
  const LoginRequired({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You must be logged in to access this page.',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to the LoginScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text('Go to Login'),
          ),
        ],
      ),
    );
  }
}
