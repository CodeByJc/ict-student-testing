import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_mu_students/Helper/Components.dart';
import 'package:ict_mu_students/Helper/colors.dart';
import 'package:ict_mu_students/Helper/size.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MeetingCard extends StatelessWidget {
  final String meetingLink;
  final String meetingDate;
  final String meetingTime;
  final String meetingTitle;
  final String facultyName;

  const MeetingCard({
    super.key,
    required this.meetingLink,
    required this.meetingDate,
    required this.meetingTime,
    required this.meetingTitle,
    required this.facultyName,
  });

  @override
  Widget build(BuildContext context) {
    final meetingDateTime = DateTime.parse('$meetingDate $meetingTime');
    final isMeetingStarted = DateTime.now().isAfter(meetingDateTime);
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: muGrey, borderRadius: BorderRadius.circular(borderRad),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HugeIcon(
                              icon: HugeIcons.strokeRoundedMegaphone02,
                              color: muColor),
                          const SizedBox(width: 5),
                          SizedBox(
                              width: getWidth(context, 0.65),
                              child: Text(meetingTitle,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    overflow: TextOverflow.visible,
                                  ))),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HugeIcon(
                              icon: HugeIcons.strokeRoundedUser,
                              color: muColor),
                          const SizedBox(width: 5),
                          Text(facultyName,
                              style: const TextStyle(
                                fontSize: 17,
                                overflow: TextOverflow.visible,
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: getWidth(context, 0.8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HugeIcon(
                                    icon: HugeIcons.strokeRoundedCalendar03,
                                    color: muColor),
                                const SizedBox(width: 5),
                                Text(
                                    DateFormat('dd / MM / yyyy')
                                        .format(DateTime.parse(meetingDate)),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      overflow: TextOverflow.visible,
                                    )),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HugeIcon(
                                    icon: HugeIcons.strokeRoundedAlarmClock,
                                    color: muColor),
                                const SizedBox(width: 5),
                                Text(
                                  DateFormat("h:mm a").format(DateTime.parse(meetingDate)), // Fix the formatting here
                                  style: const TextStyle(
                                    fontSize: 17,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          isMeetingStarted?await launchUrl(Uri.parse(meetingLink)):null;
                        },
                        child: Card(
                          child: Container(
                            width: getWidth(context, 0.84),
                            height: 50,
                            decoration: BoxDecoration(
                              color: isMeetingStarted?muColor:muGrey2,
                              borderRadius: BorderRadius.circular(borderRad)
                            ),
                            child: Center(child: Text(isMeetingStarted?"JOIN MEETING":"MEETING NOT STARTED",
                              style: TextStyle(
                                color: isMeetingStarted?backgroundColor:Colors.black.withOpacity(0.4),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),
                            )
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}