import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> checkIfUserHasAccount() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final response =
      await http.get(Uri.parse('http://146.190.102.198:3001/profiles'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final profile =
        data.firstWhere((profile) => profile['uid'] == user.uid, orElse: () => null);
        return profile != null;
      } else {
        print('Failed to load profiles. Status code: ${response.statusCode}');
        return false;
      }
    } else {
      return false;
    }
  } catch (error) {
    print('Error checking if user has account: $error');
    return false;
  }
}
