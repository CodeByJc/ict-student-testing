import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_mu_students/Controllers/logout_controller.dart';
import 'package:ict_mu_students/Model/user_data_model.dart';
import 'package:ict_mu_students/Screens/Loading/logout_loading_screen.dart';
import '../../Helper/colors.dart';
import '../../Helper/Components.dart';
import '../../Helper/images_path.dart';
import '../../Helper/size.dart';
import '../../Network/API.dart';
import '../../Widgets/detail_with_heading.dart';

class ProfilePage extends GetView<LogoutController>
{
  const ProfilePage({super.key});
  onLogout(username) {
    ArtSweetAlert.show(
      context: Get.context!,
      artDialogArgs: ArtDialogArgs(
        type: ArtSweetAlertType.question,
        sizeSuccessIcon: 70,
        showCancelBtn: true,
        confirmButtonText: "Yes",
        confirmButtonColor: muColor,
        cancelButtonColor: Colors.redAccent,
        cancelButtonText: "No",
        onConfirm: () async {
          Get.back();
          controller.logout(username);
        },
        title: "Are you sure to Logout?",
        dialogDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserData userData = Get.arguments;
    return Obx(
        ()=> controller.isLoadingLogout.value
            ? const LogoutLoadingScreen()
            : Scaffold(
          appBar: AppBar(
            title: const Text("Profile"),
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded, color: backgroundColor),
                onPressed: () => Get.back()),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () => onLogout(userData.studentDetails?.grNo ??""),
                  child: Container(
                      width: 70,
                      height: 35,
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(borderRad)),
                      child: Center(
                          child: Text(
                            "Logout",
                            style: TextStyle(
                                color: backgroundColor, fontWeight: FontWeight.bold),
                          ))),
                ),
              )
            ],
          ),
          body:
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        height: getHeight(context, 0.2),
                        width: getWidth(context, 1),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(borderRad),
                            color: Colors.white,
                            image: DecorationImage(
                                image: AssetImage(muMainBuilding),
                                opacity: 0.3,
                                fit: BoxFit.cover)),
                        child: Center(
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: muGrey2,
                                border: Border.all(
                                    color: muGrey2,
                                    width: 2,
                                    strokeAlign: BorderSide.strokeAlignOutside)),
                            clipBehavior: Clip.hardEdge,
                            child: CachedNetworkImage(
                              imageUrl:
                              studentImageAPI(userData.studentDetails!.grNo),
                              placeholder: (context, url) => HugeIcon(
                                icon: HugeIcons.strokeRoundedUser,
                                color: muColor,
                                size: 40,
                              ),
                              errorWidget: (context, url, error) => HugeIcon(
                                icon: HugeIcons.strokeRoundedUser,
                                color: muColor,
                                size: 40,
                              ),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    DetailWithHeading(
                        headingName: "Student Name",
                        details:
                        "${userData.studentDetails!.firstName} ${userData.studentDetails!.lastName}"),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: DetailWithHeading(
                              headingName: "Sem-Class-Batch",
                              details:
                              "${userData.classDetails!.semester} - ${userData.classDetails!.className} - ${userData.classDetails!.batch!.toUpperCase()}"),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: DetailWithHeading(
                            headingName: "Academic Batch",
                            details:
                            "${userData.studentDetails!.batchStartYear} - ${userData.studentDetails!.batchEndYear.toString().substring(2)}",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: DetailWithHeading(
                              headingName: "Enrollment No.",
                              details: userData.studentDetails!.enrollmentNo),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: DetailWithHeading(
                            headingName: "GR No.",
                            details: userData.studentDetails!.grNo,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DetailWithHeading(
                        headingName: "Student Mobile No.",
                        details: userData.studentDetails!.phone),
                    const SizedBox(
                      height: 10,
                    ),
                    DetailWithHeading(
                        headingName: "Student Institute Email Id",
                        details: userData.studentDetails!.email),
                    Divider(
                      height: 30,
                      color: muGrey2,
                      thickness: 2,
                      indent: 15,
                      endIndent: 15,
                    ),
                    DetailWithHeading(
                        headingName: "Parent Name",
                        details:
                        "${userData.parentDetails!.parentName} ${userData.studentDetails!.lastName}"),
                    const SizedBox(
                      height: 10,
                    ),
                    DetailWithHeading(
                        headingName: "Parent Occupation",
                        details: userData.parentDetails!.profession),
                    const SizedBox(
                      height: 10,
                    ),
                    DetailWithHeading(
                        headingName: "Parent Mobile No.",
                        details: userData.parentDetails!.phone),
                    const SizedBox(
                      height: 10,
                    ),
                    DetailWithHeading(
                        headingName: "Parent Email Id",
                        details: userData.parentDetails!.email),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () =>
                          Get.toNamed("/changePassword", arguments: userData),
                      child: Container(
                        height: getHeight(context, 0.06),
                        decoration: BoxDecoration(
                            color: muGrey,
                            border: Border.all(color: muGrey2),
                            borderRadius: BorderRadius.circular(borderRad)),
                        child: Center(
                            child: Text(
                              "Change Password",
                              style: TextStyle(color: muColor, fontSize: 20),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
