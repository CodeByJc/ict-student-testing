import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ict_mu_students/Controllers/timetable_controller.dart';
import 'package:ict_mu_students/Model/timetable_model.dart';
import '../../Helper/colors.dart';
import '../../Widgets/adaptive_refresh_indicator.dart';
import '../../Widgets/heading_1.dart';
import '../../Widgets/timetable_card.dart';
import '../Exception/data_not_found.dart';
import '../Loading/adaptive_loading_screen.dart';

class TimetableScreen extends GetView<TimeTableController> {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Timetable"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: backgroundColor),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Obx(
          () => controller.isLoadingTimetable.value
              ? const AdaptiveLoadingScreen()
              : AdaptiveRefreshIndicator(
                  onRefresh: () =>
                      controller.fetchTimetable(sid: controller.studentId),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(8, 8, 8, 10),
                        child: Heading1(
                          text: "Today's Timetable",
                          fontSize: 2.5,
                          leftPadding: 8,
                        ),
                      ),
                      Expanded(
                        child: controller.timetableList.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.timetableList.length,
                                itemBuilder: (context, index) {
                                  TimeTableModel timetable =
                                      controller.timetableList[index];
                                  return TimetableCard(
                                    subjectShortName:
                                        timetable.subjectShortName,
                                    subjectName: timetable.subjectName,
                                    facultyName: timetable.facultyName,
                                    className: timetable.className,
                                    lecType: timetable.lecType,
                                    startTime: timetable.startTime,
                                    endTime: timetable.endTime,
                                  );
                                },
                              )
                            : const DataNotFound(),
                      ),
                    ],
                  ),
                ),
        ));
  }
}
