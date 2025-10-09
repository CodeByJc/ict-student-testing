import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_mu_students/Helper/Components.dart';
import 'package:ict_mu_students/Helper/colors.dart';
import 'package:ict_mu_students/Helper/size.dart';
import 'package:get/get.dart';

class TimetableCard extends StatelessWidget {
  final String subjectShortName;
  final String subjectName;
  final String facultyName;
  final String className;
  final String lecType;
  final String startTime;
  final String endTime;

  const TimetableCard({
    super.key,
    required this.subjectShortName,
    required this.subjectName,
    required this.facultyName,
    required this.className,
    required this.lecType,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: muGrey, borderRadius: BorderRadius.circular(borderRad)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      HugeIcon(
                          icon: HugeIcons.strokeRoundedClock01, color: muColor),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          width: getWidth(context, 0.75),
                          child: Text(
                            "${startTime.substring(0, 5)} ${int.parse(startTime.substring(0, 1)) < 12 ? "AM" : "PM"} "
                            " to "
                            "${endTime.substring(0, 5)} ${int.parse(endTime.substring(0, 1)) < 12 ? "AM" : "PM"} ",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                height: 15,
                thickness: 1.5,
                color: muGrey2,
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HugeIcon(icon: HugeIcons.strokeRoundedBook02, color: muColor),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      width: getWidth(context, 0.75),
                      child: Text(
                        "$subjectShortName - ( $subjectName )",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HugeIcon(
                      icon: HugeIcons.strokeRoundedUserCircle, color: muColor),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      width: getWidth(context, 0.75),
                      child: Text(
                        facultyName,
                        style: const TextStyle(
                            fontSize: 16, overflow: TextOverflow.visible),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red,
      colorText: backgroundColor,
    );
  }
}
