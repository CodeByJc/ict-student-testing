class RecentlyPlacedStudentModel {
  String studentName;
  String placedDate;
  double packageStart;
  double packageEnd;
  String companyName;

  RecentlyPlacedStudentModel({
    required this.studentName,
    required this.placedDate,
    required this.packageStart,
    required this.packageEnd,
    required this.companyName,
  });

  factory RecentlyPlacedStudentModel.fromJson(Map<String, dynamic> json) {
    return RecentlyPlacedStudentModel(
      studentName: json['student_name'] ?? "",
      placedDate: json['date'] ?? "",
      packageStart: (json['package_start'] as num).toDouble(),
      packageEnd: (json['package_end'] as num).toDouble(),
      companyName: json['company_name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_name': studentName,
      'placed_date': placedDate,
      'package_start': packageStart,
      'package_end': packageEnd,
      'company_name': companyName,
    };
  }
}