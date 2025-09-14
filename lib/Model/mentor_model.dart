class MentorModel {
  final int mentorId;
  final String fullName;
  final String phone;
  final String cabin;
  final String designation;
  final String photoUrl;

  MentorModel({
    required this.mentorId,
    required this.fullName,
    required this.phone,
    required this.cabin,
    required this.designation,
    required this.photoUrl,
  });

  factory MentorModel.fromJson(Map<String, dynamic> json) {
    return MentorModel(
      mentorId: json['mentor_id'] ?? 0,
      fullName: json['mentor_fullname'] ?? '',
      phone: json['mentor_phone'] ?? 'N/A',
      cabin: json['mentor_cabin'] ?? 'N/A',
      designation: json['mentor_designation'] ?? 'Faculty',
      photoUrl:
      "https://marwadieducation.edu.in/MEFOnline/handler/getImage.ashx?Id=${json['mentor_id'] ?? 0}",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mentor_id': mentorId,
      'mentor_fullname': fullName,
      'mentor_phone': phone,
      'mentor_cabin': cabin,
      'mentor_designation': designation,
      'photoUrl': photoUrl,
    };
  }
}
