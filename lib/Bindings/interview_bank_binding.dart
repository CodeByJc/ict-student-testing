import 'package:get/get.dart';
import 'package:ict_mu_students/Controllers/interview_bank_controller.dart';
import '../Controllers/internet_connectivity.dart';

class InterviewBankBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetConnectivityController());
    Get.put(InterviewBankController());
  }
}
