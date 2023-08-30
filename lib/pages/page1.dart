import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uumevents/pages/page4.dart';
import '../login/Screens/Login/login_screen.dart';
import 'user_profile.dart'; // Import the getUserProfile method
import 'page5.dart';

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  List<Event> events = []; // Initialize an empty list to store events
  bool isLoading = true; // Add a new state variable to track loading status

  @override
  void initState() {
    super.initState();
    fetchEvents(); // Fetch events when the widget is initialized
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
          isLoading = false; // Set isLoading to false when data is loaded
        });
      } else {
        print('Failed to load events. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching events: $error');
    }
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

class Event {
  final int id; // Add an id property to the Event class
  final String poster;
  final String type;
  final String name;
  final String date;
  final String time;
  final String venue;
  final String fee; // Optional
  final String speaker; // Optional
  final String description;
  final String contactPerson;
  final String tickets;

  Event({
    required this.id, // Initialize the id property in the constructor
    required this.poster,
    required this.type,
    required this.name,
    required this.date,
    required this.time,
    required this.venue,
    required this.fee,
    required this.speaker,
    required this.description,
    required this.contactPerson,
    required this.tickets,
  });

  // Update the fromJson factory constructor to parse the id property from JSON data
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      poster: json['poster'],
      type: json['type'],
      name: json['name'],
      date: json['date'],
      time: json['time'],
      venue: json['venue'],
      fee: json['fee'],
      speaker: json['speaker'],
      description: json['description'],
      contactPerson: json['contactPerson'],
      tickets: json['tickets'],
    );
  }

  // Update the toJson method to include the id property in the JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'poster': poster,
      'type': type,
      'name': name,
      'date': date,
      'time': time,
      'venue': venue,
      'fee': fee,
      'speaker': speaker,
      'description': description,
      'contactPerson': contactPerson,
      'tickets': tickets,
    };
  }
}

class EventDetailsPage extends StatefulWidget {
  final Event event;

  EventDetailsPage({required this.event});

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  bool _hasTicket = false;
  bool hasAccount = false;


  @override
  void initState() {
    super.initState();
    _checkIfEventHasTicket();
    checkIfUserHasAccount();
  }

  Future<void> _checkIfEventHasTicket() async {
    final profile = await getUserProfile(); // Call the getUserProfile method
    final response = await http.get(
      Uri.parse('http://146.190.102.198:3000/tickets?matric_no=${profile?['matric_no']}'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final tickets = data.map<Event>((json) => Event.fromJson(json)).toList();
      setState(() {
        _hasTicket = tickets.any((ticket) => ticket.id == widget.event.id);
      });
    } else {
      // Handle error
    }
  }
  Future<void> checkIfUserHasAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final response =
        await http.get(Uri.parse('http://146.190.102.198:3000/profiles'));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          final profile =
          data.firstWhere((profile) => profile['uid'] == user.uid, orElse: () => null);
          setState(() {
            hasAccount = profile != null;
          });
        } else {
          print(
              'Failed to load profiles. Status code: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('Error checking if user has account: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Parse the ISO date string
    final date = DateFormat('yyyy-MM-dd').parse(widget.event.date);
    // Format the date to DD-MM-yyyy format
    final formattedDate = DateFormat('dd-MM-yyyy').format(date);

    return Scaffold(
      appBar: AppBar(title: Text(widget.event.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 20.0), // Add margin here
                child: Center(
                  child: Image.network(
                    widget.event.poster,
                    height: 200, // Adjust the height as needed
                    width:
                        double.infinity, // Make the image take the full width
                    fit: BoxFit.contain, // Maintain the original aspect ratio
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(widget.event.type, style: TextStyle(fontSize: 18)),
              ),
              Center(
                  child: Text(widget.event.name,
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold))),
              SizedBox(height: 8),
              Row(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey[200]),
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.event, size: 32)),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(formattedDate,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(widget.event.time, style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text('Venue: ${widget.event.venue}', style: TextStyle(fontSize: 18)),
              if (widget.event.type == 'Physical')
                Text('Location: ${widget.event.venue}', style: TextStyle(fontSize: 18))
              else if (widget.event.type == 'Online')
                Text('Online Platform: ${widget.event.venue}',
                    style: TextStyle(fontSize: 18)),
              if (widget.event.fee.isNotEmpty) SizedBox(height: 8),
              Text('Fee: ${widget.event.fee}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              if (widget.event.speaker.isNotEmpty)
                Text('Speaker:${widget.event.speaker}',
                    style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('About this event:', style: TextStyle(fontSize: 18)),
              Container(
                margin: EdgeInsets.only(
                    left: 20.0, top: 10.0, bottom: 10.0), // Add margin here
                child: Text(widget.event.description, style: TextStyle(fontSize: 16)),
              ),
              Text('Contact Person:', style: TextStyle(fontSize: 18)),
              Container(
                margin: EdgeInsets.only(
                    left: 20.0, top: 10.0, bottom: 10.0), // Add margin here
                child:
                    Text(widget.event.contactPerson, style: TextStyle(fontSize: 16)),
              ),
            ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(right: 30),
              child: ElevatedButton(
                onPressed: () {
                  if (hasAccount) {
                    if (_hasTicket) {
                      // Handle view tickets action
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Page4()),
                      );
                    } else {
                      // Handle get tickets action
                      showDialog(
                        context:
                        context,
                        builder:
                            (BuildContext context) {
                          return AlertDialog(
                            title:
                            Text('Get Tickets'),
                            content:
                            SingleChildScrollView(
                              child:
                              ListBody(
                                children:
                                <Widget>[
                                  Text('Event: ${widget.event.name}'),
                                  Text('Venue: ${widget.event.venue}'),
                                  Text('Date: $formattedDate'),
                                  Text('Time: ${widget.event.time}'),
                                ],
                              ),
                            ),
                            actions:
                            <Widget>[
                              TextButton(
                                child:
                                Text('Confirm'),
                                onPressed:
                                    () async {
                                  final profile =
                                  await getUserProfile(); // Call the getUserProfile method
                                  // Handle confirm action
                                  final response =
                                  await http.post(
                                    Uri.parse('http://146.190.102.198:3000/tickets'),
                                    headers:
                                    {
                                      'Content-Type':
                                      'application/json; charset=UTF-8',
                                    },
                                    body:
                                    jsonEncode({
                                      'event_id':
                                      widget.event.id,
                                      'matric_no':
                                      profile?['matric_no'],
                                    }),
                                  );
                                  if (response.statusCode == 200) {
                                    // Ticket created successfully
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                        Text('Ticket created successfully!'),
                                      ),
                                    );
                                  } else {
                                    // Handle error
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                        Text('An error occurred while creating the ticket. Please try again.'),
                                      ),
                                    );
                                  }
                                },
                              ),
                              TextButton(
                                child:
                                Text('Cancel'),
                                onPressed:
                                    () {
                                  Navigator.of(context).pop();

                                }, // Replace with your cancel action
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text("You haven't created an account yet."),
                        content:
                        Text('Please create an account to get tickets.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Page5()),
                            ),
                            child: Text('Create account'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                style:
                ButtonStyle(backgroundColor:
                MaterialStateProperty.all<Color>(Colors.blue)),
                child:
                Text(_hasTicket ? 'View Tickets' : 'Get Tickets',
                    style:
                    TextStyle(color:
                    Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomListItemTwo extends StatelessWidget {
  const CustomListItemTwo({
    Key? key,
    required this.event,
  }) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    // Parse the ISO date string
    final date = DateFormat('yyyy-MM-dd').parse(event.date);
    // Format the date to DD-MM-yyyy format
    final formattedDate = DateFormat('dd-MM-yyyy').format(date);
    return GestureDetector(
      onTap: () {
        // Navigate to the event details page when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EventDetailsPage(event: event)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            SizedBox(
              height: 100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Customize the thumbnail here (you can use the event poster)
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.pink,
                            width: 2.0), // Optional: Customize the border
                      ),
                      child: Image.network(
                        event.poster,
                        fit: BoxFit
                            .cover, // You can use BoxFit.contain or other options as well
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                      child: _ArticleDescription(
                        title: event.name,
                        subtitle: '$formattedDate - ${event.time}',
                        venue: event.venue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LoveAndShareButton(event), // Custom LoveButton widget
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleDescription extends StatelessWidget {
  const _ArticleDescription({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.venue,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String venue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 2.0)),
        Expanded(
          child: Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
        ),
        Text(
          venue,
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class LoveAndShareButton extends StatefulWidget {
  final Event event;

  LoveAndShareButton(this.event);

  @override
  _LoveAndShareButtonState createState() => _LoveAndShareButtonState();
}

class _LoveAndShareButtonState extends State<LoveAndShareButton> {
  bool isLoved = false;
  bool isLoggedIn = false;
  bool hasAccount = false;

  @override
  void initState() {
    super.initState();
    checkIfEventIsFavourite();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        isLoggedIn = user != null;
      });
      checkIfUserHasAccount();
    });
  }

  Future<void> checkIfEventIsFavourite() async {
    final profile = await getUserProfile(); // Call the getUserProfile method

    try {
      final response =
      await http.get(Uri.parse('http://146.190.102.198:3000/favorites?matric_no=${profile?['matric_no']}'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final favouriteEvents =
        data.map((eventData) => Event.fromJson(eventData)).toList();
        setState(() {
          isLoved = favouriteEvents.any((event) => event.id == widget.event.id);
        });
      } else {
        print(
            'Failed to load favourite events. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error checking if event is favourite: $error');
    }
  }

  Future<void> checkIfUserHasAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final response =
        await http.get(Uri.parse('http://146.190.102.198:3000/profiles'));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          final profile =
          data.firstWhere((profile) => profile['uid'] == user.uid, orElse: () => null);
          setState(() {
            hasAccount = profile != null;
          });
        } else {
          print(
              'Failed to load profiles. Status code: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('Error checking if user has account: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () async {
            if (isLoggedIn && hasAccount) {
              setState(() {
                isLoved = !isLoved;
              });
              if (isLoved) {
                final profile = await getUserProfile(); // Call the getUserProfile method
                // Send a POST request to the server to add the event to the user's favourites
                try {
                  if (profile != null) { // Check if a profile was returned
                    final response = await http.post(
                      Uri.parse('http://146.190.102.198:3000/favorites'),
                      body: json.encode({
                        'event_id': widget.event.id,
                        'matric_no': profile['matric_no'], // Use the matric_no value from the profile
                      }),
                      headers: {
                        'Content-Type': 'application/json',
                      },
                    );
                    if (response.statusCode == 200) {
                      print('Successfully added event to favourites');
                    } else {
                      print(
                          'Failed to add event to favourites. Status code: ${response.statusCode}');
                    }
                  }
                } catch (error) {
                  print('Error adding event to favourites: $error');
                }
              } else {
                // Send a DELETE request to the server to remove the event from the user's favourites
                try {
                  final profile = await getUserProfile(); // Call the getUserProfile method

                  final response = await http.delete(
                    Uri.parse('http://146.190.102.198:3000/favorites/${widget.event.id}/${profile?['matric_no']}'),
                    headers: {
                      'Content-Type': 'application/json',
                    },
                  );
                  if (response.statusCode == 200) {
                    print('Successfully removed event from favourites');
                  } else {
                    print(
                        'Failed to remove event from favourites. Status code: ${response.statusCode}');
                  }
                } catch (error) {
                  print('Error removing event from favourites: $error');
                }
              }
            } else if (!hasAccount && isLoggedIn){
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text("You haven't created an account yet."),
                  content:
                  Text('Please create an account to like events.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Page5()),
                      ),
                      child: Text('Create account'),
                    ),
                  ],
                ),
              );
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text('Not logged in'),
                  content:
                  Text('Please log in or sign up to use this feature.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      ),
                      child: Text('Log in'),
                    ),
                  ],
                ),
              );
            }
          },
          child: Icon(
            isLoved ? Icons.favorite : Icons.favorite_border,
            color: isLoved ? Colors.red : Colors.grey,
            size: 24,
          ),
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: () {},
          child: Icon(
            Icons.share,
            color: Colors.grey,
            size: 24,
          ),
        ),
      ],
    );
  }
}
