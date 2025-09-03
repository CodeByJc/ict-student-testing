import 'package:get/get.dart';
import '../Controllers/campus_drive_controller.dart';
import '../Controllers/internet_connectivity.dart';

class CampusDriveBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetConnectivityController());
    Get.put(CampusDriveController());
  }
}
