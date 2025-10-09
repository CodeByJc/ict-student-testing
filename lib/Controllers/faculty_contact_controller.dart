import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ict_mu_students/Model/faculty_contact_model.dart';
import '../Helper/Utils.dart';
import '../Network/API.dart';
import 'internet_connectivity.dart';

class FacultyContactController extends GetxController {
  final internetController = Get.find<InternetConnectivityController>();
  RxList<FacultyContactModel> facultyContactList = <FacultyContactModel>[].obs;
  int studentId = Get.arguments['student_id'];
  RxBool isLoadingFacultyContact = true.obs;
  @override
  void onInit() {
    super.onInit();
    fetchFacultyContact(sid: studentId);
  }

  Future<void> fetchFacultyContact({required int sid}) async {
    isLoadingFacultyContact.value = true;
    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      isLoadingFacultyContact.value = false;
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => fetchFacultyContact(sid: sid),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(facultyContactAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode({'s_id': sid}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List<dynamic>;
        facultyContactList.assignAll(
          responseData.map((data) => FacultyContactModel.fromJson(data)).toList(),
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
      Get.snackbar(
        "Error","Failed to get contacts",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingFacultyContact.value = false;
    }
  }

}
