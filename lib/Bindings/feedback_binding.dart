import 'package:get/get.dart';
import 'package:ict_mu_students/Controllers/feedback_controller.dart';
import '../Controllers/internet_connectivity.dart';

class FeedbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetConnectivityController());
    Get.put(FeedbackController());
  }
}
