// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Firebase/firebase_messaging_service.dart';
import '../Helper/Utils.dart';
import '../Helper/colors.dart';
import '../Network/API.dart';
import '../Screens/Exception/service_not_available.dart';
import 'internet_connectivity.dart';

class SplashController extends GetxController {
  final box = GetStorage();
  final controller = Get.find<InternetConnectivityController>();

  @override
  void onInit() {
    super.onInit();
    checkVersion();
    //Local Notifications
    handlePendingMessages();
  }

  _navigateAfterSplash() async {
    await Future.delayed(const Duration(seconds: 1));
    bool isLoggedIn = box.read('loggedin') ?? false;
    if (isLoggedIn) {
      Get.offAllNamed("/dashboard");
    } else {
      Get.offAllNamed("/login");
    }
  }
// get default permission to handle notification for android
  getPermissionForNotification() {
    if (Platform.isAndroid) {
      Permission.notification.isDenied.then((value) {
        if (value) {
          Permission.notification.request();
        }
      });
    }
  }

  checkVersion() async {
    try {
      await controller.checkConnection();
      if (!controller.isConnected.value) {
        // print("No Internet");
        Utils()
            .showInternetAlert(context: Get.context!, onConfirm: checkVersion);
      } else {
        Map<String, String> body = {'login': 'parent', 'code': currentVersion};
        final response = await http.post(
          Uri.parse(validateVersionAPI),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': validApiKey,
          },
          body: json.encode(body),
        );

        if (response.statusCode == 200) {
          _navigateAfterSplash();
        } else {
          ArtSweetAlert.show(
            barrierDismissible: false,
            context: Get.context!,
            artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.warning,
              sizeSuccessIcon: 70,
              confirmButtonText: "Update Now", // Hides the confirm button
              confirmButtonColor: muColor,
              onConfirm: () async {
                String url = updateURL;
                await launch(url);
              },
              title: "App update available!",
              dialogDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        }
      }
    } catch (e) {
      // print('Error: $e');
      const ServiceNotAvailable();
    }
  }
}
