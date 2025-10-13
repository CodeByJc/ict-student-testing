import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ict_mu_students/Controllers/faculty_contact_controller.dart';
import 'package:ict_mu_students/Model/faculty_list_model.dart';
import '../../Model/mentor_model.dart';

import 'package:ict_mu_students/Screens/Loading/adaptive_loading_screen.dart';
import 'package:ict_mu_students/Widgets/adaptive_refresh_indicator.dart';
import 'package:ict_mu_students/Widgets/faculty_contact_card.dart';
import '../../Helper/colors.dart';
import '../Exception/data_not_found.dart';

class FacultyContactScreen extends GetView<FacultyContactController> {
  const FacultyContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Faculty Contacts"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: backgroundColor),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Obx(
              () => controller.isLoadingFacultyContact.value
              ? const AdaptiveLoadingScreen()
              : AdaptiveRefreshIndicator(
            onRefresh: () =>
                controller.fetchFacultyContact(sid: controller.studentId),
            child: controller.facultyContactList.isNotEmpty
                ? ListView(
              shrinkWrap: true,
              children: [
                // 🔹 Mentor details block (shown once)
                if (controller.mentorDetails.value != null) ...[
                  Card(
                    margin: const EdgeInsets.all(12),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mentor",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text("Name: ${controller.mentorDetails.value!.mentorName}"),
                          Text("Mobile: ${controller.mentorDetails.value!.mentorPhone}"),
                          Text("Cabin: ${controller.mentorDetails.value!.mentorCabin}"),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                ],

                // 🔹 Faculty contact list
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.facultyContactList.length,
                  itemBuilder: (context, index) {
                    final faculty = controller.facultyContactList[index];
                    return FacultyContactCard(
                      subjectShortName: faculty.subjectShortName,
                      subjectName: faculty.subjectName,
                      facultyName: faculty.facultyName,
                      mobileNo: faculty.mobileNo, // ✅ fixed
                    );
                  },
                ),
              ],
            )
                : const DataNotFound(),
          ),
        )
    );
  }
}
