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
  final internetController = Get.find<InternetConnectivityController>();
  RxList<FeedbackModel> feedbackDataList = <FeedbackModel>[].obs;
  RxBool isLoadingFeedbackList = true.obs;
  RxList<FacultyListModel> facultyDataList = <FacultyListModel>[].obs;
  RxBool isLoadingFacultyList = true.obs;
  RxBool isAddingFeedback = false.obs;
  int studentId = Get.arguments['student_id'];
  int semId = Get.arguments['sem_id'];

  // Form state
  final TextEditingController reviewController = TextEditingController();
  Rx<FacultyListModel?> selectedFaculty = Rx<FacultyListModel?>(null);
  RxBool canSubmit = false.obs; // Tracks submit button state

  // Feedback history expansion state
  RxMap<int, bool> expandedReviews = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFeedbackList();
    fetchFacultyList();
    // Listen to reviewController changes to update canSubmit
    reviewController.addListener(() {
      canSubmit.value = reviewController.text.trim().isNotEmpty;
    });
  }

  @override
  void onClose() {
    reviewController.dispose();
    super.onClose();
  }

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
      final response = await http.get(
        Uri.parse('$feedbackHistory?student_id=$studentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        if (responseData['status'] == true) {
          final feedbackList = responseData['data'] as List<dynamic>;
          feedbackDataList.assignAll(
            feedbackList.map((data) {
              try {
                return FeedbackModel.fromJson(data);
              } catch (e) {
                print('Error parsing feedback: $data, error: $e');
                return null; // Skip invalid entries
              }
            }).where((feedback) => feedback != null).cast<FeedbackModel>().toList(),
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
        final message = json.decode(response.body)['message'] ?? 'An error occurred';
        Get.snackbar(
          "Error",
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error fetching feedback: $e');
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
      final response = await http.post(
        Uri.parse(feedbackAdd),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode({
          'review': review,
          'faculty_info_id': facultyInfoId,
          'student_info_id': studentInfoId,
          'sem_info_id': semId
        }),
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
          // Clear form after successful submission
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
        final message = json.decode(response.body)['message'] ?? 'An error occurred';
        Get.snackbar(
          "Error",
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error adding feedback: $e');
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
      final response = await http.post(
        Uri.parse(facultyListAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode({
          's_id': studentId,
        }),
      );

      if (response.statusCode == 200) {
        final facultyList = json.decode(response.body) as List<dynamic>;
        facultyDataList.assignAll(
          facultyList.map((data) {
            try {
              return FacultyListModel.fromJson(data);
            } catch (e) {
              print('Error parsing faculty: $data, error: $e');
              return null; // Skip invalid entries
            }
          }).where((faculty) => faculty != null).cast<FacultyListModel>().toList(),
        );
        if (facultyDataList.isEmpty) {
          Get.snackbar(
            "No Data",
            "No faculty available",
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
      print('Error fetching faculty list: $e');
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

  // Toggle expansion state for feedback items
  void toggleReviewExpansion(int feedbackId) {
    expandedReviews[feedbackId] = !(expandedReviews[feedbackId] ?? false);
  }
}