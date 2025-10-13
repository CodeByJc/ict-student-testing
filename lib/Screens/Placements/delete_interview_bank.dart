// lib/Screens/InterviewBank/delete_interview_bank.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/interview_bank_controller.dart';
import '../../Helper/Components.dart';
import '../../Helper/Style.dart';
import '../../Helper/colors.dart';
import '../../Helper/size.dart';
import '../../Model/interview_bank_model.dart';

class DeleteInterviewBankScreen extends StatefulWidget {
  const DeleteInterviewBankScreen({Key? key}) : super(key: key);

  @override
  State<DeleteInterviewBankScreen> createState() => _DeleteInterviewBankScreenState();
}

class _DeleteInterviewBankScreenState extends State<DeleteInterviewBankScreen> {
  final InterviewBankController controller = Get.find<InterviewBankController>();

  int? studentId;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments ?? {};
    print("DEBUG: Received arguments: $args"); // ✅ Debug: arguments

    studentId = args['student_id'];
    print("DEBUG: Student ID: $studentId"); // ✅ Debug: studentId

    if (studentId != null) {
      controller.fetchStudentInterviews(studentId!).then((_) {
        print("DEBUG: Fetched interviews for studentId=$studentId");
        print("DEBUG: Total interviews fetched: ${controller.filteredInterviewDataList.length}");
      });
    } else {
      print("DEBUG: No student ID provided!");
      Get.snackbar(
        "Missing Data",
        "Student ID not provided.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _confirmDelete(InterviewBankModel interview) async {
    print("DEBUG: Attempting to delete interview ID: ${interview.IBId} (${interview.IBCompanyName})"); // ✅ Debug

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete this interview for ${interview.IBCompanyName}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      bool ok = await controller.deleteInterview(interview.IBId);
      if (ok) {
        print("DEBUG: Interview deleted successfully: ${interview.IBId}"); // ✅ Debug
        Get.snackbar("Deleted", "Interview deleted successfully", backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        print("DEBUG: Failed to delete interview: ${interview.IBId}"); // ✅ Debug
        Get.snackbar("Failed", "Could not delete interview", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } else {
      print("DEBUG: Delete cancelled for interview ID: ${interview.IBId}"); // ✅ Debug
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delete Interview Bank", style: appbarStyle(context)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white), onPressed: () => Get.back()),
      ),
      body: Obx(() {
        print("DEBUG: isLoadingInterviews=${controller.isLoadingInterviews.value}"); // ✅ Debug

        if (controller.isLoadingInterviews.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final interviews = controller.filteredInterviewDataList; // ✅ exact name
        print("DEBUG: Number of interviews to display: ${interviews.length}");// ✅ Debug

        if (interviews.isEmpty) {
          return Center(
            child: Text("No interviews found for this student.",
                style: TextStyle(fontSize: getSize(context, 1.8))),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            if (studentId != null) {
              await controller.fetchStudentInterviews(studentId!);
              print("DEBUG: Refreshed interviews for studentId=$studentId"); // ✅ Debug
            }
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: interviews.length,
            itemBuilder: (ctx, i) {
              final interview = interviews[i];
              print("DEBUG: company name: ${interview.IBCompanyName}");
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  title: Text(
                    interview.IBCompanyName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue, // ✅ change to your theme color
                      fontSize: getSize(context,2.5),
                    ),
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Date: ${interview.IBDate}"),
                        const SizedBox(height: 4),
                        Text(
                          interview.IBData.length > 100
                              ? '${interview.IBCompanyName}${interview.IBData.substring(0, 100)}...'
                              : interview.IBData,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_forever_rounded, color: Colors.red),
                    onPressed: () => _confirmDelete(interview),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
