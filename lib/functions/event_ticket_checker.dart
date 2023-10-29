import 'dart:convert';
import 'package:http/http.dart' as http;
import '../components/event_class.dart';
import 'get_user_profile.dart';

Future<bool> checkIfEventHasTicket(eventId) async {
  final profile = await getUserProfile();
  final response = await http.get(
    Uri.parse('http://146.190.102.198:3001/tickets?matric_no=${profile?['matric_no']}'),
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final tickets = data.map<Event>((json) => Event.fromJson(json)).toList();
    return tickets.any((ticket) => ticket.id == eventId);
  } else {
    // Handle error
    return false;
  }
}
