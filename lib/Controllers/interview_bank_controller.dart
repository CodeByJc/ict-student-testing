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
  RxBool isLoadingEventList = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInterviewList();
    interviewSearchController.addListener(() {
      filterInterviews(interviewSearchController.text);
    });
  }

  Future<void> fetchInterviewList() async {
    isLoadingEventList.value = true;
    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      isLoadingEventList.value = false;
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
        print(responseData);
        if (responseData['status'] == true) {
          final interviewList = responseData['data'] as List<dynamic>;
          interviewDataList.assignAll(
            interviewList.map((data) {
              try {
                return InterviewBankModel.fromJson(data);
              } catch (e) {
                print('Error parsing event: $data, error: $e');
                return null; // Skip invalid entries
              }
            }).where((event) => event != null).cast<InterviewBankModel>().toList(),
          );
          filteredInterviewDataList.assignAll(interviewDataList);
        } else {
          Get.snackbar(
            "No Data",
            responseData['message'] ?? 'No events available',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        final message = json.decode(response.body)['message'] ?? 'An error occurred';
        Get.snackbar(
          "Error",
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error fetching events: $e');
      Get.snackbar(
        "Error",
        "Failed to get event data: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingEventList.value = false;
      print("SIMPLE ----------- $interviewDataList");
      print("FILTERED ----------- $filteredInterviewDataList");
    }
  }


  void filterInterviews(String query) {
    if (query.isEmpty) {
      filteredInterviewDataList.assignAll(interviewDataList);
    } else {
      filteredInterviewDataList.assignAll(
        interviewDataList
            .where((interview) => interview.IBCompanyName.toLowerCase().contains(query.toLowerCase()) ||
            interview.IBStudentName.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }
}