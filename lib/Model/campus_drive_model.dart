import 'dart:convert';

class CampusDriveModel {
  int campusDriveId;
  String campusDriveDate;
  String campusDriveTime;
  String campusDrivePackage;
  String campusDriveJobProfile;
  String campusDriveLocation;
  String campusDriveOtherInfo;
  String campusDriveCompanyName;
  String campusDriveCompanyType;
  String campusDriveCompanyWebsite;
  String campusDriveCompanyLinkedin;
  String campusDriveStatus;
  List<RoundsModel> rounds;

  CampusDriveModel({
    required this.campusDriveId,
    required this.campusDriveDate,
    required this.campusDriveTime,
    required this.campusDrivePackage,
    required this.campusDriveJobProfile,
    required this.campusDriveLocation,
    required this.campusDriveOtherInfo,
    required this.campusDriveCompanyName,
    required this.campusDriveCompanyType,
    required this.campusDriveCompanyWebsite,
    required this.campusDriveCompanyLinkedin,
    required this.campusDriveStatus,
    required this.rounds,
  });

  factory CampusDriveModel.fromJson(Map<String, dynamic> json) {
    // Parse the rounds_details string if it exists
    List<RoundsModel> roundsList = [];
    if (json['rounds_details'] != null) {
      try {
        // Decode the rounds_details string into a JSON object
        final roundsDetailsString = json['rounds_details'] as String;
        final roundsDetailsJson = jsonDecode(roundsDetailsString);

        // Extract the 'rounds' field (which is a string) and decode it into a list
        final roundsString = roundsDetailsJson['rounds'] as String;
        final roundsJson = jsonDecode(roundsString) as List<dynamic>;

        // Map the list to RoundsModel objects
        roundsList = roundsJson.map((round) => RoundsModel.fromJson(round)).toList();
      } catch (e) {
        roundsList = [];
      }
    }

    return CampusDriveModel(
      campusDriveId: json['id'] ?? 0,
      campusDriveDate: json['date'] ?? "",
      campusDriveTime: json['time'] ?? "",
      campusDrivePackage: json['package'] ?? "",
      campusDriveJobProfile: json['job_profile'] ?? "",
      campusDriveLocation: json['location'] ?? "",
      campusDriveOtherInfo: json['other_info'] ?? "",
      campusDriveCompanyName: json['company_name'] ?? "",
      campusDriveCompanyType: json['company_type'] ?? "",
      campusDriveCompanyWebsite: json['company_website'] ?? "",
      campusDriveCompanyLinkedin: json['company_linkedin'] ?? "",
      campusDriveStatus: json['status'] ?? "",
      rounds: roundsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': campusDriveId,
      'date': campusDriveDate,
      'time': campusDriveTime,
      'package': campusDrivePackage,
      'job_profile': campusDriveJobProfile,
      'location': campusDriveLocation,
      'other_info': campusDriveOtherInfo,
      'company_name': campusDriveCompanyName,
      'company_type': campusDriveCompanyType,
      'company_website': campusDriveCompanyWebsite,
      'company_linkedin': campusDriveCompanyLinkedin,
      'status': campusDriveStatus,
      'rounds_details': rounds.map((round) => round.toJson()).toList(),
    };
  }
}

class RoundsModel {
  int id;
  String roundName;
  int roundIndex;
  String mode;
  int campusPlacementInfoId;

  RoundsModel({
    required this.id,
    required this.roundName,
    required this.roundIndex,
    required this.mode,
    required this.campusPlacementInfoId,
  });

  factory RoundsModel.fromJson(Map<String, dynamic> json) {
    return RoundsModel(
      id: json['id'] ?? 0,
      roundName: json['round_name'] ?? "",
      roundIndex: json['round_index'] ?? 0,
      mode: json['mode'] ?? "",
      campusPlacementInfoId: json['campus_placement_info_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'round_name': roundName,
      'round_index': roundIndex,
      'mode': mode,
      'campus_placement_info_id': campusPlacementInfoId,
    };
  }
}