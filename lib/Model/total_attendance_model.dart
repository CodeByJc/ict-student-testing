class TotalAttendance {
  String subjectName;
  String subjectShortName;
  String lecType;
  int subjectId;
  int totalLec;
  int attendLec;
  int extraLec;

  TotalAttendance(
      {required this.subjectName,
      required this.subjectShortName,
      required this.lecType,
      required this.subjectId,
      required this.totalLec,
      required this.attendLec,
      required this.extraLec});

  factory TotalAttendance.fromJson(Map<String, dynamic> json) {
    return TotalAttendance(
        subjectId: json['id'],
        subjectName: json['subject_name'],
        subjectShortName: json['short_name'],
        lecType: json['lec_type'],
        totalLec: json['total_lec'],
        attendLec: json['attend_lec'],
        extraLec: json['extra_lec']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': subjectId,
      'subject_name': subjectName,
      'shortname': subjectShortName,
      'lec_type': lecType,
      'total_lec': totalLec,
      'attend_lec': attendLec,
      'extra_lec': extraLec
    };
  }
}
