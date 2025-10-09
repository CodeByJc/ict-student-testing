import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ict_mu_students/Model/timetable_model.dart';
import '../Helper/Utils.dart';
import '../Network/API.dart';
import 'internet_connectivity.dart';

class TimeTableController extends GetxController {
  final internetController = Get.find<InternetConnectivityController>();
  RxList<TimeTableModel> timetableList = <TimeTableModel>[].obs;
  int studentId = Get.arguments['student_id'];
  RxBool isLoadingTimetable = true.obs;
  @override
  void onInit() {
    super.onInit();
    fetchTimetable(sid: studentId);
  }

  Future<void> fetchTimetable({required int sid}) async {
    isLoadingTimetable.value = true;
    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      isLoadingTimetable.value = false;
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => fetchTimetable(sid: sid),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(timetableAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode({'s_id': sid}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List<dynamic>;
        timetableList.assignAll(
          responseData.map((data) => TimeTableModel.fromJson(data)).toList(),
        );
      } else {
        final responseData = json.decode(response.body) as List<dynamic>;
        timetableList.assignAll(
          responseData.map((data) => TimeTableModel.fromJson(data)).toList(),
        );
      }
    } finally {
      isLoadingTimetable.value = false;
    }
  }
}
