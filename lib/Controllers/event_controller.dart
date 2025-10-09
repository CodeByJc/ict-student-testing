import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Helper/Utils.dart';
import '../Model/event_model.dart';
import '../Network/API.dart';
import 'internet_connectivity.dart';

class EventController extends GetxController {
  final internetController = Get.find<InternetConnectivityController>();
  RxList<EventModel> eventDataList = <EventModel>[].obs;
  RxList<EventModel> filteredEventDataList = <EventModel>[].obs;
  final TextEditingController eventSearchController = TextEditingController();
  RxBool isLoadingEventList = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEventsList();
    eventSearchController.addListener(() {
      filterEvents(eventSearchController.text);
    });
  }

  Future<void> fetchEventsList() async {
    isLoadingEventList.value = true;
    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      isLoadingEventList.value = false;
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => fetchEventsList(),
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(eventListAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        if (responseData['status'] == true) {
          final eventList = responseData['data'] as List<dynamic>;
          eventDataList.assignAll(
            eventList.map((data) {
              try {
                return EventModel.fromJson(data);
              } catch (e) {
                print('Error parsing event: $data, error: $e');
                return null; // Skip invalid entries
              }
            }).where((event) => event != null).cast<EventModel>().toList(),
          );
          filteredEventDataList.assignAll(eventDataList);
        } else {
          Get.snackbar(
            "No Data",
            responseData['message'] ?? 'No events available',
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
      print('Error fetching events: $e');
      Get.snackbar(
        "Error",
        "Failed to get event data: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingEventList.value = false;
      print(eventDataList);
    }
  }


  void filterEvents(String query) {
    if (query.isEmpty) {
      filteredEventDataList.assignAll(eventDataList);
    } else {
      filteredEventDataList.assignAll(
        eventDataList
            .where((event) => event.eventTitle
            .toLowerCase()
            .contains(query.toLowerCase()))
            .toList(),
      );
    }
  }
}