// event_list.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'event_class.dart';
import 'love_and_share_button.dart';
import '../components/event_details.dart';

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
                      padding:
                      const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                      child: ArticleDescription(
                        title: event.name,
                        subtitle:
                        '$formattedDate - ${event.time}',
                        venue: event.venue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.all(8.0),
              child:
              LoveAndShareButton(event), // Custom LoveButton widget
            ),
          ],
        ),
      ),
    );
  }
}
class ArticleDescription extends StatelessWidget {
  const ArticleDescription({
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

