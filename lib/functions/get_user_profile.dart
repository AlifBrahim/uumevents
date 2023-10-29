// get_user_profile.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

Future<Map<String, dynamic>?> getUserProfile() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final response =
      await http.get(Uri.parse('http://146.190.102.198:3001/profiles'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final profile =
        data.firstWhere((profile) => profile['uid'] == user.uid, orElse: () => null);
        if (profile != null) {
          return profile;
        }
      } else {
        print('Failed to load profiles. Status code: ${response.statusCode}');
      }
    }
  } catch (error) {
    print('Error retrieving user profile: $error');
  }
  return null;
}
