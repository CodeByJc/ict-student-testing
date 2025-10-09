import 'package:get/get.dart';
import '../Controllers/job_market_controller.dart';
import '../Controllers/internet_connectivity.dart';

class JobMarketBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetConnectivityController());
    Get.put(JobMarketController());
  }
}

