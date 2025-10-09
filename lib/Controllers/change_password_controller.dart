import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Model/user_data_model.dart';
import '../Network/API.dart';

class ChangePasswordController extends GetxController {
  Rx<TextEditingController> currentPass = TextEditingController().obs;
  Rx<TextEditingController> newPass = TextEditingController().obs;
  Rx<TextEditingController> confirmNewPass = TextEditingController().obs;
  UserData userData = Get.arguments;
  RxBool passShow = false.obs;
  RxBool isMinLength = false.obs;
  RxBool hasSpecialChar = false.obs;
  RxBool hasNumber = false.obs;
  RxBool hasCapitalLetter = false.obs;
  RxBool isPasswordMatch = true.obs;
  RxBool isLoadingUpdatePass = false.obs;

  void checkPasswordMatch() {
    isPasswordMatch.value =
        newPass.value.text == confirmNewPass.value.text;
  }

  void validatePassword(String password) {
    isMinLength.value = password.length >= 8;
    hasSpecialChar.value = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    hasNumber.value = RegExp(r'[0-9]').hasMatch(password);
    hasCapitalLetter.value = RegExp(r'[A-Z]').hasMatch(password);
  }

  bool get isPasswordValid =>
      isMinLength.value && hasSpecialChar.value && hasNumber.value &&
          hasCapitalLetter.value && isPasswordMatch.value;

  Future updatePassword(String studentGR) async {
    isLoadingUpdatePass.value=true;
    try {
      Map<String, dynamic> body = {
        'username': studentGR,
        'currentPass': currentPass.value.text,
        'newPass': newPass.value.text,
      };

      final response = await http.post(
        Uri.parse(updatePasswordAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
            "Password Changed", "Password updated successfully!",
            backgroundColor: Colors.green,
            colorText: Colors.white);
            currentPass.value.clear();
            newPass.value.clear();
            confirmNewPass.value.clear();
            Get.offNamed('/profile',arguments: userData);
      } else {
        final responseBody = json.decode(response.body);
        String message = responseBody['message'] ?? 'An error occurred';
        Get.snackbar(
          "Password Change Failed",
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      } catch (e) {
        Get.snackbar(
          "Password Change Failed",
          "Network or server error: $e",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }finally{
        isLoadingUpdatePass.value=false;
      }
  }
}