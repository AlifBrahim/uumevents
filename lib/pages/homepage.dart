import 'package:flutter/material.dart';
import '/functions/event_fetcher.dart';
import '../components/event_class.dart';
import '/functions/user_account_checker.dart';
import '/functions/event_ticket_checker.dart';
import '../components/event_details.dart';
import '../components/event_list.dart';


class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Event> events = []; // Initialize an empty list to store events
  bool isLoading = true; // Add a new state variable to track loading status

  @override
  void initState() {
    super.initState();
    fetchEvents(); // Fetch events when the widget is initialized
  }

  // Function to fetch events from the server
  Future<void> fetchEvents() async {
    final fetchedEvents = await EventService.fetchEvents();
    setState(() {
      events = fetchedEvents;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upcoming Events')),
      body: isLoading // Show progress indicator when isLoading is true
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: events.length,
              itemBuilder: (BuildContext context, int index) {
                return CustomListItemTwo(event: events[index]);
              },
            ),
    );
  }
}


