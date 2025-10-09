import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../Controllers/change_password_controller.dart';
import '../../Helper/Components.dart';
import '../../Helper/colors.dart';
import '../../Helper/size.dart';
import '../Loading/mu_loading_screen.dart';

class ChangePasswordScreen extends GetView<ChangePasswordController> {
  const ChangePasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: backgroundColor),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: SingleChildScrollView(
          child: Obx(
            () => controller.isLoadingUpdatePass.value
                ? const MuLoadingScreen()
                : Column(
                    children: [
                      TextField(
                        controller: controller.currentPass.value,
                        cursorColor: muColor,
                        obscureText: !controller.passShow.value,
                        decoration: InputDecoration(
                          labelText: 'Current Password',
                          labelStyle: TextStyle(
                            fontFamily: "mu_reg",
                            color: muGrey2,
                          ),
                          hintText: 'Enter Current Password',
                          hintStyle: TextStyle(
                            fontFamily: "mu_reg",
                            color: muGrey2,
                          ),
                          suffixIcon: InkWell(
                              onTap: () {
                                controller.passShow.value =
                                    !controller.passShow.value;
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: HugeIcon(
                                    icon: controller.passShow.value
                                        ? HugeIcons.strokeRoundedView
                                        : HugeIcons.strokeRoundedViewOff,
                                    color: Colors.grey),
                              )),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: muGrey2, width: 1.5),
                            borderRadius: BorderRadius.circular(borderRad),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: muGrey2, width: 1.5),
                            borderRadius: BorderRadius.circular(borderRad),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: getSize(context, 2.5),
                          fontFamily: "mu_reg",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextField(
                        controller: controller.newPass.value,
                        cursorColor: muColor,
                        obscureText: !controller.passShow.value,
                        onChanged: (value) {
                          controller.validatePassword(value);
                          controller.checkPasswordMatch();
                        },
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          labelStyle: TextStyle(
                            fontFamily: "mu_reg",
                            color: muGrey2,
                          ),
                          hintText: 'Enter New Password',
                          hintStyle: TextStyle(
                            fontFamily: "mu_reg",
                            color: muGrey2,
                          ),
                          suffixIcon: InkWell(
                              onTap: () {
                                controller.passShow.value =
                                    !controller.passShow.value;
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: HugeIcon(
                                    icon: controller.passShow.value
                                        ? HugeIcons.strokeRoundedView
                                        : HugeIcons.strokeRoundedViewOff,
                                    color: Colors.grey),
                              )),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: muGrey2, width: 1.5),
                            borderRadius: BorderRadius.circular(borderRad),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: muGrey2, width: 1.5),
                            borderRadius: BorderRadius.circular(borderRad),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: getSize(context, 2.5),
                          fontFamily: "mu_reg",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: controller.confirmNewPass.value,
                        cursorColor: controller.isPasswordMatch.value
                            ? muColor
                            : Colors.red,
                        obscureText: !controller.passShow.value,
                        onChanged: (value) {
                          controller.checkPasswordMatch();
                        },
                        decoration: InputDecoration(
                          labelText: 'Confirm New Password',
                          labelStyle: TextStyle(
                            fontFamily: "mu_reg",
                            color: controller.isPasswordMatch.value
                                ? muGrey2
                                : Colors.red,
                          ),
                          hintText: 'Re-Enter New Password',
                          hintStyle: TextStyle(
                            fontFamily: "mu_reg",
                            color: controller.isPasswordMatch.value
                                ? muGrey2
                                : Colors.red,
                          ),
                          suffixIcon: InkWell(
                            onTap: () {
                              controller.passShow.value =
                                  !controller.passShow.value;
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: HugeIcon(
                                icon: controller.passShow.value
                                    ? HugeIcons.strokeRoundedView
                                    : HugeIcons.strokeRoundedViewOff,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          // Border changes based on whether passwords match
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: controller.isPasswordMatch.value
                                    ? muGrey2
                                    : Colors.red,
                                width: 1.5),
                            borderRadius: BorderRadius.circular(borderRad),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: controller.isPasswordMatch.value
                                    ? muGrey2
                                    : Colors.red,
                                width: 1.5),
                            borderRadius: BorderRadius.circular(borderRad),
                          ),
                        ),
                        style: TextStyle(
                            fontSize: getSize(context, 2.5),
                            fontFamily: "mu_reg",
                            fontWeight: FontWeight.w500,
                            color: controller.isPasswordMatch.value
                                ? Colors.black
                                : Colors.red),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildValidationText("At least 8 characters",
                              controller.isMinLength.value),
                          _buildValidationText("At least one special character",
                              controller.hasSpecialChar.value),
                          _buildValidationText("At least one number",
                              controller.hasNumber.value),
                          _buildValidationText("At least one uppercase letter",
                              controller.hasCapitalLetter.value),
                        ],
                      ),
                      SizedBox(height: getHeight(context, 0.3)),
                      controller.isPasswordValid
                          ? InkWell(
                              onTap: () => controller.updatePassword(controller
                                  .userData.studentDetails!.grNo
                                  .toString()),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  height: getHeight(context, 0.06),
                                  decoration: BoxDecoration(
                                      color: muGrey,
                                      border: Border.all(color: muGrey2),
                                      borderRadius:
                                          BorderRadius.circular(borderRad)),
                                  child: Center(
                                      child: Text(
                                    "Change Password",
                                    style:
                                        TextStyle(color: muColor, fontSize: 20),
                                  )),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

Widget _buildValidationText(String text, bool isValid) {
  return Padding(
    padding: const EdgeInsets.only(left: 10),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HugeIcon(
              icon: isValid
                  ? HugeIcons.strokeRoundedCheckmarkCircle01
                  : HugeIcons.strokeRoundedCancel01,
              color: isValid ? Colors.green : Colors.red,
              size: 20,
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: getWidth(Get.context!, 0.8),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: getSize(Get.context!, 2),
                    color: isValid ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.visible),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
      ],
    ),
  );
}
