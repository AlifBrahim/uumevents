import 'package:flutter/material.dart';
import 'page1.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  List<Event> favouriteEvents = [];

  @override
  void initState() {
    super.initState();
    fetchFavouriteEvents();
  }
  @override
  void didUpdateWidget(covariant Page3 oldWidget) {
    super.didUpdateWidget(oldWidget);
    fetchFavouriteEvents();
  }


  Future<void> fetchFavouriteEvents() async {
    try {
      final response = await http.get(Uri.parse('http://146.190.102.198:3000/favourites'));
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