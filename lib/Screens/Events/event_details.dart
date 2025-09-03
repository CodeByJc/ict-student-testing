import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_mu_students/Controllers/event_controller.dart';
import 'package:ict_mu_students/Model/event_model.dart';
import 'package:ict_mu_students/Widgets/clickable_text.dart';
import 'package:ict_mu_students/Widgets/heading_1.dart';
import 'package:intl/intl.dart';
import '../../Helper/Style.dart';
import '../../Helper/colors.dart';

class EventDetails extends GetView<EventController> {
  const EventDetails({super.key});
  @override
  Widget build(BuildContext context) {

    EventModel event = Get.arguments['event'];


    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Event Details",
          style: appbarStyle(context),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: backgroundColor),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body:
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Heading1(text: event.eventTitle, fontSize: 2.7, leftPadding: 2),
                SizedBox(height: 30,child: Divider(color: muGrey2,),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                ),
                SizedBox(height: 30,child: Divider(color: muGrey2,)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClickableText(event.eventDetails),
                ),
              ],
            ),
          ),
        )

    );
  }
}
