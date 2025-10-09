class FacultyContactModel {
  String facultyName;
  String subjectName;
  String subjectShortName;
  String mobileNo;

  FacultyContactModel({
    required this.facultyName,
    required this.subjectName,
    required this.subjectShortName,
    required this.mobileNo
  });

  factory FacultyContactModel.fromJson(Map<String, dynamic> json) {
    return FacultyContactModel(
        facultyName :json['faculty_name'],
        subjectName: json['subject_name'],
        subjectShortName :json['short_name'],
        mobileNo :json['phone_no']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'faculty_name': facultyName,
      'subject_name': subjectName,
      'short_name': subjectShortName,
      'phone_no': mobileNo
    };
  }
}