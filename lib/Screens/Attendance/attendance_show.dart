import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ict_mu_students/Controllers/attendance_show_controller.dart';
import 'package:ict_mu_students/Helper/Components.dart';
import 'package:ict_mu_students/Model/attendance_by_date_model.dart';
import 'package:ict_mu_students/Helper/colors.dart';
import 'package:ict_mu_students/Helper/Style.dart';
import 'package:ict_mu_students/Widgets/adaptive_refresh_indicator.dart';
import '../../Widgets/heading_1.dart';
import '../Loading/adaptive_loading_screen.dart';

class StudentAttendanceScreen extends GetView<AttendanceShowController> {
  const StudentAttendanceScreen({super.key});

  Future<void> _refreshData() async {
    await controller.fetchAttendance();
    await controller.fetchTodayAttendance();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total attendance and present lectures

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Attendance", style: appbarStyle(context)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Light1),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: muColor,
        automaticallyImplyLeading: false,
      ),
      body: AdaptiveRefreshIndicator(
        onRefresh: () => _refreshData(),
        child: ListView(
          children: [
            controller.isLoadingAttendanceShow.value
                ? const AdaptiveLoadingScreen()
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      child: Obx(
                        () => Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceAround, // Space between icon and percentage
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Total Attendance',
                                              style: TextStyle(
                                                fontSize: getSize(context, 2.5),
                                                fontFamily: "mu_reg",
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Colors.black, // Text color
                                              ),
                                            ),
                                            Text(
                                              'Till Today',
                                              style: TextStyle(
                                                fontSize: getSize(context, 2),
                                                fontFamily: "mu_reg",
                                                color: Colors
                                                    .red, // Text color for 'Till Yesterday'
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: getHeight(context, 0.08),
                                    width: getWidth(context, 0.005),
                                    color: muGrey2,
                                  ),
                                  radialIndicator(
                                      context, controller.avgAttendance),
                                ],
                              ),
                            ),
                             Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Divider(color: muGrey2),
                            ),
                            controller.avgAttendance > 0 &&
                                    controller.avgAttendance < 75
                                ? Column(
                                    children: [
                                      AnimatedBuilder(
                                        animation: controller
                                            .animationController!
                                            .value, // Listen to the animation
                                        builder: (BuildContext context,
                                            Widget? child) {
                                          return Opacity(
                                            opacity: controller
                                                .animationController!
                                                .value
                                                .value,
                                            child: Card(
                                              color: Colors.red,
                                              child: SizedBox(
                                                width: double.infinity,
                                                height:
                                                    getHeight(context, 0.07),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Students with attendance below 75% will not be allowed to appear for the examinations.",
                                                    style: TextStyle(
                                                      fontFamily: "mu_reg",
                                                      color: Colors.white,
                                                      fontSize:
                                                          getSize(context, 2),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Divider(color: muGrey2),
                                      ),
                                    ],
                                  )
                                : Container(),
                            // Inside the build method, after your existing content
                            Column(
                              children: [
                                Heading1(
                                    text:
                                        "Today's Attendance  -  ( ${controller.formattedDate} )",
                                    fontSize: 2.5,
                                    leftPadding: 8),
                                controller.todayAttendanceList.isNotEmpty
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: controller
                                            .todayAttendanceList.length,
                                        itemBuilder: (context, index) {
                                          AttendanceByDate attendance =
                                              controller
                                                  .todayAttendanceList[index];
                                          return attendanceCard(
                                              context,
                                              attendance.subjectName,
                                              attendance.facultyName,
                                              attendance.startTime
                                                  .substring(0, 5),
                                              attendance.endTime
                                                  .substring(0, 5),
                                              attendance.status,
                                              attendance.lecType);
                                        },
                                      )
                                    : Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text('No attendance today',
                                              style: TextStyle(
                                                  fontFamily: "mu_reg",
                                                  fontSize:
                                                      getSize(context, 2))),
                                        ),
                                      ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Divider(color: muGrey2),
                            ),
                            const Heading1(
                                text: "Attendance Report",
                                fontSize: 2.5,
                                leftPadding: 8),
                            controller.attendanceList.isNotEmpty
                                ? Center(
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all()),
                                          child: Table(
                                            columnWidths: {
                                              0: FlexColumnWidth(getSize(
                                                  context, 0.1)), // Subject
                                              1: FlexColumnWidth(getSize(
                                                  context, 0.04)), // Lec Type
                                              2: FlexColumnWidth(getSize(
                                                  context, 0.06)), // Total
                                              3: FlexColumnWidth(getSize(
                                                  context, 0.06)), // Present
                                              4: FlexColumnWidth(getSize(
                                                  context, 0.06)), // Extra
                                              5: FlexColumnWidth(
                                                  getSize(context, 0.08)), // %
                                            },
                                            border: const TableBorder(
                                              verticalInside: BorderSide(),
                                            ),
                                            children: [
                                              // Table Heading
                                              TableRow(
                                                decoration: BoxDecoration(
                                                    color:
                                                        muColor), // Header background color
                                                children: [
                                                  Center(
                                                    child: TableCell(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Sub',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'mu_bold',
                                                            fontSize: getSize(
                                                                context, 2.25),
                                                            color: Colors
                                                                .white, // Set text color to black
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const TableCell(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(''),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Tot',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'mu_bold',
                                                            fontSize: getSize(
                                                                context, 2.25),
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Pre',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'mu_bold',
                                                            fontSize: getSize(
                                                                context, 2.25),
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Ext',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'mu_bold',
                                                            fontSize: getSize(
                                                                context, 2.25),
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          '%',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'mu_bold',
                                                            fontSize: getSize(
                                                                context, 2.25),
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // Table Rows with merged subjectShortName and custom border handling
                                              ...controller
                                                  .buildMergedTableRows(),
                                            ],
                                          ),
                                        )),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('No attendance data found',
                                            style: TextStyle(
                                                fontFamily: "mu_reg",
                                                fontSize: getSize(context, 2))),
                                      ],
                                    ),
                                  ),
                            const Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Divider(),
                            ),
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
}
