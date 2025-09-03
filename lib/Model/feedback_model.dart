class FeedbackModel {
  int feedbackId;
  String feedbackReview;
  int feedbackStudentId;
  int feedbackStudentSemId;
  int feedbackFacultyId;
  String feedbackFacultyName;
  String feedbackDate;
  int feedbackStatus;

  FeedbackModel({
    required this.feedbackId,
    required this.feedbackReview,
    required this.feedbackStudentId,
    required this.feedbackStudentSemId,
    required this.feedbackFacultyId,
    required this.feedbackFacultyName,
    required this.feedbackDate,
    required this.feedbackStatus,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      feedbackId: json['id'] ?? 0,
      feedbackReview: json['review'] ?? "",
      feedbackStudentId: json['student_info_id'] ?? 0,
      feedbackStudentSemId: json['sem_info_id'] ?? 0,
      feedbackFacultyId: json['faculty_info_id'] ?? 0,
      feedbackFacultyName: json['faculty_name'] ?? "",
      feedbackDate: json['date'] ?? "",
      feedbackStatus: json['viewed'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': feedbackId,
      'review': feedbackReview,
      'student_info_id': feedbackStudentId,
      'sem_info_id': feedbackStudentSemId,
      'faculty_info_id': feedbackFacultyId,
      'faculty_name': feedbackFacultyName,
      'date': feedbackDate,
      'viewed': feedbackStatus,
    };
  }
}