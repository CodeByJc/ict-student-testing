import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_mu_students/Helper/Components.dart';
import 'package:ict_mu_students/Model/holiday_list_model.dart';
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
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: blackTag(
              context,
              muColor,
              "${userData.studentDetails?.firstName} ${userData.studentDetails?.lastName}",
              "Sem: ${userData.classDetails?.semester}  Class: ${userData.classDetails?.className} - ${userData.classDetails?.batch?.toUpperCase()}",
              CachedNetworkImage(
                imageUrl: studentImageAPI(userData.studentDetails!.grNo),
                placeholder: (context, url) => const HugeIcon(
                  icon: HugeIcons.strokeRoundedUser,
                  size: 20,
                  color: Colors.black87,
                ),
                errorWidget: (context, url, error) => const HugeIcon(
                  icon: HugeIcons.strokeRoundedUser,
                  size: 20,
                  color: Colors.black87,
                ),
                fit: BoxFit.cover,
              ),
              true,
              '/profile',
              userData,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio:
                    0.9, // Slightly adjusted for better fit in 3x3
                padding: const EdgeInsets.all(10),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: false,
                children: [
                  _buildGridIcon(
                    name: "Attendance",
                    iconData: HugeIcons.strokeRoundedDocumentValidation,
                    route: "/attendance",
                    routeArg: {
                      'student_id': userData.studentDetails?.studentId
                    },
                  ),
                  _buildGridIcon(
                    name: "Timetable",
                    iconData: HugeIcons.strokeRoundedCalendar02,
                    route: "/studentTimetable",
                    routeArg: {
                      'student_id': userData.studentDetails?.studentId
                    },
                  ),
                  _buildGridIcon(
                    name: "Examination",
                    iconData: HugeIcons.strokeRoundedDocumentValidation,
                    route: "/examList",
                    routeArg: {
                      'student_id': userData.studentDetails?.studentId
                    },
                  ),
                  _buildGridIcon(
                    name: "Holidays",
                    iconData: HugeIcons.strokeRoundedSun01,
                    route: "/holidayList",
                  ),
                  _buildGridIcon(
                    name: "Placements",
                    iconData: HugeIcons.strokeRoundedGraduationScroll,
                    route: "/placements",
                    routeArg: {
                      'student_id': userData.studentDetails?.studentId,
                      'batch_id': userData.studentDetails?.batchId
                    },
                  ),
                  _buildGridIcon(
                    name: "Leave",
                    iconData: HugeIcons.strokeRoundedMessageUser01,
                    route: "/leave",
                    routeArg: {
                      'student_id': userData.studentDetails?.studentId
                    },
                  ),
                  _buildGridIcon(
                    name: "Events",
                    iconData: HugeIcons.strokeRoundedRanking,
                    route: "/events",
                  ),
                  _buildGridIcon(
                    name: "Anonymous Feedback",
                    iconData: HugeIcons.strokeRoundedBubbleChatSecure,
                    route: "/feedback",
                    routeArg: {
                      'student_id': userData.studentDetails?.studentId,
                      'sem_id': userData.classDetails?.semId
                    },
                  ),
                  _buildGridIcon(
                    name: "Live Job Market",
                    iconData: HugeIcons.strokeRoundedRanking,
                    route: "/liveJobMarket",
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: InkWell(
              onTap: () => Get.toNamed("/holidayList"),
              borderRadius: BorderRadius.circular(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              HugeIcons.strokeRoundedSun01,
                              color: Color(0xFF0098B5),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Upcoming Holiday",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontFamily: "mu_reg",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (upcomingHoliday.holidayDate.isNotEmpty)
                          Text(
                            "${DateFormat('dd-MM-yyyy').format(DateTime.parse(upcomingHoliday.holidayDate))} - ${upcomingHoliday.holidayName}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF0098B5),
                              fontFamily: "mu_reg",
                            ),
                          )
                        else
                          const Text(
                            "No upcoming holidays",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontFamily: "mu_reg",
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildGridIcon({
    required String name,
    required IconData iconData,
    required String route,
    Map<String, dynamic>? routeArg,
  }) {
    return GestureDetector(
      onTap: () => Get.toNamed(route, arguments: routeArg),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [Color(0xFFE3F2FD), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HugeIcon(
                icon: iconData,
                size: 28, // Further decreased for better fit
                color: const Color(0xFF0098B5),
              ),
              const SizedBox(height: 6),
              Flexible(
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16, // Slightly smaller font for better fit
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    fontFamily: "mu_reg",
                  ),
                ),
              ),
            ],
          ),
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
