class MentorModel {
  int mentorEmployeeId;
  String mentorName;
  String mentorCabin;
  String mentorPhone;

  MentorModel({
    required this.mentorEmployeeId,
    required this.mentorName,
    required this.mentorCabin,
    required this.mentorPhone,
  });

  factory MentorModel.fromJson(Map<String, dynamic> json) {
    return MentorModel(
      mentorEmployeeId: int.tryParse(json['mentor_employee_id'].toString()) ?? 0,
    mentorName: json['mentor_name'] ?? "",
      mentorCabin: json['mentor_cabin'] ?? "",
      mentorPhone: json['mentor_phone'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mentor_employee_id': mentorEmployeeId,
      'mentor_name': mentorName,
      'mentor_cabin': mentorCabin,
      'mentor_phone': mentorPhone,
    };
  }
}
