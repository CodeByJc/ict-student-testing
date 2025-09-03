import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_mu_students/Helper/colors.dart';

import 'Style.dart';

double getHeight(context, double i) {
  double result = MediaQuery.of(context).size.height * i;
  return result;
}

double getWidth(context, double i) {
  double result = MediaQuery.of(context).size.width * i;
  return result;
}

double getSize(context, double i) {
  double result = MediaQuery.of(context).size.width * i / 50;
  return result;
}

Widget blackTag(context, Color? color, String? line1, String? line2,
    Widget? imageWidget, bool isReverse, String onTapPath, arg) {
  return InkWell(
    onTap: () => Get.toNamed(onTapPath, arguments: arg),
    child: Container(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Conditional alignment
        children: isReverse
            ? [
                Container(
                  height: 65,
                  width: 50,
                  decoration: BoxDecoration(
                    color: color ?? Colors.black,
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(500),
                    ),
                  ),
                ),
                Container(
                  height: 65,
                  width: 300,
                  decoration: BoxDecoration(
                    color: color ?? Colors.black,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(500),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          height: 55,
                          width: 55,
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(500))),
                          child: imageWidget,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: getWidth(context, 0.5),
                              child: Text(
                                line1 ?? "Loading...",
                                overflow: TextOverflow.ellipsis,
                                style: tagStyle(Colors.white, 18, true),
                              ),
                            ),
                            Text(
                              line2 ?? "Loading...",
                              overflow: TextOverflow.ellipsis,
                              style: tagStyle(Light2, 15, false),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            : [
                Container(
                  height: 65,
                  width: 300,
                  decoration: BoxDecoration(
                    color: color ?? Colors.black,
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(500),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text(
                                line1 ?? "Loading...",
                                overflow: TextOverflow.ellipsis,
                                style: tagStyle(Colors.white, 18, true),
                              ),
                            ),
                            Text(
                              line2 ?? "Loading...",
                              overflow: TextOverflow.ellipsis,
                              style: tagStyle(Light2, 15, false),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                500), // Clipping the image into a circle
                            child: imageWidget),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 65,
                  width: 50,
                  decoration: BoxDecoration(
                    color: color ?? Colors.black,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(500),
                    ),
                  ),
                ),
              ],
      ),
    ),
  );
}


radialIndicator(BuildContext context, double input) {
  return Stack(
    alignment: Alignment.center,
    children: [
      TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: input),
        duration: const Duration(seconds: 1),
        curve: Easing.linear,
        builder: (context, value, child) {
          return Center(
            child: Text(
              '${value.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize:
                    value < 100 ? getSize(context, 3.5) : getSize(context, 3),
                fontFamily: "mu_bold",
                color: muColor,
              ),
            ),
          );
        },
      ),
      TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: input / 100),
        duration: const Duration(seconds: 1),
        curve: Easing.linear,
        builder: (context, value, child) {
          return SizedBox(
            width: 70,
            height: 70,
            child: CircularProgressIndicator(
              value: value,
              backgroundColor: muGrey2,
              strokeWidth: 6,
              valueColor: AlwaysStoppedAnimation<Color>(muColor),
            ),
          );
        },
      ),
    ],
  );
}

attendanceCard(context, String subName, String facName, String startTime,
    String endTime, String status, String lecType) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Container(
      decoration: BoxDecoration(
        color: muGrey,
        borderRadius: BorderRadius.circular(getSize(context, 1.5)),
      ),
      child: Card(
        color: Colors.transparent,
        elevation: null,
        shadowColor: Colors.transparent,
        child: ListTile(
          title: Text(
            "$subName  ( $lecType )",
            style: TextStyle(
              letterSpacing: 0,
              fontSize: getSize(context, 2.4),
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedClock01,
                        color: Colors.grey,
                        size: getSize(context, 2.5),
                      )),
                  Text(
                      "$startTime ${int.parse(startTime.substring(0, 1)) < 12 ? "AM" : "PM"} "
                      "to "
                      "$endTime ${int.parse(endTime.substring(0, 1)) < 12 ? "AM" : "PM"} ",
                      style: TextStyle(
                        fontSize: getSize(context, 1.8),
                        fontFamily: 'mu_reg',
                      )),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedUser,
                        color: Colors.grey,
                        size: getSize(context, 2.5),
                      )),
                  Text(facName,
                      style: TextStyle(
                        fontSize: getSize(context, 1.8),
                        fontFamily: 'mu_reg',
                      )),
                ],
              ),
            ],
          ),
          trailing: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(500),
              color: status == 'Present' ? Colors.green : Colors.redAccent,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Text(
                status,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getSize(context, 2),
                  fontFamily: 'mu_reg',
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
