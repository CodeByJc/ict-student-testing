class TimeTableModel {
  String subjectName;
  String subjectShortName;
  String lecType;
  String startTime;
  String endTime;
  String facultyName;
  String className;

  TimeTableModel(
      {required this.subjectName,
      required this.subjectShortName,
      required this.lecType,
      required this.startTime,
      required this.endTime,
      required this.facultyName,
      required this.className});

  factory TimeTableModel.fromJson(Map<String, dynamic> json) {
    return TimeTableModel(
      facultyName: json['faculty_name'],
      subjectName: json['subject_name'],
      subjectShortName: json['short_name'],
      lecType: json['lec_type'],
      className: json['classname'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'faculty_name': facultyName,
      'subject_name': subjectName,
      'short_name': subjectShortName,
      'lec_type': lecType,
      'classname':className,
      'start_time':startTime,
      'end_time':endTime
    };
  }
}
