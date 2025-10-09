import 'package:flutter/material.dart';

import 'Components.dart';

TextStyle appbarStyle(context) {
  return TextStyle(
    color: Colors.white,
    fontFamily: 'mu_reg',
    fontSize: getSize(context, 2.5),
  );
}

TextStyle tagStyle(Color color, double fsize, bool isBold) {
  return TextStyle(
      color: color, fontFamily: isBold ? "mu_Bold" : "mu_reg", fontSize: fsize);
}
