import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_mu_students/Helper/Components.dart';
import 'package:intl/intl.dart';

import '../../Controllers/announcement_controller.dart';
import '../../Helper/colors.dart';
import '../../Model/announcement_model.dart' show AnnouncementModel;
import '../../Helper/size.dart';

class AnnouncementShowScreen extends StatelessWidget {
  const AnnouncementShowScreen({super.key});

  Future<void> _refreshAnnouncements(AnnouncementController controller) async {
    await controller.fetchAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    final AnnouncementController _controller = Get.find<AnnouncementController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        centerTitle: true,
        backgroundColor: muColor,
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.announcements.isEmpty) {
          return const Center(
            child: Text(
              'No announcements available.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        // Use Expanded inside a Column, but here as root just use RefreshIndicator
        return RefreshIndicator(
          onRefresh: () => _refreshAnnouncements(_controller),
          child: ListView.builder(
            itemCount: _controller.announcements.length,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
            itemBuilder: (context, index) {
              AnnouncementModel ann = _controller.announcements[index];
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: muGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              HugeIcon(
                                  icon: HugeIcons.strokeRoundedMegaphone01,
                                  color: muColor
                              ),
                              const SizedBox(width: 7),
                              Flexible(
                                child: Text(
                                  ann.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: getSize(context, 2.2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            ann.description,
                            style: TextStyle(fontSize: getSize(context, 1.9)),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              HugeIcon(
                                  icon: HugeIcons.strokeRoundedUserCircle,
                                  color: muColor),
                              const SizedBox(width: 7),
                              Text(
                                ann.facultyName.isNotEmpty
                                    ? ann.facultyName
                                    : "Unknown Faculty",
                                style: TextStyle(
                                    fontSize: getSize(context, 1.8),
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 100,
                        height: 25,
                        decoration: BoxDecoration(
                          color: muColor,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            (ann.date.isNotEmpty)
                                ? DateFormat('dd-MM-yyyy').format(
                                DateFormat('yyyy-MM-dd').parse(ann.date))
                                : "",
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}