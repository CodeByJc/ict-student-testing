import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_mu_students/Animations/slide_zoom_in_animation.dart';
import 'package:ict_mu_students/Controllers/campus_drive_controller.dart';
import 'package:ict_mu_students/Helper/Style.dart';
import 'package:ict_mu_students/Screens/Loading/adaptive_loading_screen.dart';
import 'package:intl/intl.dart';
import '../../Helper/Components.dart';
import '../../Helper/colors.dart';
import '../../Helper/size.dart';
import '../../Model/campus_drive_model.dart';

class CampusDriveScreen extends GetView<CampusDriveController> {
  const CampusDriveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();

    String statusTagText(String stat) {
      return stat == "yes" ? "Applied" : stat == "no" ? "Not Applied" : "Pending";
    }

    Color statusTagBG(String stat) {
      return stat == "yes" ? Colors.green : stat == "no" ? Colors.red : Colors.amber;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Campus Drive", style: appbarStyle(context)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: backgroundColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() => RefreshIndicator(
        onRefresh: () => controller.fetchCampusDriveList(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: TextField(
                controller: controller.searchController,
                cursorColor: muColor,
                focusNode: focusNode,
                decoration: InputDecoration(
                  labelText: 'Search Companies',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: TextStyle(fontFamily: "mu_reg", color: focusNode.hasFocus ? muColor : muGrey2),
                  prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedSearch01, color: focusNode.hasFocus ? muColor : muGrey2),
                  suffixIcon: controller.searchController.text.isNotEmpty
                      ? IconButton(
                    icon: HugeIcon(icon: HugeIcons.strokeRoundedCancel01, color: focusNode.hasFocus ? muColor : muGrey2),
                    onPressed: () {
                      controller.searchController.clear();
                      controller.filterCampusDrive('');
                    },
                  )
                      : null,
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: muColor), borderRadius: BorderRadius.circular(borderRad)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: focusNode.hasFocus ? muColor : muGrey2), borderRadius: BorderRadius.circular(borderRad)),
                ),
                style: TextStyle(fontSize: getSize(context, 2.5), fontFamily: "mu_reg", fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: controller.isLoadingCampusDrive.value
                  ? const AdaptiveLoadingScreen()
                  : controller.filteredCampusDriveList.isEmpty
                  ? Center(
                child: Text("No campus drives found", style: TextStyle(fontSize: getSize(context, 2), color: muGrey2)),
              )
                  : ListView.builder(
                itemCount: controller.filteredCampusDriveList.length,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                itemBuilder: (context, index) {
                  final drive = controller.filteredCampusDriveList[index];
                  return SlideZoomInAnimation(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                        onTap: () => Get.toNamed('/campusDriveDetail', arguments: {'drive': drive, 'student_id': Get.arguments['student_id']}),
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: muGrey, borderRadius: BorderRadius.circular(10)),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      HugeIcon(icon: HugeIcons.strokeRoundedBuilding05, color: muColor),
                                      const SizedBox(width: 7),
                                      Flexible(
                                        child: Text(drive.companyName, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, fontSize: getSize(context, 2))),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      HugeIcon(icon: HugeIcons.strokeRoundedLocation03, color: muColor),
                                      const SizedBox(width: 7),
                                      Text(drive.location, style: TextStyle(fontSize: getSize(context, 2))),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          HugeIcon(icon: HugeIcons.strokeRoundedCalendar03, color: muColor),
                                          const SizedBox(width: 7),
                                          Text(
                                            drive.date.isNotEmpty ? DateFormat('dd-MM-yyyy').format(DateFormat('yyyy-MM-dd').parse(drive.date)) : "Will be declared",
                                            style: TextStyle(fontSize: getSize(context, 2)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          HugeIcon(icon: HugeIcons.strokeRoundedTime04, color: muColor),
                                          const SizedBox(width: 7),
                                          Text(
                                            drive.time.isNotEmpty ? DateFormat('hh:mm a').format(DateFormat('HH:mm:ss').parse(drive.time)) : "Soon",
                                            style: TextStyle(fontSize: getSize(context, 2)),
                                          ),
                                        ],
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
                                  color: statusTagBG(drive.status),
                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                ),
                                child: Center(
                                  child: Text(statusTagText(drive.status), style: const TextStyle(color: Colors.white)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
