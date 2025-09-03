import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:mime/mime.dart';
import 'package:file_picker/file_picker.dart';
import '../Helper/Utils.dart';
import '../Model/leave_model.dart';
import '../Network/API.dart';
import '../Screens/PDF/pdf_viewer_screen.dart';
import 'internet_connectivity.dart';

class LeaveController extends GetxController {
  final internetController = Get.find<InternetConnectivityController>();
  RxList<LeaveModel> leaveHistory = <LeaveModel>[].obs;
  final TextEditingController reasonController = TextEditingController(); // Add this
  int studentId = Get.arguments['student_id'];
  RxBool isLoadingLeaveHistory = true.obs;
  RxBool isSubmittingLeave = false.obs;
  RxString selectedFilePath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeaveHistory(studentId: studentId);
  }
  void viewPDF(String documentPath) {
    Get.to(() => PDFViewerScreen(documentPath: documentPath));
  }

  Future<void> fetchLeaveHistory({required int studentId}) async {
    isLoadingLeaveHistory.value = true;
    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      isLoadingLeaveHistory.value = false;
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => fetchLeaveHistory(studentId: studentId),
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$leaveHistoryAPI/getLeaveHistory?student_info_id=$studentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status']) {
          leaveHistory.assignAll(
            (responseData['data'] as List).map((data) => LeaveModel.fromJson(data)).toList(),
          );
        } else {
          Get.snackbar("No Data", responseData['message'], backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar("Error", "Failed to fetch leave history: ${response.body}", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to get leave history: $e", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoadingLeaveHistory.value = false;
    }
  }

  Future<void> pickPDF() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.single.path != null) {
        selectedFilePath.value = result.files.single.path!;
        // Get.snackbar("File Selected", "PDF: ${result.files.single.name}", backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        selectedFilePath.value = '';
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick PDF: $e", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<bool> submitLeaveRequest({
    required int studentId,
    required String reason,
  }) async {
    isSubmittingLeave.value = true;
    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      isSubmittingLeave.value = false;
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => submitLeaveRequest(studentId: studentId, reason: reason),
      );
      return false;
    }

    if (reason.isEmpty) {
      Get.snackbar("Error", "Reason is required", backgroundColor: Colors.red, colorText: Colors.white);
      isSubmittingLeave.value = false;
      return false;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(leaveRequestAPI),
      );
      request.headers.addAll({
        'Authorization': validApiKey,
      });
      request.fields['student_info_id'] = studentId.toString();
      request.fields['reason'] = reason;

      if (selectedFilePath.value.isNotEmpty) {
        final mimeType = lookupMimeType(selectedFilePath.value) ?? 'application/pdf';
        request.files.add(await http.MultipartFile.fromPath(
          'document_proof',
          selectedFilePath.value,
          contentType: http_parser.MediaType.parse(mimeType),
        ));
      }

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(responseData.body);
        if (jsonResponse['status']) {
          Get.snackbar("Success", jsonResponse['message'], backgroundColor: Colors.green, colorText: Colors.white);
          selectedFilePath.value = '';
          await fetchLeaveHistory(studentId: studentId);
          return true;
        } else {
          Get.snackbar("Error", jsonResponse['message'], backgroundColor: Colors.red, colorText: Colors.white);
          return false;
        }
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode} - ${responseData.body}", backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to submit leave: $e", backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    } finally {
      isSubmittingLeave.value = false;
    }
  }
}