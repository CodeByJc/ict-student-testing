import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_mu_students/Helper/size.dart';

import '../Helper/colors.dart';
import '../Helper/Components.dart';

class TapIcon extends StatelessWidget {
      final String name;
      final double nameSize = 2;
      final IconData iconData;
      final double iconSize = 40;
      final String route;
      final routeArg;

      const TapIcon({
        super.key,
        required this.name,
        // required this.nameSize,
        required this.iconData,
        // required this.iconSize,
        required this.route,
        this.routeArg});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(route, arguments: routeArg),
      child: Column(
        children: [
          Container(
            height: 75,
            width: 75,
            decoration: BoxDecoration(
              color: muGrey,
              borderRadius: BorderRadius.circular(15), // rounded corners
            ),
            child: Center(
              child: HugeIcon(
                icon: iconData,
                color: Colors.black,
                size: iconSize,
              ),
            ),
          ),
          SizedBox(
            height: getHeight(Get.context!, 0.01),
          ),
          SizedBox(
              height: getHeight(Get.context!, 0.05),
              width: getWidth(Get.context!, 0.25),
              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: 'mu_reg',
                    color: muColor,
                    height: 1,
                    fontSize: getSize(Get.context!, nameSize)),
                // softWrap: true,
                textAlign: TextAlign.center,
              ))
        ],
      ),
    );
  }
}

class TapIcon2 extends StatelessWidget {
  final String name;
  final double nameSize = 2;
  final IconData iconData;
  final double iconSize = 25;
  final String route;
  final routeArg;

  const TapIcon2({
    super.key,
    required this.name,
    // required this.nameSize,
    required this.iconData,
    // required this.iconSize,
    required this.route,
    this.routeArg});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(route, arguments: routeArg),
      child: Container(
        decoration: BoxDecoration(
          color: muGrey,
          borderRadius: BorderRadius.circular(borderRad), // rounded corners
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Center(
                child: HugeIcon(
                  icon: iconData,
                  color: Colors.black,
                  size: iconSize,
                ),
              ),
            ),

            SizedBox(
                height: getHeight(Get.context!, 0.05),
                width: getWidth(Get.context!, 0.30),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'mu_reg',
                        color: muColor,
                        height: 1,
                        fontSize: getSize(Get.context!, nameSize)),
                    // softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}