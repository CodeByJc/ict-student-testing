import 'dart:convert';

class CampusDriveStudentModel {
  int studentCurrentRoundId;
  String companyName;
  String studentCurrentRoundName;
  int studentCurrentRoundIndex;
  String studentCurrentRoundMode;
  String studentCurrentRoundStatus;
  List<CompanyRoundsModel> rounds;

  CampusDriveStudentModel({
    required this.studentCurrentRoundId,
    required this.companyName,
    required this.studentCurrentRoundName,
    required this.studentCurrentRoundIndex,
    required this.studentCurrentRoundMode,
    required this.studentCurrentRoundStatus,
    required this.rounds,
  });

  factory CampusDriveStudentModel.fromJson(Map<String, dynamic> json) {
    // Parse the rounds_details string if it exists
    List<CompanyRoundsModel> roundsList = [];
    if (json['company_rounds'] != null) {
      try {
        // Decode the rounds_details string into a JSON object
        final roundsDetailsString = json['company_rounds'] as String;
        final roundsDetailsJson = jsonDecode(roundsDetailsString);

        // Extract the 'rounds' field (which is a string) and decode it into a list
        final roundsString = roundsDetailsJson['rounds'] as String;
        final roundsJson = jsonDecode(roundsString) as List<dynamic>;

        // Map the list to RoundsModel objects
        roundsList = roundsJson.map((round) => CompanyRoundsModel.fromJson(round)).toList();
      } catch (e) {
        roundsList = [];
      }
    }

    return CampusDriveStudentModel(
      studentCurrentRoundId: json['student_round_id'] ?? 0,
      companyName: json['company_name'] ?? "",
      studentCurrentRoundName: json['round_name'] ?? "",
      studentCurrentRoundIndex: json['round_index'] ?? 0,
      studentCurrentRoundMode: json['mode'] ?? "",
      studentCurrentRoundStatus: json['status'] ?? "",
      rounds: roundsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_round_id': studentCurrentRoundId,
      'company_name': companyName,
      'round_name': studentCurrentRoundName,
      'round_index': studentCurrentRoundIndex,
      'mode': studentCurrentRoundMode,
      'status': studentCurrentRoundStatus,
      'rounds_details': rounds.map((round) => round.toJson()).toList(),
    };
  }
}

class CompanyRoundsModel {
  int id;
  String roundName;
  int roundIndex;
  String mode;
  int campusPlacementInfoId;

  CompanyRoundsModel({
    required this.id,
    required this.roundName,
    required this.roundIndex,
    required this.mode,
    required this.campusPlacementInfoId,
  });

  factory CompanyRoundsModel.fromJson(Map<String, dynamic> json) {
    return CompanyRoundsModel(
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