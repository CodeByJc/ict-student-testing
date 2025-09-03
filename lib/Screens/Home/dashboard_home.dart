import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_mu_students/Helper/Components.dart';
import 'package:ict_mu_students/Helper/size.dart';
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
                Dark1,
                "${userData.studentDetails?.firstName} ${userData.studentDetails?.lastName}",
                "Sem: ${userData.classDetails?.semester}  Class: ${userData.classDetails?.className} - ${userData.classDetails?.batch?.toUpperCase()}",
                CachedNetworkImage(
                  imageUrl: studentImageAPI(userData.studentDetails!.grNo),
                  placeholder: (context, url) =>  HugeIcon(
                    icon: HugeIcons.strokeRoundedUser,
                    size: 30,
                    color: Colors.black,
                  ),
                  errorWidget: (context, url, error) =>  HugeIcon(
                    icon: HugeIcons.strokeRoundedUser,
                    size: 30,
                    color: Colors.black,
                  ),
                  fit: BoxFit.cover,
                ),
                true,
                '/profile',
                userData),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: SizedBox(
                height: 450,
                width: double.infinity,
                // color: Colors.red,
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.85,
                  padding: const EdgeInsets.all(10),
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
                        routeArg: {
                          'student_id': userData.studentDetails?.studentId,
                          'sem_id':userData.classDetails?.semId
                        }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () => Get.toNamed("/holidayList"),
              highlightColor: backgroundColor,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: getWidth(context, 0.7),
                  decoration: BoxDecoration(
                      color: muGrey,
                      borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(borderRad * 2))),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Upcoming Holiday : ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          if (upcomingHoliday.holidayDate.isNotEmpty)
                            Text(
                                "${DateFormat('dd-MM-yyyy').format(DateTime.parse(upcomingHoliday.holidayDate))} - ${upcomingHoliday.holidayName}",
                                style: TextStyle(fontSize: 17, color: muColor)),
                        ]),
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
