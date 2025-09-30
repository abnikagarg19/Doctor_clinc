import 'package:flutter/material.dart';

double getResponsiveFontSize(BuildContext context, double fontSize) {
  double screenWidth = MediaQuery.of(context).size.width;
  // Assume a base width of 375.0 (iPhone X width), adjust as needed
  double baseWidth = 375.0;
  return fontSize * (screenWidth / baseWidth);
}
