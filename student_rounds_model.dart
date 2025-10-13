import 'dart:convert';

class CampusDriveStudentModel {
  int? studentCurrentRoundId;
  String companyName;
  List<CompanyRoundModel> rounds;
  String? status;
  String? date;
  String? time;
  String? package;
  String? location;
  String? otherInfo;
  int? batchInfoId;
  String? companyType;
  String? companyWebsite;
  String? companyLinkedin;

  CampusDriveStudentModel({
    this.studentCurrentRoundId,
    required this.companyName,
    required this.rounds,
    this.status,
    this.date,
    this.time,
    this.package,
    this.location,
    this.otherInfo,
    this.batchInfoId,
    this.companyType,
    this.companyWebsite,
    this.companyLinkedin,
  });

  factory CampusDriveStudentModel.fromJson(Map<String, dynamic> json) {
    List<CompanyRoundModel> roundsList = [];

    // Parse nested rounds_details JSON
    if (json['rounds_details'] != null) {
      try {
        final decoded = jsonDecode(json['rounds_details']);
        if (decoded['rounds'] != null && decoded['rounds'] is List) {
          roundsList = (decoded['rounds'] as List)
              .map((e) => CompanyRoundModel.fromJson(e))
              .toList();
        }
      } catch (e) {
        print("❌ Error parsing rounds_details: $e");
      }
    }

    return CampusDriveStudentModel(
      studentCurrentRoundId: json['student_round_id'],
      companyName: json['company_name'] ?? '',
      rounds: roundsList,
      status: json['status'],
      date: json['date'],
      time: json['time'],
      package: json['package'],
      location: json['location'],
      otherInfo: json['other_info'],
      batchInfoId: json['batch_info_id'],
      companyType: json['company_type'],
      companyWebsite: json['company_website'],
      companyLinkedin: json['company_linkedin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_round_id': studentCurrentRoundId,
      'company_name': companyName,
      'rounds_details': jsonEncode({
        'rounds': rounds.map((r) => r.toJson()).toList(),
      }),
      'status': status,
      'date': date,
      'time': time,
      'package': package,
      'location': location,
      'other_info': otherInfo,
      'batch_info_id': batchInfoId,
      'company_type': companyType,
      'company_website': companyWebsite,
      'company_linkedin': companyLinkedin,
    };
  }
}

class CompanyRoundModel {
  int id;
  String roundName;
  int roundIndex;
  String mode;
  int campusPlacementInfoId;
  int? studentRoundId;
  String? studentRoundStatus;

  CompanyRoundModel({
    required this.id,
    required this.roundName,
    required this.roundIndex,
    required this.mode,
    required this.campusPlacementInfoId,
    this.studentRoundId,
    this.studentRoundStatus,
  });

  factory CompanyRoundModel.fromJson(Map<String, dynamic> json) {
    return CompanyRoundModel(
      id: json['id'] ?? 0,
      roundName: json['round_name'] ?? '',
      roundIndex: json['round_index'] ?? 0,
      mode: json['mode'] ?? '',
      campusPlacementInfoId: json['campus_placement_info_id'] ?? 0,
      studentRoundId: json['student_round_id'],
      studentRoundStatus: json['student_round_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'round_name': roundName,
      'round_index': roundIndex,
      'mode': mode,
      'campus_placement_info_id': campusPlacementInfoId,
      'student_round_id': studentRoundId,
      'student_round_status': studentRoundStatus,
    };
  }
}
