import 'package:get/get.dart';
import '../Controllers/change_password_controller.dart';
import '../Controllers/internet_connectivity.dart';

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetConnectivityController());
    Get.put(ChangePasswordController());
  }
}
