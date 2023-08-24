import 'package:flutter/material.dart';

void main() => runApp(const Page1());

class Page1 extends StatelessWidget {
  const Page1({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const CustomListItemExample(),
    );
  }
}

class Event {
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
}
class EventDetailsPage extends StatelessWidget {
  final Event event;

  EventDetailsPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.name)),
      bottomNavigationBar: null, // Set bottomNavigationBar to null
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20.0), // Add margin here
              child: Center(
                child: Image.network(
                  event.poster,
                  height: 200, // Adjust the height as needed
                  width: double.infinity, // Make the image take the full width
                  fit: BoxFit.contain, // Maintain the original aspect ratio
                ),
              ),
            ),
            Text('Type: ${event.type}'),
            Text('Name: ${event.name}'),
            Text('Date: ${event.date}'),
            Text('Time: ${event.time}'),
            Text('Venue: ${event.venue}'),
            if (event.type == 'Physical')
              Text('Location: ${event.venue}')
            else if (event.type == 'Online')
              Text('Online Platform: ${event.venue}'),
            if (event.fee.isNotEmpty) Text('Fee: ${event.fee}'),
            if (event.speaker.isNotEmpty) Text('Speaker: ${event.speaker}'),
            Text('Description: ${event.description}'),
            Text('Contact Person: ${event.contactPerson}'),
            TextButton(
              onPressed: () {
                // Handle ticket action
              },
              child: Text('Get Tickets'),
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
    return GestureDetector(
      onTap: ()  {
        // Navigate to the event details page when tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventDetailsPage(event: event)),
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
                      border: Border.all(color: Colors.pink, width: 2.0), // Optional: Customize the border
                    ),
                    child: Image.network(
                      event.poster,
                      fit: BoxFit.cover, // You can use BoxFit.contain or other options as well
                    ),
                  ),

                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                    child: _ArticleDescription(
                      title: event.name,
                      subtitle: '${event.date} - ${event.time}',
                      venue: event.venue,
                    ),
                  ),
                ),
              ],
            ),
          ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LoveAndShareButton(), // Custom LoveButton widget
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
  @override
  _LoveAndShareButtonState createState() => _LoveAndShareButtonState();
}

class _LoveAndShareButtonState extends State<LoveAndShareButton> {
  bool isLoved = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isLoved = !isLoved;
            });
          },
          child: Icon(
            isLoved ? Icons.favorite : Icons.favorite_border,
            color: isLoved ? Colors.red : Colors.grey,
            size: 24,
          ),
        ),
        SizedBox(width: 10), // Add some spacing between the love and share icons
        GestureDetector(
          onTap: () {
            // Handle share action
          },
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

class CustomListItemExample extends StatelessWidget {
  const CustomListItemExample({Key? key});

  @override
  Widget build(BuildContext context) {
    final List<Event> events = [
      Event(
        poster: 'https://img.freepik.com/free-vector/flat-design-business-workshop-poster-template_23-2149394723.jpg?w=2000',
        type: 'Workshop',
        name: 'Dives into Music',
        date: '2023-08-30',
        time: '7:30 PM',
        venue: 'Indigo Nightclub',
        fee: '\$20',
        speaker: 'John Doe',
        description: 'A workshop on music appreciation.',
        contactPerson: 'Alice Johnson',
        tickets: 'Buy Now',
      ),
      Event(
        poster: 'https://marketplace.canva.com/EAFBiag7Bos/1/0/1131w/canva-black-and-pink-glow-party-night-poster-oeRmI0EKb_I.jpg',
        type: 'Competition',
        name: 'Rock the Night',
        date: '2023-09-05',
        time: '8:00 AM',
        venue: 'The Roxy Theatre',
        fee: '\$10',
        speaker: '',
        description: 'A rock music competition.',
        contactPerson: 'Bob Smith',
        tickets: 'Register',
      ),
      Event(
        poster: 'https://img.freepik.com/free-vector/new-year-2021-party-poster-template_23-2148776977.jpg?size=626&ext=jpg',
        type: 'Seminar',
        name: 'Jazz Festival',
        date: '2023-09-15',
        time: '6:00 PM',
        venue: 'Central Park',
        fee: '\$15',
        speaker: 'Jane Smith',
        description: 'A seminar on jazz music history.',
        contactPerson: 'Eva Williams',
        tickets: 'Get Tickets',
      ),
      Event(
        poster: 'https://img.freepik.com/free-vector/music-event-poster-template-with-abstract-shapes_1361-1316.jpg?size=626&ext=jpg',
        type: 'Leisure',
        name: 'Relaxation Retreat',
        date: '2023-10-02',
        time: '1:00 PM',
        venue: 'Tranquil Valley Resort',
        fee: '\$50',
        speaker: '',
        description: 'A day of relaxation and mindfulness.',
        contactPerson: 'Michael Brown',
        tickets: 'Book Now',
      ),
      Event(
        poster: 'https://img.freepik.com/premium-vector/music-event-poster-template-with-photo_23-2148577977.jpg?size=626&ext=jpg',
        type: 'CSR',
        name: 'Community Cleanup',
        date: '2023-10-10',
        time: '9:00 AM',
        venue: 'Local Park',
        fee: 'Free',
        speaker: '',
        description: 'Join us in cleaning up the community!',
        contactPerson: 'Sarah Green',
        tickets: 'Join',
      ),
      Event(
        poster: 'https://img.freepik.com/premium-vector/modern-elegant-music-festival-poster-vector-template_115083-346.jpg?size=626&ext=jpg',
        type: 'Meeting',
        name: 'Team Meeting',
        date: '2023-11-05',
        time: '3:00 PM',
        venue: 'Office Conference Room',
        fee: 'N/A',
        speaker: '',
        description: 'Monthly team meeting.',
        contactPerson: 'David Jones',
        tickets: 'N/A',
      ),
      Event(
        poster: 'https://img.freepik.com/free-psd/digital-marketing-live-webinar-corporate-social-media-post-template_202595-418.jpg?size=626&ext=jpg',
        type: 'Talk',
        name: 'Tech Talk',
        date: '2023-12-12',
        time: '10:00 AM',
        venue: 'Online (Zoom)',
        fee: 'Free',
        speaker: 'Tech Guru',
        description: 'A talk on the latest technology trends.',
        contactPerson: 'Megan White',
        tickets: 'Register Now',
      ),
      Event(
        poster: 'https://img.freepik.com/free-vector/modern-music-event-poster-with-abstract-brush-stroke_1361-1917.jpg?size=626&ext=jpg',
        type: 'Workshop',
        name: 'Art Workshop',
        date: '2023-01-20',
        time: '2:30 PM',
        venue: 'Local Art Studio',
        fee: '\$25',
        speaker: 'Art Expert',
        description: 'Learn to create beautiful art!',
        contactPerson: 'Olivia Davis',
        tickets: 'Sign Up',
      ),
    ];

    // Sort the events by date in ascending order
    events.sort((a, b) => a.date.compareTo(b.date));

    return Scaffold(
      appBar: AppBar(title: const Text('Upcoming Events')),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          return CustomListItemTwo(event: events[index]);
        },
      ),
    );
  }
}
