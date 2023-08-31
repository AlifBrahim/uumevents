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