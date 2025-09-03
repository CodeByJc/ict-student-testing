class InterviewBankModel {
  int IBId;
  int IBStudentId;
  int IBCompanyId;
  String IBDate;
  String IBData;
  String IBCompanyName;
  String IBCompanyType;
  String IBStudentName;

  InterviewBankModel({
    required this.IBId,
    required this.IBStudentId,
    required this.IBCompanyId,
    required this.IBDate,
    required this.IBData,
    required this.IBCompanyName,
    required this.IBCompanyType,
    required this.IBStudentName,
  });

  factory InterviewBankModel.fromJson(Map<String, dynamic> json) {
    return InterviewBankModel(
      IBId: int.parse(json['id'].toString()),
      IBStudentId: int.parse(json['student_info_id'].toString()),
      IBCompanyId: int.parse(json['company_info_id'].toString()),
      IBDate: json['date'] ?? "",
      IBData: json['data'] ?? "",
      IBCompanyName: json['company_name'] ?? "",
      IBCompanyType: json['company_type'] ?? "",
      IBStudentName: json['student_name'] ?? "",
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': IBId,
      'student_info_id': IBStudentId,
      'company_info_id': IBCompanyId,
      'date': IBDate,
      'data': IBData,
      'company_name': IBCompanyName,
      'company_type': IBCompanyType,
      'student_name': IBStudentName,
    };
  }
}