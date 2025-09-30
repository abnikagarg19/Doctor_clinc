

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../responsive.dart';
import '../../theme/apptheme.dart';


final navLinks = [
  "Health Record",
  "Selfcare Tools",
  "Journal",
];
List<Widget> navItem() {
  return navLinks.map((text) {
    return Padding(
      padding: EdgeInsets.only(left: 80, bottom: 10),
      child: InkWell(
        onTap: () {
          // if (text == "Health Record") {
          //   Get.to(EhrDashboard());
          // } else if (text == "Selfcare Tools") {
          //   Get.toNamed(Routes.Task);
          // } else {
          //   Get.toNamed(Routes.journal);
          // }
        },
        child: Text(text,
            style: GoogleFonts.rubik(
                color: AppTheme.blackColor,
                fontSize: 20,
                height: 0,
                fontWeight: FontWeight.w700)),
      ),
    );
  }).toList();
}

void _scrollToContainer(GlobalKey key) {
  final context = key.currentContext;
  if (context != null) {
    Scrollable.ensureVisible(
      context,
      duration: Duration(milliseconds: 500), // Smooth animation
      curve: Curves.linear,
    );
  }
}

class HeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[...navItem()]);
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ResponsiveLayout(
        desktop: buildHeader(),
        // We will make this in a bit
        mobile: buildMobileHeader(),
        //    mediumScreen: buildHeader(),
      ),
    );
  }

  // mobile header
  Widget buildMobileHeader() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: 30,
            ),
            // Restart server to make icons work
            // Lets make a scaffold key and create a drawer
          ],
        ),
      ),
    );
  }

  // Lets plan for mobile and smaller width screens
  Widget buildHeader() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: 80,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Row(children: <Widget>[...navItem()]),
            ),
            Align(
              alignment: Alignment.topRight,
              child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                        onTap: () {
                        //  Get.to(Profile());
                        },
                        child: Icon(CupertinoIcons.person_alt_circle)),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
