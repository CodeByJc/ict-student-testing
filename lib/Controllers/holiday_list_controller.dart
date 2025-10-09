import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ict_mu_students/Model/holiday_list_model.dart';
import '../Helper/Utils.dart';
import '../Network/API.dart';
import 'internet_connectivity.dart';

class HolidayListController extends GetxController {
  final internetController = Get.find<InternetConnectivityController>();
  RxList<HolidayListModel> holidayDataList = <HolidayListModel>[].obs;
  RxBool isLoadingHolidayList = true.obs;

  /// Make the ScrollController public
  final ScrollController scrollController = ScrollController();
  int? highlightedIndex;

  @override
  void onInit() {
    super.onInit();
    fetchHolidayList();
    Future.delayed(const Duration(milliseconds: 500), () {
      scrollToUpcomingHoliday();
    });
  }

  void scrollToUpcomingHoliday() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (holidayDataList.isEmpty) return; // No holidays available

      DateTime today = DateTime.now();
      for (int i = 0; i < holidayDataList.length; i++) {
        DateTime holidayDate = DateFormat('yyyy-MM-dd').parse(holidayDataList[i].holidayDate);
        if (holidayDate.isAfter(today)) {
          highlightedIndex = i;
          update(); // Force UI to rebuild
          scrollController.animateTo(
            i * 75, // Adjust based on your UI row height
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
          return;
        }
      }
    });
  }

  Future<void> fetchHolidayList() async {
    isLoadingHolidayList.value = true;
    highlightedIndex = null; // Reset before fetching
    update();

    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      isLoadingHolidayList.value = false;
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => fetchHolidayList(),
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(holidayListAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List<dynamic>;
        holidayDataList.assignAll(
          responseData.map((data) => HolidayListModel.fromJson(data)).toList(),
        );

        scrollToUpcomingHoliday(); // Ensure scrolling + highlighting happens after list update
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
        "Error", "Failed to get holidays",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingHolidayList.value = false;
    }
  }


}
