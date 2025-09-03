import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_mu_students/Animations/slide_zoom_in_animation.dart';
import 'package:ict_mu_students/Controllers/holiday_list_controller.dart';
import 'package:ict_mu_students/Helper/Components.dart';
import 'package:ict_mu_students/Helper/size.dart';
import 'package:ict_mu_students/Model/holiday_list_model.dart';
import 'package:intl/intl.dart';
import '../../Helper/colors.dart';
import '../../Widgets/adaptive_refresh_indicator.dart';
import '../Exception/data_not_found.dart';
import '../Loading/adaptive_loading_screen.dart';

class HolidayList extends GetView<HolidayListController> {
  const HolidayList({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final shouldScroll = args?['scrollToUpcoming'] ?? false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (shouldScroll) {
        controller.scrollToUpcomingHoliday();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Holidays"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: backgroundColor),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(
            () => controller.isLoadingHolidayList.value
            ? const AdaptiveLoadingScreen()
            : AdaptiveRefreshIndicator(
          onRefresh: () => controller.fetchHolidayList(),
          child: controller.holidayDataList.isNotEmpty
              ? ListView.builder(
            padding: const EdgeInsets.only(bottom: 10),
            controller: controller.scrollController, // Use controller's ScrollController
            itemCount: controller.holidayDataList.length,
            itemBuilder: (context, index) {
              HolidayListModel holiday = controller.holidayDataList[index];

              // Determine if the holiday is upcoming or past
              DateTime holidayDate = DateFormat('yyyy-MM-dd').parse(holiday.holidayDate);
              bool isUpcoming = holidayDate.isAfter(DateTime.now());
              final isFirstUpcoming = index == controller.highlightedIndex;

              return SlideZoomInAnimation(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isFirstUpcoming
                          ? muColor
                          : muGrey, // Adjust color based on whether it's upcoming
                      borderRadius: BorderRadius.circular(borderRad),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedSun03,
                                color: isUpcoming
                                    ? (isFirstUpcoming ? backgroundColor : muColor)
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: getWidth(context, 0.8),
                                child: Text(
                                  holiday.holidayName,
                                  style: TextStyle(
                                    overflow: TextOverflow.visible,
                                    color: isUpcoming
                                        ? (isFirstUpcoming ? backgroundColor : Colors.black)
                                        : Colors.grey,
                                    fontWeight: isFirstUpcoming ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedCalendar02,
                                color: isUpcoming
                                    ? (isFirstUpcoming ? backgroundColor : muColor)
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                DateFormat('dd / MM / yyyy').format(holidayDate),
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: isFirstUpcoming ? FontWeight.bold : FontWeight.normal,
                                  color: isUpcoming
                                      ? (isFirstUpcoming ? backgroundColor : Colors.black)
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )
              : const DataNotFound(),
        ),
      ),
    );
  }
}
