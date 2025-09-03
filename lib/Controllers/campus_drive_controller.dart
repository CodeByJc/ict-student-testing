import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Helper/Utils.dart';
import '../Model/campus_drive_model.dart';
import '../Network/API.dart';
import 'internet_connectivity.dart';

class CampusDriveController extends GetxController {
  final internetController = Get.find<InternetConnectivityController>();
  RxList<CampusDriveModel> campusDriveList = <CampusDriveModel>[].obs;
  RxList<CampusDriveModel> filteredCampusDriveList = <CampusDriveModel>[].obs;
  RxBool isLoadingCampusDrive = false.obs;
  RxBool isLoadingStatusUpdate = false.obs;
  final TextEditingController searchController = TextEditingController();
  int studentId = Get.arguments['student_id'];


  @override
  void onInit() {
    super.onInit();
    fetchCampusDriveList();
    searchController.addListener(() {
      filterCampusDrive(searchController.text);
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchCampusDriveList() async {
    int batchId = Get.arguments['batch_id'];
    int studentId = Get.arguments['student_id'];
    isLoadingCampusDrive.value = true;
    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      isLoadingCampusDrive.value = false;
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => fetchCampusDriveList(),
      );
      return;
    }
    try {
      final response = await http.post(
        Uri.parse(campusDriveListAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode({
          "batch_id": batchId,
          "student_id": studentId,
        }),
      );

      if (response.statusCode == 200) {
        // Explicitly cast the decoded JSON to List<Map<String, dynamic>>
        final List<dynamic> responseData = json.decode(response.body);
        campusDriveList.assignAll(
          responseData
              .map<CampusDriveModel>((data) => CampusDriveModel.fromJson(data as Map<String, dynamic>))
              .toList(),
        );
        filteredCampusDriveList.assignAll(campusDriveList); // Initialize filtered list
      } else {
        final message = json.decode(response.body)['message'] ?? 'An error occurred';
        Get.snackbar(
          "No data available",
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to get data: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print(e);
    } finally {
      isLoadingCampusDrive.value = false;
    }
  }

  Future<void> statusUpdate(int campusDriveId, String status) async {
    isLoadingStatusUpdate.value = true;
    await internetController.checkConnection();

    if (!internetController.isConnected.value) {
      isLoadingStatusUpdate.value = false;
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => fetchCampusDriveList(),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(statusUpdateCampusDriveAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode({
          "student_id": studentId,
          "campus_drive_id": campusDriveId,
          "status": status,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          responseData['message'] ?? "Status updated successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchCampusDriveList();
      } else {
        final message = responseData['message'] ?? 'An error occurred';
        Get.snackbar(
          "No data available",
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update status: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingStatusUpdate.value = false;
    }
  }


  void filterCampusDrive(String query) {
    if (query.isEmpty) {
      filteredCampusDriveList.assignAll(campusDriveList);
    } else {
      filteredCampusDriveList.assignAll(
        campusDriveList
            .where((drive) => drive.campusDriveCompanyName
            .toLowerCase()
            .contains(query.toLowerCase()))
            .toList(),
      );
    }
  }
}