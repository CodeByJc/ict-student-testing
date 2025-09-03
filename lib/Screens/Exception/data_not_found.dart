import 'package:flutter/material.dart';

import '../../Helper/colors.dart';
import '../../Helper/Components.dart';
import '../../Helper/images_path.dart';

class DataNotFound extends StatelessWidget {
  const DataNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          Container(
            color: backgroundColor,
            child: SizedBox(
              height: getHeight(context, 0.7),
              child: Expanded(
                  child: SizedBox(
                height: getHeight(context, 1),
                width: getWidth(context, 1),
                child: Align(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: 0.5,
                        child: Image.asset(
                          noDataAvailabeIMG,
                          height: 150,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Data Not Found",
                          style: TextStyle(
                              fontFamily: "mu_reg",
                              fontSize: 18,
                              color: Light2,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                ),
              )),
            ),
          )
        ]);
  }
}
