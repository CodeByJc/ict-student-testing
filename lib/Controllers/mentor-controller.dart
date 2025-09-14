import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Helper/Utils.dart';
import '../Network/API.dart';
import '../Model/mentor_model.dart';
import 'internet_connectivity.dart';

class MentorController extends GetxController {
  final internetController = Get.find<InternetConnectivityController>();

  /// non-nullable list of mentors
  RxList<MentorModel> mentorDetail = <MentorModel>[].obs;

  RxBool isLoadingMentor = true.obs;

  int studentId = Get.arguments['student_id'];

  @override
  void onInit() {
    super.onInit();
    fetchMentor(sid: studentId);
  }

  Future<void> fetchMentor({required int sid}) async {
    isLoadingMentor.value = true;
    await internetController.checkConnection();

    if (!internetController.isConnected.value) {
      isLoadingMentor.value = false;
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => fetchMentor(sid: sid),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(getmentorAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode({'s_id': sid}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List<dynamic>;

        mentorDetail.assignAll(
          responseData.map((data) => MentorModel.fromJson(data)).toList(),
        );
      } else {
        Get.snackbar(
          "No Mentor",
          "Mentor not assigned yet",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to get mentor details",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingMentor.value = false;
    }
  }
}
