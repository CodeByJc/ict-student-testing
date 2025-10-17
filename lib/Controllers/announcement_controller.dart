import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Model/announcement_model.dart';
import '../Network/API.dart';

class AnnouncementController extends GetxController {
  var isLoading = true.obs;
  var announcements = <AnnouncementModel>[].obs;
  int batchId = Get.arguments['batch_id'];

  @override
  void onInit() {
    super.onInit();
    // Safely retrieve route arguments
    final args = Get.arguments ?? {};
    batchId = args['batch_id'] ?? 0;

    fetchAnnouncements();
  }

  Future<void> fetchAnnouncements() async {
    try {
      isLoading(true);

      final response = await http.get(
        Uri.parse('$announcementListAPI?batch_id=$batchId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == true && data['data'] != null) {
          final List<dynamic> list = data['data'];

          // Map and assign all
          final parsed = list.map((a) => AnnouncementModel.fromJson(a)).toList();
          announcements.assignAll(parsed);
        } else {
          announcements.clear();
        }
      } else {
        print('Error: HTTP ${response.statusCode}');
        announcements.clear();
      }
    } catch (e) {
      print('Error fetching announcements: $e');
      announcements.clear();
    } finally {
      isLoading(false);
    }
  }
}
