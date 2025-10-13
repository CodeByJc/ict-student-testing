import 'dart:convert';

class CampusDriveModel {
  int id;
  int companyInfoId;
  String date;
  String time;
  String package;
  String location;
  String otherInfo;
  int batchInfoId;
  String createdAt;
  String updatedAt;
  String companyName;
  String companyType;
  String companyWebsite;
  String companyLinkedin;
  String status;

  List<RoundModel> rounds;
  List<JobProfileModel> jobProfiles;

  CampusDriveModel({
    required this.id,
    required this.companyInfoId,
    required this.date,
    required this.time,
    required this.package,
    required this.location,
    required this.otherInfo,
    required this.batchInfoId,
    required this.createdAt,
    required this.updatedAt,
    required this.companyName,
    required this.companyType,
    required this.companyWebsite,
    required this.companyLinkedin,
    required this.status,
    required this.rounds,
    required this.jobProfiles,
  });

  factory CampusDriveModel.fromJson(Map<String, dynamic> json) {
    // --------- Parse Rounds ---------
    List<RoundModel> rounds = [];
    if (json['rounds_details'] != null && json['rounds_details'] != "") {
      try {
        // Decode outer JSON string
        final roundsJsonOuter = jsonDecode(json['rounds_details']);
        // Decode inner rounds string
        final roundsList = jsonDecode(roundsJsonOuter['rounds']);
        rounds = (roundsList as List)
            .map((r) => RoundModel.fromJson(r))
            .toList();
      } catch (e) {
        print("Round parsing error: $e");
      }
    }

    // --------- Parse Job Profiles ---------
    List<JobProfileModel> jobProfiles = [];
    if (json['job_profiles_details'] != null && json['job_profiles_details'] != "") {
      try {
        final profilesList = jsonDecode(json['job_profiles_details']);
        jobProfiles = (profilesList as List)
            .map((p) => JobProfileModel.fromJson(p))
            .toList();
      } catch (e) {
        print("Job profiles parsing error: $e");
      }
    }

    return CampusDriveModel(
      id: json['id'],
      companyInfoId: json['company_info_id'],
      date: json['date'] ?? "",
      time: json['time'] ?? "",
      package: json['package'] ?? "",
      location: json['location'] ?? "",
      otherInfo: json['other_info'] ?? "",
      batchInfoId: json['batch_info_id'] ?? 0,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      companyName: json['company_name'] ?? "",
      companyType: json['company_type'] ?? "",
      companyWebsite: json['company_website'] ?? "",
      companyLinkedin: json['company_linkedin'] ?? "",
      status: json['status'] ?? "pending",
      rounds: rounds,
      jobProfiles: jobProfiles,
    );
  }
}

class RoundModel {
  int id;
  String roundName;
  int roundIndex;
  String mode;
  int campusPlacementInfoId;
  int? studentRoundId;
  String studentRoundStatus;

  RoundModel({
    required this.id,
    required this.roundName,
    required this.roundIndex,
    required this.mode,
    required this.campusPlacementInfoId,
    this.studentRoundId,
    required this.studentRoundStatus,
  });

  factory RoundModel.fromJson(Map<String, dynamic> json) {
    return RoundModel(
      id: json['id'],
      roundName: json['round_name'] ?? "",
      roundIndex: json['round_index'] ?? 0,
      mode: json['mode'] ?? "",
      campusPlacementInfoId: json['campus_placement_info_id'] ?? 0,
      studentRoundId: json['student_round_id'],
      studentRoundStatus: json['student_round_status'] ?? "",
    );
  }
}

class JobProfileModel {
  int profileId;
  String profileName;
  String category;

  JobProfileModel({
    required this.profileId,
    required this.profileName,
    required this.category,
  });

  factory JobProfileModel.fromJson(Map<String, dynamic> json) {
    return JobProfileModel(
      profileId: json['profile_id'],
      profileName: json['profile_name'] ?? "",
      category: json['category'] ?? "",
    );
  }
}
