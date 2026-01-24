class EventModel {
  final String id;
  final String name;
  final String location;

  EventModel({
    required this.id,
    required this.name,
    required this.location,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      name: json['name'],
      location: json['location'],
    );
  }
}
