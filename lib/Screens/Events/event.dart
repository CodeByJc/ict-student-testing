import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_mu_students/Controllers/event_controller.dart';
import 'package:ict_mu_students/Helper/size.dart';
import 'package:ict_mu_students/Widgets/heading_1.dart';
import '../../Animations/slide_zoom_in_animation.dart';
import '../../Helper/Components.dart';
import '../../Helper/colors.dart';
import '../../Model/event_model.dart';
import '../../Widgets/adaptive_refresh_indicator.dart';
import '../Exception/data_not_found.dart';
import '../Loading/adaptive_loading_screen.dart';

class EventList extends GetView<EventController> {
  const EventList({super.key});

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: backgroundColor),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(
            () => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: TextField(
                    controller: controller.eventSearchController,
                    cursorColor: muColor,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: 'Search Events',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelStyle: TextStyle(
                        fontFamily: "mu_reg",
                        color: muGrey2,
                      ),
                      prefixIcon: HugeIcon(
                          icon: HugeIcons.strokeRoundedSearch01,
                          color:focusNode.hasPrimaryFocus ? muColor : muGrey2
                      ),
                      suffixIcon: controller.eventSearchController.text.isNotEmpty
                          ? IconButton(
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedCancel01,
                          color: focusNode.hasFocus ? muColor : muGrey2,
                        ),
                        onPressed: () {
                          controller.eventSearchController.clear();
                          controller.filterEvents('');
                        },
                      )
                          : null,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: muColor),
                        borderRadius: BorderRadius.circular(borderRad),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: muGrey2),
                        borderRadius: BorderRadius.circular(borderRad),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: getSize(context, 2.5),
                      fontFamily: "mu_reg",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: controller.isLoadingEventList.value
                  ? const AdaptiveLoadingScreen()
                  : AdaptiveRefreshIndicator(
                            onRefresh: () =>
                    controller.fetchEventsList(),
                            child: controller.filteredEventDataList.isNotEmpty
                    ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.filteredEventDataList.length,
                  itemBuilder: (context, index) {
                    EventModel event = controller.filteredEventDataList[index];
                    return SlideZoomInAnimation(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: muGrey,
                            borderRadius: BorderRadius.all(Radius.circular(borderRad))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () => Get.toNamed('eventDetails',arguments: {'event':event}),
                              child: Column(
                                children: [
                                  Heading1(text: event.eventTitle, fontSize: 2.5, leftPadding: 5),
                                  SizedBox(height: 20,
                                    child: Divider(color: muGrey2),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          HugeIcon(icon: HugeIcons.strokeRoundedCalendar01, color: muColor),
                                          const SizedBox(width: 10,),
                                          Text(DateFormat('dd-MM-yyyy').format(DateFormat('yyyy-MM-dd hh:mm:ss').parse(event.eventDatetime))),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          HugeIcon(icon: HugeIcons.strokeRoundedClock03, color: muColor),
                                          const SizedBox(width: 10,),
                                          Text(DateFormat('hh:mm a').format(DateFormat('yyyy-MM-dd hh:mm:ss').parse(event.eventDatetime))),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
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
              ],
            ),
      ),
    );
  }
}
