// event_details.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../functions/get_user_profile.dart';
import '../pages/tickets_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'event_class.dart';
import '../pages/profile_page.dart';
import '../functions/user_account_checker.dart';
import '../functions/event_ticket_checker.dart';

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
    _checkIfUserHasAccount();
  }

  Future<void> _checkIfEventHasTicket() async {
    _hasTicket = await checkIfEventHasTicket(widget.event.id);
    setState(() {});
  }

  Future<void> _checkIfUserHasAccount() async {
    hasAccount = await checkIfUserHasAccount();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.event.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            EventDetailsHeader(
              poster: widget.event.poster,
              type: widget.event.type,
              name: widget.event.name,
            ),
            SizedBox(height: 8),
            EventDetailsDateAndTime(
              date: widget.event.date,
              time: widget.event.time,
            ),
            SizedBox(height: 8),
            EventDetailsVenue(
              type: widget.event.type,
              venue: widget.event.venue,
            ),
            EventDetailsFeeAndSpeaker(
              fee: widget.event.fee,
              speaker: widget.event.speaker,
            ),
            EventDetailsDescription(description:
            widget.event.description),
            EventDetailsContactPerson(contactPerson:
            widget.event.contactPerson),
          ],
        ),
      ),
      bottomNavigationBar: EventDetailsBottomAppBar(
        hasAccount: hasAccount,
        hasTicket: _hasTicket,
        eventName: widget.event.name,
        eventVenue: widget.event.venue,
        eventDate: widget.event.date,
        eventTime: widget.event.time,
        eventId: widget.event.id,
      ),
    );
  }
}

class EventDetailsHeader extends StatelessWidget {
  final String poster;
  final String type;
  final String name;

  const EventDetailsHeader({required this.poster, required this.type, required this.name});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 20.0),
          child: Center(
            child: Image.network(
              poster,
              height: 200,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Container(
          decoration:
          BoxDecoration(color: Colors.yellow, borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(type, style: TextStyle(fontSize: 18)),
        ),
        Center(
            child:
            Text(name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
      ],
    );
  }
}

class EventDetailsDateAndTime extends StatelessWidget {
  final String date;
  final String time;

  const EventDetailsDateAndTime({required this.date, required this.time});

  @override
  Widget build(BuildContext context) {
    final parsedDate = DateFormat('yyyy-MM-dd').parse(date);
    final formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);

    return Row(
      children: [
        Container(
            decoration:
            BoxDecoration(shape: BoxShape.circle, color: Colors.grey[200]),
            padding: EdgeInsets.all(8),
            child: Icon(Icons.event, size: 32)),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formattedDate,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(time, style: TextStyle(fontSize: 18)),
          ],
        ),
      ],
    );
  }
}

class EventDetailsVenue extends StatelessWidget {
  final String type;
  final String venue;

  const EventDetailsVenue({required this.type, required this.venue});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children:[
          Text('Venue:$venue', style:
          TextStyle(fontSize:
          18)),
          if (type == 'Physical')
            Text('Location:$venue', style:
            TextStyle(fontSize:
            18))
          else if (type == 'Online')
            Text('Online Platform:$venue',
                style:
                TextStyle(fontSize:
                18)),
        ]
    );
  }
}

class EventDetailsFeeAndSpeaker extends StatelessWidget {
  final String fee;
  final String speaker;

  const EventDetailsFeeAndSpeaker({required this.fee, required this.speaker});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children:[
          if (fee.isNotEmpty) SizedBox(height:
          8),
          Text('Fee:$fee', style:
          TextStyle(fontSize:
          18)),
          SizedBox(height:
          8),
          if (speaker.isNotEmpty)
            Text('Speaker:$speaker',
                style:
                TextStyle(fontSize:
                18)),
        ]
    );
  }
}

class EventDetailsDescription extends StatelessWidget {
  final String description;

  const EventDetailsDescription({required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children:[
          SizedBox(height:
          8),
          Text('About this event:', style:
          TextStyle(fontSize:
          18)),
          Container(
            margin:
            EdgeInsets.only(left:
            20.0,top:
            10.0,bottom:
            10.0),
            child:
            Text(description,
                style:
                TextStyle(fontSize:
                16)),
          ),
        ]
    );
  }
}

class EventDetailsContactPerson extends StatelessWidget {
  final String contactPerson;

  const EventDetailsContactPerson({required this.contactPerson});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children:[
          Text('Contact Person:', style:
          TextStyle(fontSize:
          18)),
          Container(
            margin:
            EdgeInsets.only(left:
            20.0,top:
            10.0,bottom:
            10.0),
            child:
            Text(contactPerson,
                style:
                TextStyle(fontSize:
                16)),
          ),
        ]
    );
  }
}
class EventDetailsBottomAppBar extends StatelessWidget {
  final bool hasAccount;
  final bool hasTicket;
  final String eventName;
  final String eventVenue;
  final String eventDate;
  final String eventTime;
  final int eventId;

  const EventDetailsBottomAppBar({
    Key? key,
    required this.hasAccount,
    required this.hasTicket,
    required this.eventName,
    required this.eventVenue,
    required this.eventDate,
    required this.eventTime,
    required this.eventId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Parse the ISO date string
    final date = DateFormat('yyyy-MM-dd').parse(eventDate);
    // Format the date to DD-MM-yyyy format
    final formattedDate = DateFormat('dd-MM-yyyy').format(date);

    return BottomAppBar(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(right: 30),
            child: ElevatedButton(
              onPressed: () {
                if (hasAccount) {
                  if (hasTicket) {
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
                                Text('Event: $eventName'),
                                Text('Venue: $eventVenue'),
                                Text('Date: $formattedDate'),
                                Text('Time: $eventTime'),
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
                                    eventId,
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
              Text(hasTicket ? 'View Tickets' : 'Get Tickets',
                  style:
                  TextStyle(color:
                  Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}