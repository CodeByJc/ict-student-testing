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
import 'package:ict_mu_students/Helper/colors.dart';
import '../../Helper/size.dart';
import '../../Widgets/clickable_text.dart';
import '../Loading/campus_drive_update_loading.dart';

class CampusDriveDetailScreen extends GetView<CampusDriveController> {
  const CampusDriveDetailScreen({super.key});

  // ------------------------ URL VALIDATION ------------------------
  bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    return uri != null && (uri.isScheme("http") || uri.isScheme("https"));
  }

  // ------------------------ OPEN URL ------------------------
  Future<void> openUrl(String? url, {bool isLinkedIn = false}) async {
    if (!isValidUrl(url)) {
      Get.snackbar("Error", "Invalid or empty link");
      return;
    }

    final Uri uri = Uri.parse(url!);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: isLinkedIn ? LaunchMode.externalApplication : LaunchMode.platformDefault,
        );
      } else {
        Get.snackbar("Error", "Could not launch $url");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to launch URL: $e");
    }
  }

  // ------------------------ BUILD ------------------------
  @override
  Widget build(BuildContext context) {
    CampusDriveModel campusDrive = Get.arguments['drive'];

    // ------------------------ BUTTON ACTION ------------------------
    void onButtonClick(String status) {
      ArtSweetAlert.show(
        context: Get.context!,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.question,
          showCancelBtn: true,
          confirmButtonText: "Yes I confirm",
          confirmButtonColor: muColor,
          cancelButtonColor: Colors.redAccent,
          cancelButtonText: "Cancel",
          onConfirm: () async {
            Get.back();
            Get.back();
            controller.statusUpdate(campusDrive.id, status);
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

    // ------------------------ DATE & TIME ------------------------
    String dateAndTime() {
      if (campusDrive.date.isNotEmpty && campusDrive.time.isNotEmpty) {
        return "${DateFormat('dd-MM-yyyy').format(DateFormat('yyyy-MM-dd').parse(campusDrive.date))} - ${DateFormat('hh:mm a').format(DateFormat('HH:mm:ss').parse(campusDrive.time))}";
      } else {
        return "Will be declared";
      }
    }

    // ------------------------ STATUS DISPLAY ------------------------
    Widget statusShow() {
      switch (campusDrive.status) {
        case "pending":
          return _buildPendingStatus(onButtonClick);
        case "yes":
          return _buildAppliedStatus();
        default:
          return _buildNotAppliedStatus();
      }
    }

    // ------------------------ UI BODY ------------------------
    return Scaffold(
      appBar: AppBar(
        title: Text("Campus Drive Details", style: appbarStyle(context)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: backgroundColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    campusDrive.companyName,
                    style: TextStyle(fontFamily: "mu_bold", fontSize: getSize(context, 2.7)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Divider(color: Colors.white, height: 20, indent: 10, endIndent: 10),
                statusShow(),
                const SizedBox(height: 10),
                PlacementDetailsCard(headingName: "Date & Time", details: dateAndTime()),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: PlacementDetailsCard(
                        headingName: "Work Location",
                        details: campusDrive.location,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PlacementDetailsCard(
                        headingName: "Company Type",
                        details: campusDrive.companyType,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                PlacementDetailsCard(
                  headingName: "Job Profiles",
                  details: campusDrive.jobProfiles.isNotEmpty
                      ? campusDrive.jobProfiles
                      .asMap()
                      .entries
                      .map((entry) => "${entry.key + 1}. ${entry.value.profileName}")
                      .join("\n")
                      : "Not Available",
                ),
                const SizedBox(height: 10),
                PlacementDetailsCard(
                  headingName: "Package",
                  details: campusDrive.package.isNotEmpty ? campusDrive.package : "Not Available",
                ),
                const SizedBox(height: 10),
                PlacementDetailsCardWidgets(
                  headingName: 'Selection Progress',
                  child: ListView.builder(
                    itemCount: campusDrive.rounds.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final round = campusDrive.rounds[index];
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
                  child: ClickableText(campusDrive.otherInfo),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildUrlButton("Website", campusDrive.companyWebsite, Colors.lightGreen),
                    const SizedBox(width: 5),
                    _buildUrlButton(
                      "LinkedIn",
                      campusDrive.companyLinkedin,
                      LinkedinColor,
                      isLinkedIn: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          controller.isLoadingStatusUpdate.value
              ? const CampusDriveUpdateLoading()
              : Container(),
        ],
      ),
    );
  }

  // ------------------------ URL BUTTON ------------------------
  Widget _buildUrlButton(String label, String? url, Color color, {bool isLinkedIn = false}) {
    return ElevatedButton.icon(
      icon: HugeIcon(
        icon: label == "LinkedIn"
            ? HugeIcons.strokeRoundedLinkedin01
            : HugeIcons.strokeRoundedLink02,
        color: Colors.white,
      ),
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
      onPressed: isValidUrl(url) ? () => openUrl(url, isLinkedIn: isLinkedIn) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isValidUrl(url) ? color : Colors.grey,
        disabledBackgroundColor: Colors.grey,
      ),
    );
  }

  // ------------------------ STATUS WIDGETS ------------------------
  Widget _buildPendingStatus(Function(String) onClick) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: muGrey,
        border: Border.all(color: muGrey2),
        borderRadius: BorderRadius.circular(borderRad),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                "You haven't applied for this campus drive. Are you interested in applying?",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => onClick('yes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                child: const Text("Interested", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
              ElevatedButton(
                onPressed: () => onClick('no'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                child: const Text("Not interested", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildAppliedStatus() {
    return _statusContainer(
        "You have already applied.", Colors.green, HugeIcons.strokeRoundedCheckmarkCircle01);
  }

  Widget _buildNotAppliedStatus() {
    return _statusContainer(
        "You were not interested to apply.", Colors.red, HugeIcons.strokeRoundedCancelCircle);
  }

  Widget _statusContainer(String text, Color iconColor, IconData icon) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: muGrey,
        border: Border.all(color: muGrey2),
        borderRadius: BorderRadius.circular(borderRad),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                text,
                style: TextStyle(fontSize: 16, color: iconColor, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
