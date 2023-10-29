import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import '../functions/get_user_profile.dart';
import '../components/event_class.dart';
import '../components/ticket/ticket_ui_widget.dart';

class TicketsPage extends StatefulWidget {
  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  List<Event> _tickets = [];

  @override
  void initState() {
    super.initState();
    _getTickets();
  }

  Future<void> _getTickets() async {
    final profile = await getUserProfile(); // Call the getUserProfile method
    final response = await http.get(
      Uri.parse('http://146.190.102.198:3001/tickets?matric_no=${profile?['matric_no']}'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _tickets = data.map<Event>((json) => Event.fromJson(json)).toList();
      });
    } else {
      // Handle error
    }
  }
  Future<void> _deleteTicket(Event ticket) async {
    final profile = await getUserProfile(); // Call the getUserProfile method
    final response = await http.delete(
      Uri.parse('http://146.190.102.198:3001/tickets/${ticket.id}/${profile?['matric_no']}'),
    );
    if (response.statusCode == 200) {
      setState(() {
        _tickets.remove(ticket);
      });
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Tickets'),
      ),
      body: ListView.builder(
        itemCount: _tickets.length,
        itemBuilder: (context, index) {
          final ticket = _tickets[index];
          // Parse the ISO date string
          final date = DateFormat('yyyy-MM-dd').parse(ticket.date);
          // Format the date to DD-MM-yyyy format
          final formattedDate = DateFormat('dd-MM-yyyy').format(date);
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          Image.network(ticket.poster),
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ticket.name,
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                Text(formattedDate),
                                SizedBox(height: 8),
                                Text(ticket.time),
                                SizedBox(height: 8),
                                Text(ticket.venue),
                                SizedBox(height: 8),
                                Text(ticket.description),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [

                      TextButton(
                        onPressed: () async {
                          await _deleteTicket(ticket);
                          Navigator.pop(context);
                        },
                        child: Text('Delete Ticket'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
            child:
            TicketUi( // Use the TicketUi widget instead of a Card widget
              name: ticket.name,
              date: formattedDate,
              time: ticket.time,
              venue: ticket.venue,
              description: ticket.description,
            ),
          );
        },
      ),
    );
  }
}