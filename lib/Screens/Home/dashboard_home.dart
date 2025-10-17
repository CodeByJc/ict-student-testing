import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_mu_students/Helper/Components.dart';
import 'package:ict_mu_students/Model/holiday_list_model.dart';
import 'package:ict_mu_students/Widgets/dashboard_icon.dart';
import '../../Helper/colors.dart';
import '../../Model/user_data_model.dart';
import '../../Network/API.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final box = GetStorage();
  late UserData userData;
  late HolidayListModel upcomingHoliday = HolidayListModel(
    id: 0,
    holidayName: "No upcoming holidays",
    holidayDate: "",
  );

  @override
  void initState() {
    super.initState();
    fetchUpcomingHoliday();
    Map<String, dynamic> storedData = box.read('userdata');
    userData = UserData.fromJson(storedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Dashboard",
            style: TextStyle(
                color: Colors.black, fontFamily: "mu_reg", fontSize: 23)),
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            blackTag(
                context,
                muColor,
                "${userData.studentDetails?.firstName} ${userData.studentDetails?.lastName}",
                "Sem: ${userData.classDetails?.semester}  Class: ${userData.classDetails?.className} - ${userData.classDetails?.batch?.toUpperCase()}",
                CachedNetworkImage(
                  imageUrl: studentImageAPI(userData.studentDetails!.grNo),
                  placeholder: (context, url) => HugeIcon(
                    icon: HugeIcons.strokeRoundedUser,
                    size: 30,
                    color: Colors.black,
                  ),
                  errorWidget: (context, url, error) => HugeIcon(
                    icon: HugeIcons.strokeRoundedUser,
                    size: 30,
                    color: Colors.black,
                  ),
                  fit: BoxFit.cover,
                ),
                true,
                '/profile',
                userData),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 0.95,
                padding: const EdgeInsets.all(6),
                children: [
                  TapIcon(
                      name: "Attendance",
                      iconData: HugeIcons.strokeRoundedDocumentValidation,
                      route: "/attendance",
                      routeArg: {
                        'student_id': userData.studentDetails?.studentId
                      }),
                  TapIcon(
                      name: "Timetable",
                      iconData: HugeIcons.strokeRoundedCalendar02,
                      route: "/studentTimetable",
                      routeArg: {
                        'student_id': userData.studentDetails?.studentId
                      }),
                  TapIcon(
                      name: "Examination",
                      iconData: HugeIcons.strokeRoundedDocumentValidation,
                      route: "/examList",
                      routeArg: {
                        'student_id': userData.studentDetails?.studentId
                      }),
                  const TapIcon(
                      name: "Holidays",
                      iconData: HugeIcons.strokeRoundedSun01,
                      route: "/holidayList"),
                  TapIcon(
                      name: "Placements",
                      iconData: HugeIcons.strokeRoundedGraduationScroll,
                      route: "/placements",
                      routeArg: {
                        'student_id': userData.studentDetails?.studentId,
                        'batch_id': userData.studentDetails?.batchId
                      }),
                  TapIcon(
                      name: "Leave",
                      iconData: HugeIcons.strokeRoundedMessageUser01,
                      route: "/leave",
                      routeArg: {
                        'student_id': userData.studentDetails?.studentId
                      }),
                  const TapIcon(
                    name: "Events",
                    iconData: HugeIcons.strokeRoundedRanking,
                    route: "/events",
                  ),
                  TapIcon(
                      name: "Anonymous Feedback",
                      iconData: HugeIcons.strokeRoundedBubbleChatSecure,
                      route: "/feedback",
                      routeArg: {'student_id': 52, 'sem_id': 7}),
                  const TapIcon(
                      name: "Career Guidance",
                      iconData: HugeIcons.strokeRoundedGraduationScroll,
                      route: "/careerGuidance"),
                  const TapIcon(
                      name: "Live Job Market",
                      iconData: HugeIcons.strokeRoundedRanking,
                      route: "/JobMarket"),
                  TapIcon(
                      name: "Announcements",
                      iconData: HugeIcons.strokeRoundedMegaphone01,
                      route: "/announcement",
                      routeArg: {'batch_id': 1}),
                ],
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () => Get.toNamed("/holidayList"),
              highlightColor: backgroundColor,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      offset: const Offset(0, 6),
                      blurRadius: 16,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  child: Row(
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedSun01,
                        size: 28,
                        color: muColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Upcoming Holiday",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'mu_bold'),
                            ),
                            Text(
                              upcomingHoliday.holidayDate.isNotEmpty
                                  ? "${DateFormat('dd-MM-yyyy').format(DateTime.parse(upcomingHoliday.holidayDate))} - ${upcomingHoliday.holidayName}"
                                  : "No upcoming holidays",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: muGrey3,
                                  fontFamily: 'mu_reg'),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchUpcomingHoliday() async {
    try {
      final response = await http.get(
        Uri.parse(upcomingHolidayAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData.isNotEmpty) {
          setState(() {
            upcomingHoliday = HolidayListModel.fromJson(responseData);
          });
        }
      } else {
        throw Exception(
            "Failed to fetch holidays. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching holiday list: $e");
    }
  }
}
