import 'package:get/get.dart';
import 'package:ict_mu_students/Controllers/exam_list_controller.dart';
import '../Controllers/internet_connectivity.dart';

class ExamListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetConnectivityController());
    Get.put(ExamListController());
  }
}
