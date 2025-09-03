import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../Network/API.dart';

class LogoutController extends GetxController {

  RxBool isLoadingLogout = false.obs;
  //Logout
  Future<bool> logout(String username) async {
    isLoadingLogout.value = true;
    try {
      Map<String, String> body = {
        'username': username,
      };
      final response = await http.post(
        Uri.parse(validateLogoutAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final box = GetStorage();
        await box.write('loggedin', false);
        await box.write('userdata', null);
        Get.offNamed('/login');
        isLoadingLogout.value = false;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
