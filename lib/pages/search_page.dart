import 'package:flutter/material.dart';
import '../components/event_list.dart';
import '../components/event_class.dart';
import '../functions/event_fetcher.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({Key? key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
    final fetchedEvents = await EventService.fetchEvents();
    setState(() {
      events = fetchedEvents;
      filteredEvents = events;
    });
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