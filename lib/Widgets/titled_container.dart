// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:ict_mu_students/Helper/colors.dart';
import 'package:ict_mu_students/Helper/size.dart';

class TitledContainer extends StatelessWidget {
  final title;
  final children;
  const TitledContainer(
      {super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRad),
              border: Border.all(color: muGrey2, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: children,
                ),
              ),
            ),
          ),
        ),
        Center(
            child: Container(
                color: backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 16),
                  ),
                )))
      ],
    );
  }
}
