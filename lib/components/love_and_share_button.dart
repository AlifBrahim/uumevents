// love_and_share_button.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'event_class.dart';
import '../login/Screens/Login/login_screen.dart';
import '/pages/profile_page.dart';
import '/functions/get_user_profile.dart';

class LoveAndShareButton extends StatefulWidget {
  final Event event;

  LoveAndShareButton(this.event);

  @override
  _LoveAndShareButtonState createState() => _LoveAndShareButtonState();
}

class _LoveAndShareButtonState extends State<LoveAndShareButton> {
  bool isLoved = false;
  bool isLoggedIn = false;
  bool hasAccount = false;

  @override
  void initState() {
    super.initState();
    checkIfEventIsFavourite();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        isLoggedIn = user != null;
      });
      checkIfUserHasAccount();
    });
  }

  Future<void> checkIfEventIsFavourite() async {
    final profile = await getUserProfile(); // Call the getUserProfile method

    try {
      final response =
      await http.get(Uri.parse('http://146.190.102.198:3001/favorites?matric_no=${profile?['matric_no']}'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final favouriteEvents =
        data.map((eventData) => Event.fromJson(eventData)).toList();
        setState(() {
          isLoved = favouriteEvents.any((event) => event.id == widget.event.id);
        });
      } else {
        print(
            'Failed to load favourite events. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error checking if event is favourite: $error');
    }
  }

  Future<void> checkIfUserHasAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final response =
        await http.get(Uri.parse('http://146.190.102.198:3001/profiles'));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          final profile =
          data.firstWhere((profile) => profile['uid'] == user.uid, orElse: () => null);
          setState(() {
            hasAccount = profile != null;
          });
        } else {
          print(
              'Failed to load profiles. Status code: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('Error checking if user has account: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () async {
            if (isLoggedIn && hasAccount) {
              setState(() {
                isLoved = !isLoved;
              });
              if (isLoved) {
                final profile = await getUserProfile(); // Call the getUserProfile method
                // Send a POST request to the server to add the event to the user's favourites
                try {
                  if (profile != null) { // Check if a profile was returned
                    final response = await http.post(
                      Uri.parse('http://146.190.102.198:3001/favorites'),
                      body: json.encode({
                        'event_id': widget.event.id,
                        'matric_no': profile['matric_no'], // Use the matric_no value from the profile
                      }),
                      headers: {
                        'Content-Type': 'application/json',
                      },
                    );
                    if (response.statusCode == 200) {
                      print('Successfully added event to favourites');
                    } else {
                      print(
                          'Failed to add event to favourites. Status code: ${response.statusCode}');
                    }
                  }
                } catch (error) {
                  print('Error adding event to favourites: $error');
                }
              } else {
                // Send a DELETE request to the server to remove the event from the user's favourites
                try {
                  final profile = await getUserProfile(); // Call the getUserProfile method

                  final response = await http.delete(
                    Uri.parse('http://146.190.102.198:3001/favorites/${widget.event.id}/${profile?['matric_no']}'),
                    headers: {
                      'Content-Type': 'application/json',
                    },
                  );
                  if (response.statusCode == 200) {
                    print('Successfully removed event from favourites');
                  } else {
                    print(
                        'Failed to remove event from favourites. Status code: ${response.statusCode}');
                  }
                } catch (error) {
                  print('Error removing event from favourites: $error');
                }
              }
            } else if (!hasAccount && isLoggedIn){
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text("You haven't created an account yet."),
                  content:
                  Text('Please create an account to like events.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      ),
                      child: Text('Create account'),
                    ),
                  ],
                ),
              );
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text('Not logged in'),
                  content:
                  Text('Please log in or sign up to use this feature.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      ),
                      child: Text('Log in'),
                    ),
                  ],
                ),
              );
            }
          },
          child: Icon(
            isLoved ? Icons.favorite : Icons.favorite_border,
            color: isLoved ? Colors.red : Colors.grey,
            size: 24,
          ),
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: () {},
          child: Icon(
            Icons.share,
            color: Colors.grey,
            size: 24,
          ),
        ),
      ],
    );
  }
}
