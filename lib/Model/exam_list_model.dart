class ExamListModel {
  String examType;
  String examDate;
  String subjectName;
  String subjectShortname;
  int examResultStatus;
  int totalMarks;
  double obtainMarks;
  String grade;

  ExamListModel({
    required this.examType,
    required this.examDate,
    required this.subjectName,
    required this.subjectShortname,
    required this.examResultStatus,
    required this.totalMarks,
    required this.obtainMarks,
    required this.grade,
  });

  factory ExamListModel.fromJson(Map<String, dynamic> json) {
    return ExamListModel(
        examType :json['exam_type'],
        examDate: json['exam_date'],
        subjectName :json['subject_name'],
        subjectShortname :json['short_name'],
        examResultStatus :json['result_status'],
        totalMarks :json['total_marks']??0,
        obtainMarks: double.tryParse(json['obtain_marks']?.toString() ?? '') ?? 0.0,
        grade :json['grade']??"Ab"

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exam_type': examType,
      'exam_date': examDate,
      'subject_name': subjectName,
      'short_name': subjectShortname,
      'result_status': examResultStatus,
      'total_marks': totalMarks,
      'obtain_marks': obtainMarks,
      'grade': grade,
    };
  }
}