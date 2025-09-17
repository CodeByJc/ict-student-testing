import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_mu_students/Helper/Components.dart';
import 'package:ict_mu_students/Model/campus_drive_model.dart';
import 'package:ict_mu_students/Widgets/placement_details_card.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Controllers/campus_drive_controller.dart';
import '../../Helper/Style.dart';
import '../../Helper/colors.dart';
import '../../Helper/size.dart';
import '../../Widgets/clickable_text.dart';
import '../Loading/campus_drive_update_loading.dart';

// URL Validator
bool isValidUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  final Uri? uri = Uri.tryParse(url);
  return uri != null && (uri.isScheme("http") || uri.isScheme("https"));
}
class CampusDriveDetailScreen extends GetView<CampusDriveController> {
  const CampusDriveDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CampusDriveModel campusDrive = Get.arguments['drive'];

    // Confirmation dialog
    onButtonClick(String status) {
      ArtSweetAlert.show(
        context: Get.context!,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.question,
          sizeSuccessIcon: 70,
          showCancelBtn: true,
          confirmButtonText: "Yes I confirm",
          confirmButtonColor: muColor,
          cancelButtonColor: Colors.redAccent,
          cancelButtonText: "Cancel",
          onConfirm: () async {
            Get.back();
            Get.back();
            controller.statusUpdate(campusDrive.campusDriveId, status);
          },
          title: status == 'yes'
              ? "Are you sure to apply for this campus drive?"
              : "Are you sure to decline this campus drive?",
          dialogDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
    }

    /// ✅ FIXED: renamed from launchUrl → openUrl
    Future<void> openUrl(String? url, {bool isLinkedIn = false}) async {
      if (!isValidUrl(url)) {
        Get.snackbar("Error", "Invalid or empty link");
        return;
      }

      final Uri uri = Uri.parse(url!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: isLinkedIn
              ? LaunchMode.externalApplication
              : LaunchMode.platformDefault,
        );
      } else {
        Get.snackbar("Error", "Could not launch $url");
      }
    }


    // Format date and time
    String DateAndTime() {
      if (campusDrive.campusDriveDate.isNotEmpty &&
          campusDrive.campusDriveTime.isNotEmpty) {
        return "${DateFormat('dd-MM-yyyy').format(DateFormat('yyyy-MM-dd').parse(campusDrive.campusDriveDate))} - ${DateFormat('hh:mm a').format(DateFormat('hh:mm:ss').parse(campusDrive.campusDriveTime))}";
      } else {
        return "Will be declared";
      }
    }

    // Status widget
    Widget statusShow() {
      return campusDrive.campusDriveStatus == "pending"
          ? Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: muGrey,
                border: Border.all(color: muGrey2),
                borderRadius: BorderRadius.circular(borderRad),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Center(
                      child: Text(
                        "You haven't apply for this campus drive. Are you interested in applying?",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => onButtonClick('yes'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: const Text(
                          'Interested',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => onButtonClick('no'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: const Text(
                          'Not interested',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10)
                ],
              ),
            )
          : campusDrive.campusDriveStatus == "yes"
              ? Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: muGrey,
                    border: Border.all(color: muGrey2),
                    borderRadius: BorderRadius.circular(borderRad),
                  ),
                  child: const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Icon(
                                HugeIcons.strokeRoundedCancelCircle,
                                color: Colors.green,
                              ),

                            ),
                            Flexible(
                              child: Text(
                                "You have already applied.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: muGrey,
                    border: Border.all(color: muGrey2),
                    borderRadius: BorderRadius.circular(borderRad),
                  ),
                  child: const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Icon(
                                HugeIcons.strokeRoundedCancelCircle,
                                color: Colors.red,
                              ),

                            ),
                            Flexible(
                              child: Text(
                                "You were not interested to apply.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Campus Drive Details",
          style: appbarStyle(context),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: backgroundColor),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      campusDrive.campusDriveCompanyName,
                      style: TextStyle(
                        fontFamily: "mu_bold",
                        fontSize: getSize(context, 2.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: Divider(color: muGrey2, indent: 10, endIndent: 10),
                  ),

                  statusShow(),

                  const SizedBox(height: 10),

                  PlacementDetailsCard(
                    headingName: "Date & Time",
                    details: DateAndTime(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: PlacementDetailsCard(
                          headingName: "Work Location",
                          details: campusDrive.campusDriveLocation,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: PlacementDetailsCard(
                          headingName: "Company Type",
                          details: campusDrive.campusDriveCompanyType ??
                              "No Company",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: PlacementDetailsCard(
                          headingName: "Job Profile",
                          details: campusDrive.campusDriveJobProfile,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: PlacementDetailsCard(
                          headingName: "Package",
                          details: campusDrive.campusDrivePackage,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  PlacementDetailsCardWidgets(
                    headingName: 'Selection Progress',
                    child: ListView.builder(
                      itemCount: campusDrive.rounds.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        RoundsModel round = campusDrive.rounds[index];
                        return Text(
                          '${round.roundIndex} - ${round.roundName} (${round.mode})',
                          style: const TextStyle(fontSize: 16),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  PlacementDetailsCardWidgets(
                    headingName: 'Other Info',
                    child: ClickableText(campusDrive.campusDriveOtherInfo),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        label: const Text(
                          "Website",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: !isValidUrl(campusDrive.campusDriveCompanyWebsite)
                            ? null
                            : () => openUrl(campusDrive.campusDriveCompanyWebsite),
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedLink02,
                          color: !isValidUrl(campusDrive.campusDriveCompanyWebsite)
                              ? Colors.white54
                              : Colors.white,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: !isValidUrl(campusDrive.campusDriveCompanyWebsite)
                              ? Colors.grey
                              : Colors.lightGreen,
                          disabledBackgroundColor: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 5),
                      ElevatedButton.icon(
                        label: const Text(
                          "LinkedIn",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: !isValidUrl(campusDrive.campusDriveCompanyLinkedin)
                            ? null
                            : () => openUrl(
                          campusDrive.campusDriveCompanyLinkedin,
                          isLinkedIn: true,
                        ),
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedLinkedin01,
                          color: !isValidUrl(campusDrive.campusDriveCompanyLinkedin)
                              ? Colors.white54
                              : Colors.white,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: !isValidUrl(campusDrive.campusDriveCompanyLinkedin)
                              ? Colors.grey
                              : LinkedinColor,
                          disabledBackgroundColor: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),
          ),
          controller.isLoadingStatusUpdate.value
              ? const CampusDriveUpdateLoading()
              : Container(),
        ],
      ),
    );
  }
}
