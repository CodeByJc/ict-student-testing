import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_mu_students/Controllers/feedback_controller.dart';
import 'package:ict_mu_students/Helper/Style.dart';
import 'package:ict_mu_students/Helper/Components.dart';
import 'package:ict_mu_students/Helper/colors.dart';
import 'package:ict_mu_students/Helper/size.dart';
import 'package:ict_mu_students/Widgets/adaptive_refresh_indicator.dart';
import 'package:ict_mu_students/Widgets/heading_1.dart';
import 'package:intl/intl.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import '../../Animations/slide_zoom_in_animation.dart';
import '../../Model/faculty_list_model.dart';
import '../Loading/adaptive_loading_screen.dart';

class FeedbackScreen extends GetView<FeedbackController> {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();

    String? formatDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return null;
      DateTime dateTime = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    }

    String? formatTime(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return null;
      DateTime dateTime = DateTime.parse(dateStr);
      return DateFormat('hh:mm a').format(dateTime);
    }

    // Show confirmation dialog for submitting feedback
    void showConfirmationDialog() {
      if (controller.selectedFaculty.value == null) {
        Get.snackbar(
          "Error",
          "Please select a faculty",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.question,
          showCancelBtn: true,
          title: "Confirm",
          text: "Are you sure you want to submit this feedback?",
          confirmButtonText: "Yes, Submit",
          cancelButtonColor: Colors.redAccent,
          cancelButtonText: "Cancel",
          confirmButtonColor: muColor,
          onConfirm: () async {
            Get.back();
            await controller.addFeedback(
              review: controller.reviewController.text,
              facultyInfoId: controller.selectedFaculty.value!.facultyId,
              studentInfoId: controller.studentId,
            );
          },
          onCancel: () {},
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Anonymous Feedback",
          style: appbarStyle(context),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: backgroundColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
            () => controller.isLoadingFeedbackList.value || controller.isLoadingFacultyList.value
            ? const AdaptiveLoadingScreen()
            : AdaptiveRefreshIndicator(
          onRefresh: () => controller.fetchFeedbackList(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Heading1(text: "Submit Feedback", fontSize: 2.5, leftPadding: 0),
                  const SizedBox(height: 20),
                  // Faculty Dropdown
                  Obx(
                        () => DropdownButtonFormField<FacultyListModel>(
                      value: controller.selectedFaculty.value,
                      decoration: InputDecoration(
                        labelText: controller.facultyDataList.isEmpty
                            ? "No Faculty Available"
                            : "Select Faculty",
                        labelStyle: TextStyle(
                          fontFamily: "mu_reg",
                          color: muGrey3,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: muGrey3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: muColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: controller.facultyDataList.isEmpty
                          ? [
                        DropdownMenuItem<FacultyListModel>(
                          value: null,
                          child: Text(
                            "No faculty available",
                            style: TextStyle(
                              fontSize: getSize(context, 2),
                              fontFamily: "mu_reg",
                              color: muGrey3,
                            ),
                          ),
                        )
                      ]
                          : controller.facultyDataList.map((faculty) {
                        return DropdownMenuItem<FacultyListModel>(
                          value: faculty,
                          child: Text(
                            "${faculty.facultyName} (${faculty.facultySubjectShortName})",
                            style: TextStyle(
                              fontSize: getSize(context, 2),
                              fontFamily: "mu_reg",
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: controller.facultyDataList.isEmpty
                          ? null
                          : (FacultyListModel? newValue) {
                        controller.selectedFaculty.value = newValue;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Review TextField
                  Obx(
                        () => TextField(
                      controller: controller.reviewController,
                      focusNode: focusNode,
                      cursorColor: muColor,
                      enabled: controller.selectedFaculty.value != null, // Enable only if faculty is selected
                      decoration: InputDecoration(
                        labelText: "Review",
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelStyle: TextStyle(
                          fontFamily: "mu_reg",
                          color: focusNode.hasFocus ? muColor : muGrey3,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: muColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: muGrey3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: muGrey3.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      maxLines: 5,
                      style: TextStyle(
                        fontSize: getSize(context, 2),
                        fontFamily: "mu_reg",
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Submit Button
                  Obx(
                        () => ElevatedButton(
                      onPressed: controller.canSubmit.value && !controller.isAddingFeedback.value
                          ? () {
                        showConfirmationDialog();
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: muColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Submit Feedback",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: getSize(context, 2),
                          fontFamily: "mu_reg",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: Divider(color: muGrey2),
                  ),
                  const Heading1(text: "Feedback History", fontSize: 2.5, leftPadding: 0),
                  const SizedBox(height: 10),
                  Obx(
                        () => controller.feedbackDataList.isNotEmpty
                        ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.feedbackDataList.length,
                      itemBuilder: (context, index) {
                        final feedback = controller.feedbackDataList[index];
                        String? dateStr = formatDate(feedback.feedbackDate);
                        String? timeStr = formatTime(feedback.feedbackDate);

                        return SlideZoomInAnimation(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: muGrey,
                                    borderRadius: BorderRadius.circular(borderRad),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          HugeIcon(
                                            icon: HugeIcons.strokeRoundedComment01,
                                            color: muColor,
                                          ),
                                          const SizedBox(width: 7),
                                          Expanded(
                                            child: Obx(
                                                  () {
                                                bool isExpanded = controller
                                                    .expandedReviews[
                                                feedback.feedbackId] ??
                                                    false;
                                                bool needsExpansion =
                                                    feedback.feedbackReview.length >
                                                        50 ||
                                                        feedback.feedbackReview
                                                            .contains('\n');

                                                return GestureDetector(
                                                  onTap: () {
                                                    if (needsExpansion) {
                                                      controller.toggleReviewExpansion(
                                                          feedback.feedbackId);
                                                    }
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(
                                                            right: 100), // Prevent overlap with tag
                                                        child: Text(
                                                          "Review: ${feedback.feedbackReview}",
                                                          maxLines: isExpanded ? null : 1,
                                                          overflow: isExpanded
                                                              ? null
                                                              : TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            fontSize: getSize(context, 2),
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      if (needsExpansion)
                                                        Padding(
                                                          padding: const EdgeInsets.only(
                                                              top: 2, right: 100),
                                                          child: Text(
                                                            isExpanded
                                                                ? "show less"
                                                                : "show more...",
                                                            style: TextStyle(
                                                              fontSize:
                                                              getSize(context, 1.8),
                                                              color: muColor,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          HugeIcon(
                                            icon: HugeIcons.strokeRoundedUser,
                                            color: muColor,
                                          ),
                                          const SizedBox(width: 7),
                                          Text('To: ${feedback.feedbackFacultyName}',
                                            style: TextStyle(
                                              fontSize: getSize(context, 2),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          HugeIcon(
                                            icon: HugeIcons.strokeRoundedCalendar03,
                                            color: muColor,
                                          ),
                                          const SizedBox(width: 7),
                                          Text(
                                            dateStr ?? 'N/A',
                                            style: TextStyle(
                                              fontSize: getSize(context, 2),
                                            ),
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
                                      color: feedback.feedbackStatus == 0
                                          ? Colors.amber
                                          : Colors.green,
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        feedback.feedbackStatus == 0
                                            ? "Not Viewed"
                                            : "Viewed",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: getSize(context, 1.8),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                        : Center(
                      child: Text(
                        "No feedback history found",
                        style: TextStyle(
                          fontSize: getSize(context, 2),
                          color: muGrey2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}