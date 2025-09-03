import 'package:get/get.dart';
import '../Controllers/event_controller.dart';
import '../Controllers/internet_connectivity.dart';

class EventBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetConnectivityController());
    Get.put(EventController());
  }
}
