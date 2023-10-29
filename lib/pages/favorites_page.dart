import 'package:flutter/material.dart';
import '../components/event_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../functions/get_user_profile.dart';
import '../components/event_class.dart';


class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Event> favouriteEvents = [];

  @override
  void initState() {
    super.initState();
    fetchFavouriteEvents();
  }
  Future<void> fetchFavouriteEvents() async {
    final profile = await getUserProfile(); // Call the getUserProfile method

    try {
      final response = await http.get(Uri.parse('http://146.190.102.198:3001/favorites?matric_no=${profile?['matric_no']}'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (mounted) { // Check if the Page3 widget is still mounted
          setState(() {
            favouriteEvents = data.map((eventData) => Event.fromJson(eventData)).toList();
          });
        }
      } else {
        print('Failed to load favourite events. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching favourite events: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourite Events')),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: favouriteEvents.length,
        itemBuilder: (BuildContext context, int index) {
          return CustomListItemTwo(event: favouriteEvents[index]);
        },
      ),
    );
  }
}