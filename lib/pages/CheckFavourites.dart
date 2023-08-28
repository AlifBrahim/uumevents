// favourites.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:uumevents/pages/page1.dart';

class Favourites {
  static Future<bool> checkIfEventIsFavourite(Event event) async {
    // TODO: Implement a method to check if the event is in the user's favourites
    // For example, you could make an HTTP GET request to your server's /favourites endpoint and check if the event is in the response data
    try {
      final response =
      await http.get(Uri.parse('http://146.190.102.198:3000/favourites'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final favouriteEvents =
        data.map((eventData) => Event.fromJson(eventData)).toList();
        return favouriteEvents.any((favouriteEvent) => favouriteEvent.id == event.id);
      } else {
        print(
            'Failed to load favourite events. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error checking if event is favourite: $error');
    }
    return false;
  }
}