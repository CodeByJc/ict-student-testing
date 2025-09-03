import 'package:get/get.dart';
import '../Controllers/internet_connectivity.dart';
import '../Controllers/student_round_controller.dart';

class StudentRoundsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetConnectivityController());
    Get.put(StudentRoundsController());
  }
}
