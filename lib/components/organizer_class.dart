class Organizer {
  final int organizerId;
  final String name;
  final String description;
  final String facebook;
  final String instagram;

  Organizer({
    required this.organizerId,
    required this.name,
    required this.description,
    required this.facebook,
    required this.instagram,
  });

  factory Organizer.fromJson(Map<String, dynamic> json) {
    return Organizer(
      organizerId: json['organizer_id'],
      name: json['name'],
      description: json['description'],
      facebook: json['facebook'],
      instagram: json['instagram'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organizer_id': organizerId,
      'name': name,
      'description': description,
      'facebook': facebook,
      'instagram': instagram,
    };
  }
}
