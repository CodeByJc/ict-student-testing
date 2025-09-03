import 'package:get/get.dart';
import '../Controllers/company_list_controller.dart';
import '../Controllers/internet_connectivity.dart';

class CompanyListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetConnectivityController());
    Get.put(CompanyListController());
  }
}
