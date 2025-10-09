class LeaveModel {
  int id;
  int studentInfoId;
  String reason;
  String documentProof;
  String leaveStatus;
  String reply;
  String createdAt;

  LeaveModel({
    required this.id,
    required this.studentInfoId,
    required this.reason,
    required this.documentProof,
    required this.leaveStatus,
    required this.reply,
    required this.createdAt,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id: json['id'] ?? 0,
      studentInfoId: json['student_info_id'] ?? 0,
      reason: json['reason'] ?? "",
      documentProof: json['document_proof'] ?? "",
      leaveStatus: json['leave_status'] ?? "",
      reply: json['reply'] ?? "",
      createdAt: json['created_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_info_id': studentInfoId,
      'reason': reason,
      'document_proof': documentProof,
      'leave_status': leaveStatus,
      'reply': reply,
      'created_at': createdAt,
    };
  }
}