// lib/Controllers/interview_bank_controller.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Helper/Utils.dart';
import '../Model/interview_bank_model.dart';
import '../Network/API.dart';
import 'internet_connectivity.dart';

class InterviewBankController extends GetxController {
  final internetController = Get.find<InternetConnectivityController>();

  RxList<InterviewBankModel> interviewDataList = <InterviewBankModel>[].obs;
  RxList<InterviewBankModel> filteredInterviewDataList = <InterviewBankModel>[].obs;

  final TextEditingController interviewSearchController = TextEditingController();
  // RxBool isLoadingEventList = true.obs;

  RxBool isLoadingInterviews = true.obs;

  @override
  @override
  void onInit() {
    super.onInit();
    // Auto filter listener
    interviewSearchController.addListener(() {
      filterInterviews(interviewSearchController.text);
    });
  }


  // ---------------- Fetch Interview List ----------------
  Future<void> fetchInterviewList() async {
    isLoadingInterviews.value = true;
    await internetController.checkConnection();

    if (!internetController.isConnected.value) {
      isLoadingInterviews.value = false;
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => fetchInterviewList(),
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(interviewBankListAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;

        if (responseData['status'] == true && responseData['data'] != null) {
          final interviewList = responseData['data'] as List<dynamic>;
          interviewDataList.assignAll(
            interviewList.map((data) => InterviewBankModel.fromJson(data)).toList(),
          );
          filteredInterviewDataList.assignAll(interviewDataList);
        } else {
          Get.snackbar(
            "No Data",
            responseData['message'] ?? 'No interview data available',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Server responded with ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load data: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingInterviews.value = false;
    }
  }

  // ---------------- Search / Filter ----------------
  void filterInterviews(String query) {
    if (query.trim().isEmpty) {
      filteredInterviewDataList.assignAll(interviewDataList);
    } else {
      final lowerQuery = query.toLowerCase();
      filteredInterviewDataList.assignAll(
        interviewDataList.where((interview) {
          return interview.IBCompanyName.toLowerCase().contains(lowerQuery) ||
              interview.IBStudentName.toLowerCase().contains(lowerQuery);
        }).toList(),
      );
    }
  }

  // ---------------- Create Interview ----------------
  Future<bool> createInterview({
    required int studentId,
    required int companyId,
    required String date, // yyyy-MM-dd
    required String dataHtml,
  }) async {
    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => createInterview(
          studentId: studentId,
          companyId: companyId,
          date: date,
          dataHtml: dataHtml,
        ),
      );
      return false;
    }

    try {
      final payload = {
        'student_info_id': studentId,
        'company_info_id': companyId,
        'date': date,
        'data': dataHtml,
      };

      final response = await http.post(
        Uri.parse(interviewBankCreateAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode(payload),
      );

      final res = json.decode(response.body);

      if (response.statusCode == 200 && res['status'] == true) {
        Get.snackbar('Success', res['message'] ?? 'Interview added successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
        await fetchInterviewList();
        return true;
      } else {
        Get.snackbar('Error', res['message'] ?? 'Failed to create',
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  }

  // ---------------- Update Interview ----------------
  Future<bool> updateInterview({
    required int id,
    required int studentId,
    required int companyId,
    required String date,
    required String dataHtml,
  }) async {
    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => updateInterview(
          id: id,
          studentId: studentId,
          companyId: companyId,
          date: date,
          dataHtml: dataHtml,
        ),
      );
      return false;
    }

    try {
      final payload = {
        'student_info_id': studentId,
        'company_info_id': companyId,
        'date': date,
        'data': dataHtml,
      };

      final response = await http.post(
        Uri.parse('$interviewBankUpdateAPI?id=$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode(payload),
      );

      final res = json.decode(response.body);

      if (response.statusCode == 200 && res['status'] == true) {
        Get.snackbar('Success', res['message'] ?? 'Updated successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
        await fetchInterviewList();
        return true;
      } else {
        Get.snackbar('Error', res['message'] ?? 'Failed to update',
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  }

  // ---------------- Delete Interview ----------------
  Future<bool> deleteInterview(int id) async {
    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => deleteInterview(id),
      );
      return false;
    }

    try {
      final payload = json.encode({'id': id}); // ✅ pass id in body

      final response = await http.delete(
        Uri.parse(interviewBankDeleteAPI), // ❌ no need to add ?id=...
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: payload, // ✅ send id in body
      );

      final res = json.decode(response.body);

      if (response.statusCode == 200 && res['status'] == true) {
        Get.snackbar(
          'Deleted',
          res['message'] ?? 'Entry deleted',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await fetchInterviewList();
        return true;
      } else {
        Get.snackbar(
          'Error',
          res['message'] ?? 'Failed to delete',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Exception: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }


  Future<void> fetchStudentInterviews(int studentId) async {
    isLoadingInterviews.value = true;
    // isLoadingEventList.value = true;// ✅ start loading
    await internetController.checkConnection();

    if (!internetController.isConnected.value) {
      isLoadingInterviews.value = false; // ✅ stop loading
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => fetchStudentInterviews(studentId),
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$interviewBankGetAPI?student_id=$studentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;

        if (responseData['status'] == true && responseData['data'] != null) {
          final interviewList = responseData['data'] as List<dynamic>;
          interviewDataList.assignAll(
            interviewList.map((data) => InterviewBankModel.fromJson(data)).toList(),
          );
          filteredInterviewDataList.assignAll(interviewDataList);
        } else {
          interviewDataList.clear();
          filteredInterviewDataList.clear();
          Get.snackbar(
            "No Data",
            responseData['message'] ?? 'No interviews found for this student',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Server responded with ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load data: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingInterviews.value = false; // ✅ stop loading
    }
  }

}
