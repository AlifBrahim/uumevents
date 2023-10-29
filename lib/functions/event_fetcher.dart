import 'dart:convert';
import 'package:http/http.dart' as http;
import '../components/event_class.dart';

class EventService {
  static Future<List<Event>> fetchEvents() async {
    try {
      final response =
      await http.get(Uri.parse('http://146.190.102.198:3001/events'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((eventData) => Event.fromJson(eventData)).toList();
      } else {
        print('Failed to load events. Status code: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error fetching events: $error');
      return [];
    }
  }
}
