import 'package:get/get.dart';
import 'package:ict_mu_students/Controllers/logout_controller.dart';
import '../Controllers/internet_connectivity.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetConnectivityController());
    Get.put(LogoutController());
  }
}
