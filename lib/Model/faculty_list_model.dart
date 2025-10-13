class FacultyListModel {
  int facultyId;
  String facultyName;
  String facultySubjectName;
  String facultySubjectShortName;
  String facultyPhone; // 🔹 new

  FacultyListModel({
    required this.facultyId,
    required this.facultyName,
    required this.facultySubjectName,
    required this.facultySubjectShortName,
    required this.facultyPhone,
  });

  factory FacultyListModel.fromJson(Map<String, dynamic> json) {
    return FacultyListModel(
      facultyId: json['id'] ?? 0,
      facultyName: json['faculty_name'] ?? "",
      facultySubjectName: json['subject_name'] ?? "",
      facultySubjectShortName: json['short_name'] ?? "",
      facultyPhone: json['phone_no'] ?? "", // 🔹 map phone_no
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': facultyId,
      'faculty_name': facultyName,
      'subject_name': facultySubjectName,
      'short_name': facultySubjectShortName,
      'phone_no': facultyPhone,
    };
  }

}
