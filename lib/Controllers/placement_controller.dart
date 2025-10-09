import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ict_mu_students/Model/recently_placed_student_model.dart';
import '../Helper/Utils.dart';
import '../Network/API.dart';
import 'internet_connectivity.dart';

class PlacementController extends GetxController {
  final internetController = Get.find<InternetConnectivityController>();
  RxList<RecentlyPlacedStudentModel> recentlyPlacedStudentList = <RecentlyPlacedStudentModel>[].obs;
  RxBool isLoadingPlacedStudentList = true.obs;
  int batchId = Get.arguments['batch_id'];
  int studentId = Get.arguments['student_id'];

  @override
  void onInit() {
    super.onInit();
    fetchPlacedStudentsList();
  }

  Future<void> fetchPlacedStudentsList() async {
    isLoadingPlacedStudentList.value = true;
    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      isLoadingPlacedStudentList.value = false;
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => fetchPlacedStudentsList(),
      );
      return;
    }
    try {
      final response = await http.post(
        Uri.parse(recentlyPlacedAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode({
          "batch_id" : batchId
        })
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List<dynamic>;
        recentlyPlacedStudentList.assignAll(
          responseData.map((data) => RecentlyPlacedStudentModel.fromJson(data)).toList(),
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
        "Error", "Failed to get data",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingPlacedStudentList.value = false;
    }
  }

}
