import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ict_mu_students/Helper/colors.dart';
import 'package:ict_mu_students/Helper/Components.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:http/http.dart' as http;
import '../Model/attendance_by_date_model.dart';
import '../Model/total_attendance_model.dart';
import '../Network/API.dart';

class AttendanceShowController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxList<TotalAttendance> attendanceList = <TotalAttendance>[].obs;
  RxList<AttendanceByDate> todayAttendanceList = <AttendanceByDate>[].obs;
  RxBool isLoadingAttendanceShow = true.obs;
  RxBool titleTap = false.obs;

  RxDouble totalAttendance = (0.0).obs;
  RxDouble totalExtra = (0.0).obs;
  RxDouble totalPresent = (0.0).obs;
  RxDouble totalLecL = (0.0).obs;
  RxDouble attendLecL = (0.0).obs;
  RxDouble totalLecT = (0.0).obs;
  RxDouble attendLecT = (0.0).obs;

  double get avgAttendance {
    return totalAttendance.value > 0.0
        ? ((totalPresent.value + totalExtra.value) / totalAttendance.value) *
            100.0
        : 0.0;
  }

  String formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());
  Rx<AnimationController>? animationController; // Make it reactive

  @override
  void onInit() {
    super.onInit();
    isLoadingAttendanceShow.value = true;
    fetchAttendance();
    fetchTodayAttendance();
    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    ).obs;
    animationController!.value.repeat(reverse: true);
    isLoadingAttendanceShow.value = false;
  }

  @override
  void dispose() {
    animationController?.value.dispose();
    super.dispose();
  }

  List<TableRow> buildMergedTableRows() {
    Map<String, List<TotalAttendance>> groupedAttendance = {};
    // Group attendance by subjectShortName
    for (var attendance in attendanceList) {
      if (!groupedAttendance.containsKey(attendance.subjectShortName)) {
        groupedAttendance[attendance.subjectShortName] = [];
      }
      groupedAttendance[attendance.subjectShortName]!.add(attendance);
    }

    List<TableRow> rows = [];
    totalLecL.value = 0;
    attendLecL.value = 0;
    totalLecT.value = 0;
    attendLecT.value = 0;

    groupedAttendance.forEach((subject, attendances) {
      for (int i = 0; i < attendances.length; i++) {
        var attendance = attendances[i];
        if (attendance.lecType == 'L') {
          totalLecL.value += attendance.totalLec;
          attendLecL.value += attendance.attendLec;
        } else if (attendance.lecType == 'T') {
          totalLecT.value += attendance.totalLec;
          attendLecT.value += attendance.attendLec;
        }

        double percentage = 0.0;
        if (attendance.totalLec != 0) {
          percentage = ((attendance.attendLec + attendance.extraLec) /
                  attendance.totalLec) *
              100;
        }

        rows.add(
          TableRow(
            children: [
              // Merge subjectShortName cells if subject is same as the previous row
              i == 0
                  ? Tooltip(
                      preferBelow: false,
                      message: attendance.subjectName,
                      child: TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              attendance.subjectShortName,
                              style: TextStyle(
                                fontFamily: 'mu_bold',
                                fontSize: getSize(Get.context!, 2),
                              ),
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ),
                      ),
                    )
                  : TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child:
                          Container(), // Empty cell to visually merge the rows
                    ),
              // Lec type
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Center(
                  child: Text(
                    attendance.lecType,
                    style: TextStyle(
                        fontFamily: 'mu_reg',
                        fontSize: getSize(Get.context!, 2)),
                  ),
                ),
              ),
              // Total lectures
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Center(
                  child: Text(
                    attendance.totalLec.toString(),
                    style: TextStyle(
                        fontFamily: 'mu_reg',
                        fontSize: getSize(Get.context!, 2.5)),
                  ),
                ),
              ),
              // Present lectures
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Center(
                  child: Text(
                    attendance.attendLec.toString(),
                    style: TextStyle(
                        fontFamily: 'mu_reg',
                        fontSize: getSize(Get.context!, 2.5)),
                  ),
                ),
              ),
              // Extra lectures
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Center(
                  child: Text(
                    attendance.extraLec > -1
                        ? attendance.extraLec.toString()
                        : "",
                    style: TextStyle(
                        fontFamily: 'mu_reg',
                        fontSize: getSize(Get.context!, 2.5)),
                  ),
                ),
              ),
              // Percentage (handle NaN and format)
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Center(
                  child: Text(
                    percentage == 0.0
                        ? "0" // Display 0 instead of NaN
                        : percentage.toStringAsFixed(
                            0), // Remove decimals if it's a whole number
                    style: TextStyle(
                        fontFamily: 'mu_reg',
                        fontSize: getSize(Get.context!, 2.5)),
                  ),
                ),
              ),
            ],
            decoration: BoxDecoration(
              border: i > 0 &&
                      attendances[i - 1].subjectShortName ==
                          attendance.subjectShortName
                  ? const Border(
                      // Remove border between same subject rows
                      top: BorderSide.none,
                      bottom: BorderSide.none,
                      left: BorderSide.none,
                      right: BorderSide.none,
                    )
                  : const Border(
                      top: BorderSide(),
                    ),
            ),
          ),
        );
      }
    });

    //   total row
    rows.add(
      TableRow(
        decoration: const BoxDecoration(border: Border(top: BorderSide())),
        children: [
          TableCell(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Total',
                  style: TextStyle(
                      fontFamily: 'mu_bold',
                      fontSize: getSize(Get.context!, 2.25)),
                ),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
              child: Text(
                "L",
                style: TextStyle(
                    fontFamily: 'mu_reg', fontSize: getSize(Get.context!, 2)),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
              child: Text(
                totalLecL.value.toStringAsFixed(0),
                style: TextStyle(
                    fontFamily: 'mu_reg', fontSize: getSize(Get.context!, 2.5)),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
              child: Text(
                attendLecL.value.toStringAsFixed(0),
                style: TextStyle(
                    fontFamily: 'mu_reg', fontSize: getSize(Get.context!, 2.5)),
              ),
            ),
          ),
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container()),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
              child: Text(
                totalLecL.value != 0
                    ? ((attendLecL.value / totalLecL.value) * 100)
                        .toStringAsFixed(0)
                    : "0", // Avoid division by zero
                style: TextStyle(
                    fontFamily: 'mu_reg', fontSize: getSize(Get.context!, 2.5)),
              ),
            ),
          ),
        ],
      ),
    );
    rows.add(
      TableRow(
        children: [
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container()),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
              child: Text(
                "T",
                style: TextStyle(
                    fontFamily: 'mu_reg', fontSize: getSize(Get.context!, 2)),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
              child: Text(
                totalLecT.value.toStringAsFixed(0),
                style: TextStyle(
                    fontFamily: 'mu_reg', fontSize: getSize(Get.context!, 2.5)),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
              child: Text(
                attendLecT.value.toStringAsFixed(0),
                style: TextStyle(
                    fontFamily: 'mu_reg', fontSize: getSize(Get.context!, 2.5)),
              ),
            ),
          ),
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container()),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
              child: Text(
                totalLecT.value != 0
                    ? ((attendLecT.value / totalLecT.value) * 100)
                        .toStringAsFixed(0)
                    : "0", // Avoid division by zero
                style: TextStyle(
                    fontFamily: 'mu_reg', fontSize: getSize(Get.context!, 2.5)),
              ),
            ),
          ),
        ],
      ),
    );

//  final total row
    rows.add(
      TableRow(
        decoration: BoxDecoration(
            color: muColor50.withOpacity(0.5),
            border: const Border(top: BorderSide())),
        children: [
          TableCell(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Final Total',
                  style: TextStyle(
                    fontFamily: 'mu_bold',
                    fontSize: getSize(Get.context!, 2.25),
                  ),
                ),
              ),
            ),
          ),
          TableCell(child: Container()), // Empty cell for lec_type
          TableCell(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  totalAttendance.value.toStringAsFixed(0),
                  style: TextStyle(
                      fontFamily: 'mu_bold',
                      fontSize: getSize(Get.context!, 2.5)),
                ),
              ),
            ),
          ),
          TableCell(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  totalPresent.value.toStringAsFixed(0),
                  style: TextStyle(
                      fontFamily: 'mu_bold',
                      fontSize: getSize(Get.context!, 2.5)),
                ),
              ),
            ),
          ),
          TableCell(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  totalExtra.value.toStringAsFixed(0),
                  style: TextStyle(
                      fontFamily: 'mu_bold',
                      fontSize: getSize(Get.context!, 2.5)),
                ),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              color: muColor,
              child: Padding(
                padding: EdgeInsets.all(getSize(Get.context!, 0.6)),
                child: Center(
                  child: Text(
                    "${totalAttendance.value != 0 ? (((totalPresent.value + totalExtra.value) / totalAttendance.value) * 100).toStringAsFixed(0) : "0"}%", // Avoid division by zero
                    style: TextStyle(
                        fontFamily: 'mu_bold',
                        color: Colors.white,
                        fontSize: getSize(Get.context!, 3)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return rows;
  }

  Future<void> fetchAttendance() async {
    int studentId = Get.arguments['student_id'];
    List<TotalAttendance>? fetchedAttendanceList =
        await totalAttendanceFetch(studentId);
    attendanceList.assignAll(fetchedAttendanceList);
    await calculateAttendance();
  }

  Future<void> calculateAttendance() async {
    totalExtra.value = 0;
    totalAttendance.value = 0;
    totalPresent.value = 0;
    for (var attendance in attendanceList) {
      totalExtra.value += attendance.extraLec > -1 ? attendance.extraLec : 0;
      totalAttendance.value += attendance.totalLec;
      totalPresent.value += attendance.attendLec;
    }
  }

  Future<void> fetchTodayAttendance() async {
    int studentId = Get.arguments['student_id'];
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    List<AttendanceByDate>? fetchedTodayAttendanceList =
        await attendanceByDate(studentId, todayDate);
    todayAttendanceList.assignAll(fetchedTodayAttendanceList);
  }

  Future<List<TotalAttendance>> totalAttendanceFetch(int sid) async {
    try {
      Map<String, int> body = {'s_id': sid};

      final response = await http.post(
        Uri.parse(totalAttendanceAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        // Convert the response data into a list of TotalAttendance
        List<TotalAttendance> attendanceList = responseData
            .map((attendanceData) => TotalAttendance.fromJson(attendanceData))
            .toList();
        return attendanceList;
      } else {
        return [];
      }
    } catch (e) {
      // print('Error: $e');
      return [];
    }
  }

  Future<List<AttendanceByDate>> attendanceByDate(int sid, String date) async {
    try {
      Map<String, dynamic> body = {
        's_id': sid,
        'date': date,
      };

      final response = await http.post(
        Uri.parse(attendanceByDateAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        // Convert the response data into a list of AttendanceByDate
        List<AttendanceByDate> attendanceDataList = responseData
            .map((attendanceData) => AttendanceByDate.fromJson(attendanceData))
            .toList();

        return attendanceDataList;
      } else {
        return [];
      }
    } catch (e) {
      // print('Error: $e');
      return [];
    }
  }
}
