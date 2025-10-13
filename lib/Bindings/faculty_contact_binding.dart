import 'package:get/get.dart';
import 'package:ict_mu_students/Controllers/faculty_contact_controller.dart';

import '../Controllers/internet_connectivity.dart';

class FacultyContactBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetConnectivityController());

    // Get studentId from Get.arguments
    int studentId = Get.arguments['student_id'];
    Get.put(FacultyContactController(studentId: studentId));
  }
}
