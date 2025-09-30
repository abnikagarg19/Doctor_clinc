import 'dart:async' show Timer;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;

import '../../theme/apptheme.dart';
import '../../utils/app_routes.dart';
import '../../videocall/api.dart';
import '../../videocall/meeting_screen.dart';

class BookedAppointment extends StatefulWidget {
  BookedAppointment({
    super.key,
  });

  @override
  State<BookedAppointment> createState() => _BookedAppointmentState();
}

class _BookedAppointmentState extends State<BookedAppointment> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    redirectScreen();
  }

  redirectScreen() {
    Timer(const Duration(seconds: 4), () {
      Get.to(
        MeetingScreen(
          meetingId: "kv3f-g63t-55fx",
          token: token,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 100),

              Text(
                "Based on your test results, I’m\nconnecting you to Dr Siri. ",
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  color: AppTheme.blackColor,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                "Please hold while I establish the connection.",
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  color: AppTheme.blackColor,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 60),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child:
                    Image.asset("assets/images/Ellipse 249.png", height: 120),
              ),
              SizedBox(height: 20),
              Text(
                "Dr. Siri Karthika R",
                style: GoogleFonts.quicksand(
                  color: AppTheme.blackColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "MBBS, 2 Years of exp",
                style: GoogleFonts.quicksand(
                  color: AppTheme.blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Cardiology",
                style: GoogleFonts.quicksand(
                  color: AppTheme.lightPrimaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text("Apollo Hospital"),
              SizedBox(height: 60),
              Image.asset(
                "assets/images/Typing Indicator.png",
              ),
              // Padding(
              //   padding:
              //       EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              //   child: Button(
              //       tittle: "My Appointmnets",
              //       tap: () {
              //         controller.onCreateButtonPressed(
              //             context,
              //             doctorid,
              //             DateFormat("yyyy-MM-dd")
              //                 .format(controller.selectedDate),
              //             controller.selectedSlot);
              //       }),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
