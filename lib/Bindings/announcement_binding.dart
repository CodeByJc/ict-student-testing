import 'package:get/get.dart';
import '../../Controllers/announcement_controller.dart';

class AnnouncementBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AnnouncementController());
  }
}
