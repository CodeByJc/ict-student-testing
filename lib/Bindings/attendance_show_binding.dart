import 'package:get/get.dart';
import 'package:ict_mu_students/Controllers/attendance_show_controller.dart';

class AttendanceShowBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AttendanceShowController());
  }
}
