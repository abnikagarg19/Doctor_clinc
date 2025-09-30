import 'package:chatbot/responsive.dart';
import 'package:flutter/material.dart';

class Constant {
  static double TwentyHeight(BuildContext context) {
    return ResponsiveLayout.isSmallScreen(context) ||
            ResponsiveLayout.isMediumScreen(context)
        ? 10
        : 20;
  }

  static double foutyHeight(BuildContext context) {
    return ResponsiveLayout.isSmallScreen(context) ||
            ResponsiveLayout.isMediumScreen(context)
        ? 20
        : 40;
  }

  static double ThirytyHeight(BuildContext context) {
    return ResponsiveLayout.isSmallScreen(context) ||
            ResponsiveLayout.isMediumScreen(context)
        ? 12
        : 30;
  }

  static double mainHeading(BuildContext context) {
    return ResponsiveLayout.isSmallScreen(context) ||
            ResponsiveLayout.isMediumScreen(context)
        ? 20
        : 38;
  }

  static double subHeading(BuildContext context) {
    return ResponsiveLayout.isSmallScreen(context) ||
            ResponsiveLayout.isMediumScreen(context)
        ? 16
        : 32;
  }

  static double body(BuildContext context) {
    return ResponsiveLayout.isSmallScreen(context) ||
            ResponsiveLayout.isMediumScreen(context)
        ? 14
        : 20;
  }

  static double mediumbody(BuildContext context) {
    return ResponsiveLayout.isSmallScreen(context) ||
            ResponsiveLayout.isMediumScreen(context)
        ? 14
        : 18;
  }

  static double smallbody(BuildContext context) {
    return ResponsiveLayout.isSmallScreen(context) ||
            ResponsiveLayout.isMediumScreen(context)
        ? 12
        : 16;
  }

  static double verysmallbody(BuildContext context) {
    return ResponsiveLayout.isSmallScreen(context) ||
            ResponsiveLayout.isMediumScreen(context)
        ? 12
        : 14;
  }

  static double largeBody(BuildContext context) {
    return ResponsiveLayout.isSmallScreen(context) ||
            ResponsiveLayout.isMediumScreen(context)
        ? 18
        : 22;
  }

  static double texttwetyeight(BuildContext context) {
    return ResponsiveLayout.isSmallScreen(context) ||
            ResponsiveLayout.isMediumScreen(context)
        ? 24
        : 28;
  }



  static double twetysixtext(BuildContext context) {
    return ResponsiveLayout.isSmallScreen(context) ||
            ResponsiveLayout.isMediumScreen(context)
        ? 18
        : 24;
  }

  static double verysmalltwelve(BuildContext context) {
    return ResponsiveLayout.isSmallScreen(context) ||
            ResponsiveLayout.isMediumScreen(context)
        ? 10
        : 12;
  }

  static double verysmallten(BuildContext context) {
    return ResponsiveLayout.isSmallScreen(context) ||
            ResponsiveLayout.isMediumScreen(context)
        ? 8
        : 10;
  }

  static double textfourtyeight(BuildContext context) {
    return ResponsiveLayout.isSmallScreen(context) ||
            ResponsiveLayout.isMediumScreen(context)
        ? 44
        : 48;
  }
   static double sixtyeight(BuildContext context) {
    return ResponsiveLayout.isSmallScreen(context) ||
            ResponsiveLayout.isMediumScreen(context)
        ? 40
        : 68;
  }
}
