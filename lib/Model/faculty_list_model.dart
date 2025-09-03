class FacultyListModel {
  int facultyId;
  String facultyName;
  String facultySubjectName;
  String facultySubjectShortName;

  FacultyListModel({
    required this.facultyId,
    required this.facultyName,
    required this.facultySubjectName,
    required this.facultySubjectShortName,
  });

  factory FacultyListModel.fromJson(Map<String, dynamic> json) {
    return FacultyListModel(
      facultyId: json['id'] ?? 0,
      facultyName: json['faculty_name'] ?? "",
      facultySubjectName: json['subject_name'] ?? "",
      facultySubjectShortName: json['short_name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': facultyId,
      'faculty_name': facultyName,
      'subject_name': facultySubjectName,
      'short_name': facultySubjectShortName,
    };
  }
}