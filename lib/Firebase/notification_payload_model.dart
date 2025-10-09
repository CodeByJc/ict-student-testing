import 'dart:convert';

class NotificationPayLoadModel {
  final String title;
  final String message;
  final String image;

  NotificationPayLoadModel({
    required this.title,
    required this.message,
    required this.image,
  });

  static NotificationPayLoadModel fromJson(Map<dynamic, dynamic> json) {
    String message = json['message'] ?? "";
    if (message.isEmpty) {
      message = json['body'] ?? "";
    }
    if (message.isEmpty) {
      message = json['msg'] ?? "";
    }

    return NotificationPayLoadModel(
      title: json['title'] ?? "",
      image: json['image'] ?? "",
      message: message,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'image': image,
    };
  }

  @override
  String toString() {
    return json.encode(this);
  }

  static NotificationPayLoadModel? fromString(String? value) {
    if (value != null) {
      return NotificationPayLoadModel.fromJson(json.decode(value));
    }
    return null;
  }
}
