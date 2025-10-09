import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ict_mu_students/Animations/slide_zoom_in_animation.dart';
import 'package:ict_mu_students/Helper/Style.dart';
import 'package:ict_mu_students/Screens/Loading/adaptive_loading_screen.dart';
import 'package:ict_mu_students/Widgets/adaptive_refresh_indicator.dart';
import 'package:ict_mu_students/Widgets/heading_1.dart';
import '../../Controllers/student_round_controller.dart';
import '../../Helper/Components.dart';
import '../../Helper/colors.dart';
import '../../Model/student_rounds_model.dart';

class StudentRoundsScreen extends GetView<StudentRoundsController> {
  const StudentRoundsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Campus Drive Rounds",
          style: appbarStyle(context),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: backgroundColor),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: AdaptiveRefreshIndicator(
        onRefresh: () async => await controller.fetchStudentRounds(),
        child: Obx(
              () =>
          controller.isLoading.value
              ? const AdaptiveLoadingScreen()
              : controller.studentDataList.isEmpty
              ? const Center(child: Text('No data available'))
              : ListView.builder(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            itemCount: controller.studentDataList.length,
            itemBuilder: (context, index) {
              final data = controller.studentDataList[index];
              return SlideZoomInAnimation(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: muGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Heading1(
                        text: data.companyName,
                        fontSize: 2.5,
                        leftPadding: 0,
                      ),
                      SizedBox(height: 15,
                        child: Divider(color: muGrey2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildStepper(context, data),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStepper(BuildContext context, CampusDriveStudentModel data) {
    final rounds = data.rounds;
    final currentIndex = data.studentCurrentRoundIndex;
    final status = data.studentCurrentRoundStatus.toLowerCase();

    return Column(
      children: [
        // Colored progress bar segments
        Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(rounds.length - 1, (index) {
                Color segmentColor;
                if (status == 'reject' && index + 1 == currentIndex - 1) {
                  segmentColor = Colors.red;
                } else if (status == 'reject' && index + 1 >= currentIndex) {
                  segmentColor = Colors.grey;
                } else if (index + 1 < currentIndex) {
                  segmentColor = Colors.green;
                } else {
                  segmentColor = Colors.grey;
                }

                return Expanded(
                  child: Container(
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    color: segmentColor,
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),

            // Stepper dots
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(rounds.length, (index) {
                final stepColor = status == 'reject' && index + 1 == currentIndex
                    ? Colors.red
                    : index + 1 <= currentIndex
                    ? Colors.green
                    : Colors.grey;

                return Tooltip(
                  message: rounds[index].roundName,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: stepColor,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: getSize(context, 1.6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Round names
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rounds.asMap().entries.map((entry) {
            final index = entry.key;
            final round = entry.value;

            return Flexible(
              child: Text(
                round.roundName,
                style: TextStyle(
                  fontSize: getSize(context, 1.3),
                  color: status == 'reject' && index + 1 == currentIndex
                      ? Colors.red
                      : index + 1 <= currentIndex
                      ? Colors.green
                      : Colors.grey,
                  overflow: TextOverflow.ellipsis,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

}