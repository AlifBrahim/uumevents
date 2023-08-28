import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uumevents/pages/page1.dart';

class Page2 extends StatefulWidget {
  const Page2({Key? key});

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final TextEditingController _searchController = TextEditingController();
  List<Event> events = [];
  List<Event> filteredEvents = [];

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  // Function to fetch events from the server
  Future<void> fetchEvents() async {
    try {
      final response =
      await http.get(Uri.parse('http://146.190.102.198:3000/events'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          events = data.map((eventData) => Event.fromJson(eventData)).toList();
          filteredEvents = events;
        });
      } else {
        print('Failed to load events. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching events: $error');
    }
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      filteredEvents = events
          .where((event) => event.name.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Center(
              child: Text(
                'Search Events',
                style: TextStyle(color: Colors.black),
              ),
            ),
            floating: true,
            pinned: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(64),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView( // Add this line
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Add this line
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: _onSearchTextChanged,
                  ),

                ),
              ),
            ),
          ),


          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16), // Add this line
                  child: CustomListItemTwo(event: filteredEvents[index]),
                );
              },
              childCount: filteredEvents.length,
            ),
          ),

        ],
      ),
    );
  }
}