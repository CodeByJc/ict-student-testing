import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ict_mu_students/Helper/colors.dart';

import '../Helper/Components.dart';

class Heading1 extends StatelessWidget {
  final String text;
  final double fontSize;
  final double leftPadding;
  final TextOverflow textWrap;

  const Heading1({
    super.key,
    required this.text,
    required this.fontSize,
    required this.leftPadding,
    this.textWrap = TextOverflow.visible,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0, bottom: 4, left: leftPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              height: getSize(Get.context!, fontSize * 1.5),
              width: getSize(Get.context!, fontSize * 0.35),
              decoration: BoxDecoration(
                color: muColor,
                borderRadius: BorderRadius.circular(500),
              ),
            ),
          ),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: "mu_bold",
                fontSize: getSize(context, fontSize),
                letterSpacing: 0.1,
              ),
              overflow: textWrap,
            ),
          ),
        ],
      ),
    );
  }
}
