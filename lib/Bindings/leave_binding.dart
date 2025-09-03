import 'package:get/get.dart';
import 'package:ict_mu_students/Controllers/leave_controller.dart';
import '../Controllers/internet_connectivity.dart';

class LeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetConnectivityController());
    Get.put(LeaveController());
  }
}
