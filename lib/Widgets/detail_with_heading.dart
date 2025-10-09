import 'package:flutter/material.dart';
import '../Helper/colors.dart';
import '../Helper/size.dart';

class DetailWithHeading extends StatelessWidget {
  final String headingName;
  final dynamic details;

  const DetailWithHeading({
    super.key,
    required this.headingName,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: muGrey2),
        borderRadius: BorderRadius.circular(borderRad),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Container(
                width: 2,
                height: 45,
                decoration: BoxDecoration(
                  color: muColor,
                  borderRadius: BorderRadius.circular(borderRad),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headingName,
                    style: TextStyle(
                      color: muColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    details.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
