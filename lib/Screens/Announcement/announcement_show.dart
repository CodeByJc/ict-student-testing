import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/announcement_controller.dart';
import '../../Helper/Colors.dart';
import '../../Model/announcement_model.dart';
import '../../Helper/colors.dart' hide muColor;

class AnnouncementShowScreen extends StatelessWidget {
  const AnnouncementShowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AnnouncementController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.announcements.isEmpty) {
          return const Center(
            child: Text(
              'No announcements available.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchAnnouncements,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.announcements.length,
            itemBuilder: (context, index) {
              final AnnouncementModel ann = controller.announcements[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Icon(
                    Icons.campaign_rounded,
                    color: muColor,
                    size: 36,
                  ),
                  title: Text(
                    ann.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        ann.description,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ✅ Show faculty name instead of ID
                          Text(
                            'Faculty: ${ann.facultyName}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            ann.date,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
