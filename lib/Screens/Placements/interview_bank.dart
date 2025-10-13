import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ict_mu_students/Animations/slide_zoom_in_animation.dart';
import 'package:ict_mu_students/Model/interview_bank_model.dart';
import 'package:intl/intl.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_mu_students/Helper/size.dart';
import '../../Controllers/interview_bank_controller.dart';
import '../../Helper/Components.dart';
import '../../Helper/colors.dart';
import '../../Widgets/adaptive_refresh_indicator.dart';
import '../Exception/data_not_found.dart';
import '../Loading/adaptive_loading_screen.dart';

class InterviewBankScreen extends GetView<InterviewBankController> {
  const InterviewBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();

    // Fetch interview list after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.interviewDataList.isEmpty) {
        controller.fetchInterviewList();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Interview Bank"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: backgroundColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
            () => Column(
          children: [
            // 🔍 Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: TextField(
                controller: controller.interviewSearchController,
                cursorColor: muColor,
                focusNode: focusNode,
                decoration: InputDecoration(
                  labelText: 'Search Students/Companies',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: TextStyle(
                    fontFamily: "mu_reg",
                    color: muGrey2,
                  ),
                  prefixIcon: HugeIcon(
                    icon: HugeIcons.strokeRoundedSearch01,
                    color: focusNode.hasPrimaryFocus ? muColor : muGrey2,
                  ),
                  suffixIcon:
                  controller.interviewSearchController.text.isNotEmpty
                      ? IconButton(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedCancel01,
                      color: focusNode.hasFocus ? muColor : muGrey2,
                    ),
                    onPressed: () {
                      controller.interviewSearchController.clear();
                      controller.filterInterviews('');
                    },
                  )
                      : null,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: muColor),
                    borderRadius: BorderRadius.circular(borderRad),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: muGrey2),
                    borderRadius: BorderRadius.circular(borderRad),
                  ),
                ),
                style: TextStyle(
                  fontSize: getSize(context, 2.5),
                  fontFamily: "mu_reg",
                  fontWeight: FontWeight.w500,
                ),
                onChanged: controller.filterInterviews,
              ),
            ),

            const SizedBox(height: 10),

            // 📋 List / Loader / Empty State
            Expanded(
              child: controller.isLoadingInterviews.value
                  ? const AdaptiveLoadingScreen()
                  : AdaptiveRefreshIndicator(
                onRefresh: () => controller.fetchInterviewList(),
                child: controller.filteredInterviewDataList.isNotEmpty
                    ? ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                  controller.filteredInterviewDataList.length,
                  itemBuilder: (context, index) {
                    InterviewBankModel interview =
                    controller.filteredInterviewDataList[index];
                    return SlideZoomInAnimation(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: muGrey,
                            borderRadius: BorderRadius.all(
                              Radius.circular(borderRad),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () => Get.toNamed(
                                'interviewDetails',
                                arguments: {
                                  'interview': interview,
                                },
                              ),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      HugeIcon(
                                        icon: HugeIcons
                                            .strokeRoundedUser,
                                        color: muColor,
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          interview.IBStudentName,
                                          style: TextStyle(
                                            fontSize:
                                            getSize(context, 2),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      HugeIcon(
                                        icon: HugeIcons
                                            .strokeRoundedBuilding05,
                                        color: muColor,
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          interview.IBCompanyName,
                                          style: TextStyle(
                                            fontSize:
                                            getSize(context, 2),
                                            fontWeight:
                                            FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      HugeIcon(
                                        icon: HugeIcons
                                            .strokeRoundedCalendar01,
                                        color: muColor,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        DateFormat('dd-MM-yyyy')
                                            .format(
                                          DateFormat('yyyy-MM-dd')
                                              .parse(interview.IBDate),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
                    : const DataNotFound(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
