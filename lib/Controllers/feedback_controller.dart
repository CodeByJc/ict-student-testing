import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../Helper/Utils.dart';
import '../Model/faculty_list_model.dart';
import '../Model/feedback_model.dart';
import '../Network/API.dart';
import 'internet_connectivity.dart';

class FeedbackController extends GetxController {
  /// Internet connectivity controller (checks for online/offline status)
  final internetController = Get.find<InternetConnectivityController>();

  /// Feedback history list
  RxList<FeedbackModel> feedbackDataList = <FeedbackModel>[].obs;
  RxBool isLoadingFeedbackList = true.obs;

  /// Faculty list for dropdown
  RxList<FacultyListModel> facultyDataList = <FacultyListModel>[].obs;
  RxBool isLoadingFacultyList = true.obs;

  /// Add feedback loader
  RxBool isAddingFeedback = false.obs;

  /// Student and semester IDs passed from navigation arguments
  int studentId = Get.arguments['student_id'];
  int semId = Get.arguments['sem_id'];

  /// Form state
  final TextEditingController reviewController = TextEditingController();
  Rx<FacultyListModel?> selectedFaculty = Rx<FacultyListModel?>(null);
  RxBool canSubmit = false.obs; // Tracks submit button state

  /// Tracks which feedback reviews are expanded
  RxMap<int, bool> expandedReviews = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();

    // Fetch initial data
    fetchFeedbackList();
    fetchFacultyList();

    // Enable/disable submit button based on review text
    reviewController.addListener(() {
      canSubmit.value = reviewController.text.trim().isNotEmpty;
    });
  }

  @override
  void onClose() {
    reviewController.dispose();
    super.onClose();
  }

  /// Fetch feedback history for the logged-in student
  Future<void> fetchFeedbackList() async {
    isLoadingFeedbackList.value = true;

    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      isLoadingFeedbackList.value = false;
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => fetchFeedbackList(),
      );
      return;
    }

    try {
      final url = Uri.parse('$feedbackHistory?student_id=$studentId');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;

        if (responseData['status'] == true) {
          final feedbackList = responseData['data'] as List<dynamic>;

          // Parse feedback data into models
          feedbackDataList.assignAll(
            feedbackList.map((data) {
              try {
                return FeedbackModel.fromJson(data);
              } catch (e) {
                return null;
              }
            }).where((f) => f != null).cast<FeedbackModel>().toList(),
          );
        } else {
          Get.snackbar(
            "No Data",
            responseData['message'] ?? 'No feedback available',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        final message =
            json.decode(response.body)['message'] ?? 'An error occurred';
        Get.snackbar(
          "Error",
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to get feedback data: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingFeedbackList.value = false;
    }
  }

  /// Add a new feedback entry
  Future<void> addFeedback({
    required String review,
    required int facultyInfoId,
    required int studentInfoId,
  }) async {
    isAddingFeedback.value = true;

    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      isAddingFeedback.value = false;
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => addFeedback(
          review: review,
          facultyInfoId: facultyInfoId,
          studentInfoId: studentInfoId,
        ),
      );
      return;
    }

    try {
      final url = Uri.parse(feedbackAdd);
      final body = {
        'review': review,
        'faculty_info_id': facultyInfoId,
        'student_info_id': studentInfoId,
        'sem_info_id': semId
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;

        if (responseData['status'] == true) {
          Get.snackbar(
            "Success",
            responseData['message'] ?? 'Feedback added successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // Reset form after success
          reviewController.clear();
          selectedFaculty.value = null;

          // Refresh feedback list
          fetchFeedbackList();
        } else {
          Get.snackbar(
            "Error",
            responseData['message'] ?? 'Failed to add feedback',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        final message =
            json.decode(response.body)['message'] ?? 'An error occurred';
        Get.snackbar(
          "Error",
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to add feedback: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isAddingFeedback.value = false;
    }
  }

  /// Fetch faculty list for the student
  Future<void> fetchFacultyList() async {
    isLoadingFacultyList.value = true;

    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      isLoadingFacultyList.value = false;
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => fetchFacultyList(),
      );
      return;
    }

    try {
      final url = Uri.parse(facultyListAPI);
      final body = {'s_id': studentId};

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        final facultyList = (jsonResponse['faculty_list'] as List<dynamic>);

        // Parse faculty list into models
        facultyDataList.assignAll(
          facultyList.map((data) {
            try {
              return FacultyListModel.fromJson(data as Map<String, dynamic>);
            } catch (e) {
              return null;
            }
          }).whereType<FacultyListModel>().toList(),
        );

        // Auto-select the first faculty if available
        if (facultyDataList.isNotEmpty && selectedFaculty.value == null) {
          selectedFaculty.value = facultyDataList.first;
        }

        if (facultyDataList.isEmpty) {
          Get.snackbar(
            "No Data",
            "No faculty available",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        final message =
            json.decode(response.body)['message'] ?? 'An error occurred';
        Get.snackbar(
          "Error",
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to get faculty data: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingFacultyList.value = false;
    }
  }

  /// Toggle expanded/collapsed state for a feedback review
  void toggleReviewExpansion(int feedbackId) {
    expandedReviews[feedbackId] = !(expandedReviews[feedbackId] ?? false);
  }
}
