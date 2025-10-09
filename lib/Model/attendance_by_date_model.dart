class AttendanceByDate {
  String subjectName;
  String facultyName;
  String startTime;
  String endTime;
  String status;
  String lecType;

  AttendanceByDate({
    required this.subjectName,
    required this.facultyName,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.lecType,
  });

  factory AttendanceByDate.fromJson(Map<String, dynamic> json) {
    return AttendanceByDate(
      subjectName: json['subject_name'],
      facultyName :json['faculty_name'],
      startTime :json['class_start_time'],
      endTime :json['class_end_time'],
      status :json['attendance_status'],
      lecType :json['lec_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject_name': subjectName,
      'faculty_name': facultyName,
      'class_start_time': startTime,
      'class_end_time': endTime,
      'attendance_status': status,
      'lec_type':lecType
    };
  }
}