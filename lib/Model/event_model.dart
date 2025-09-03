class EventModel {
  String eventId; // Changed to String
  String eventTitle;
  String eventDetails;
  String eventDatetime;
  String eventCreatedAt;

  EventModel({
    required this.eventId,
    required this.eventTitle,
    required this.eventDetails,
    required this.eventDatetime,
    required this.eventCreatedAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventId: json['id'] ?? "",
      eventTitle: json['title'] ?? "",
      eventDetails: json['details'] ?? "",
      eventDatetime: json['datetime'] ?? "",
      eventCreatedAt: json['created_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': eventId,
      'title': eventTitle,
      'details': eventDetails,
      'datetime': eventDatetime,
      'created_at': eventCreatedAt,
    };
  }
}