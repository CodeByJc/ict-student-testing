class AnnouncementModel {
  final int id;
  final int facultyId;
  final String facultyName;
  final String title;
  final String description;
  final String date;
  final int batchId;

  AnnouncementModel({
    required this.id,
    required this.facultyId,
    required this.facultyName,
    required this.title,
    required this.description,
    required this.date,
    required this.batchId,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['Announcement_id'] ?? 0,
      facultyId: json['faculty_id'] ?? 0,
      facultyName: json['faculty_name'] ?? '',
      title: json['Announcement_title'] ?? '',
      description: json['announcement_description'] ?? '',
      date: json['Announcement_date'] ?? '',
      batchId: json['batch_id'] ?? 0,
    );
  }
}
