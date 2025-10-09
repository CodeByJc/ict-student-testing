import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Helper/Utils.dart';
import '../Model/exam_list_model.dart';
import '../Network/API.dart';
import 'internet_connectivity.dart';

class ExamListController extends GetxController {
  final internetController = Get.find<InternetConnectivityController>();
  RxList<ExamListModel> examDataList = <ExamListModel>[].obs;
  int studentId = Get.arguments['student_id'];
  RxBool isLoadingExamList = true.obs;
  @override
  void onInit() {
    super.onInit();
    fetchExamList(sid: studentId);
  }

  Future<void> fetchExamList({required int sid}) async {
    isLoadingExamList.value = true;
    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      isLoadingExamList.value = false;
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => fetchExamList(sid: sid),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(examListAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode({'s_id': sid}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List<dynamic>;
        examDataList.assignAll(
          responseData.map((data) => ExamListModel.fromJson(data)).toList(),
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
        "Error","Failed to get exam data",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingExamList.value = false;
    }
  }

}
