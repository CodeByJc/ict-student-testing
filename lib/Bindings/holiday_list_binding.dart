import 'package:get/get.dart';
import '../Controllers/holiday_list_controller.dart';
import '../Controllers/internet_connectivity.dart';

class HolidayListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetConnectivityController());
    Get.put(HolidayListController());
  }
}
