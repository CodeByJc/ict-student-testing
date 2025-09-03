import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

import '../Helper/Colors.dart';
import '../Helper/Components.dart';
import '../Helper/size.dart';

class ExamDetailCard extends StatelessWidget {
  final String subjectShortName;
  final String subjectName;
  final String examType;
  final String examDate;
  final int examResultStatus;
  final int totalMarks;
  final double obtainMarks;
  final String grade;

  const ExamDetailCard({
    super.key,
    required this.subjectShortName,
    required this.subjectName,
    required this.examType,
    required this.examDate,
    required this.examResultStatus,
    required this.totalMarks,
    required this.obtainMarks,
    required this.grade,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: muGrey,
              borderRadius: BorderRadius.circular(borderRad),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 0, 15),
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration:
                        BoxDecoration(color: muColor50, shape: BoxShape.circle),
                    child: Center(
                        child: Text(
                      subjectShortName,
                      style: TextStyle(
                          fontSize: 15,
                          color: backgroundColor,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HugeIcon(
                              icon: HugeIcons.strokeRoundedBook02,
                              color: muColor),
                          const SizedBox(width: 5),
                          SizedBox(
                              width: getWidth(context, 0.65),
                              child: Text(subjectName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    overflow: TextOverflow.visible,
                                  )))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HugeIcon(
                              icon: HugeIcons.strokeRoundedCalendar03,
                              color: muColor),
                          const SizedBox(width: 5),
                          SizedBox(
                              width: getWidth(context, 0.65),
                              child: Text(
                                  DateFormat('dd / MM / yyyy')
                                      .format(DateTime.parse(examDate)),
                                  style: const TextStyle(
                                    fontSize: 17,
                                    overflow: TextOverflow.visible,
                                  )))
                        ],
                      ),
                      if (examResultStatus == 1)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                              child: Container(
                                height: 1,
                                width: getWidth(context, 0.7),
                                color: muColor,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: (grade == 'F' || grade == 'Ab')
                                      ? Colors.red.withOpacity(0.3)
                                      : Colors.green.withOpacity(0.3),
                                  borderRadius:
                                      BorderRadius.circular(borderRad)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    HugeIcon(
                                        icon: HugeIcons
                                            .strokeRoundedDocumentValidation,
                                        color: muColor),
                                    const SizedBox(width: 5),
                                    SizedBox(
                                        width: getWidth(context, 0.60),
                                        child: Text(
                                            "$totalMarks / $obtainMarks - ( $grade )",
                                            style: const TextStyle(
                                              fontSize: 17,
                                              overflow: TextOverflow.visible,
                                            )))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 100,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(borderRad),
                      bottomRight: Radius.circular(borderRad)),
                  color: examType.contains('mid')
                      ? muColor50
                      : examType.contains('viva')
                          ? Colors.greenAccent
                          : Colors.amber),
              child: Center(
                child: Text(
                  examType == "mid1"
                      ? "MID - 1"
                      : examType == "mid2"
                          ? "MID - 2"
                          : examType == "viva"
                              ? "VIVA"
                              : "FINAL",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
