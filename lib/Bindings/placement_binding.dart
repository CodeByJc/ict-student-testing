import 'package:get/get.dart';
import 'package:ict_mu_students/Controllers/placement_controller.dart';
import '../Controllers/internet_connectivity.dart';

class PlacementBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetConnectivityController());
    Get.put(PlacementController());
  }
}
