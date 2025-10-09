import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ict_mu_students/Helper/Utils.dart';
import 'package:ict_mu_students/Network/API.dart';
import 'package:ict_mu_students/Controllers/internet_connectivity.dart';
import '../Model/student_rounds_model.dart';
class StudentRoundsController extends GetxController {
  final internetController = Get.find<InternetConnectivityController>();
  RxList<CampusDriveStudentModel> studentDataList = <CampusDriveStudentModel>[].obs;
  RxBool isLoading = true.obs;
  int batchId = Get.arguments['batch_id'];
  int studentId = Get.arguments['student_id'];

  @override
  void onInit() {
    super.onInit();
    fetchStudentRounds();
  }

  Future<void> fetchStudentRounds() async {
    isLoading.value = true;
    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      isLoading.value = false;
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => fetchStudentRounds(),
      );
      return;
    }
    try {
      final response = await http.post(
        Uri.parse(campusDriveStudentRoundsAPI), // Replace with your actual API endpoint constant
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
        final responseData = json.decode(response.body) as List<dynamic>;
        studentDataList.assignAll(
          responseData.map((data) => CampusDriveStudentModel.fromJson(data)).toList(),
        );
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
      print(e.toString());
      Get.snackbar(
        "Error",
        "Failed to get data",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}