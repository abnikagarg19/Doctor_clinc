import 'dart:ui';

import 'package:chatbot/controller/signupController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' show Platform;
import '../components/button.dart';
import '../components/input_field.dart';
import '../controller/authController.dart';
import '../theme/apptheme.dart';
import 'login.dart';
import 'otp_page.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});

  final forget = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AuthController>(builder: (_controller) {
        return Stack(
          children: [
            Container(
                decoration: BoxDecoration(
              gradient: SweepGradient(
                colors: [
                  Color(0xFFF5EBF1), Color(0xFFF0EDFA),
                  Color(0xFFF0E4E1),

                  Color(0xFFF0EDFA),
                  Color(0xFFF4E2Ed),

                  //  Colors.red, // Top-left
                  // Colors.orange, // Top-right
                  // Colors.yellow, // Center
                  // Colors.green, // Bottom-left
                  // Colors.blue, // Bottom-right
                  //    Colors.red, // Top-left
                  // const Color(0xFFFEBA64).withOpacity(0.3),
                  // const Color(0xFFFBA56F).withOpacity(0.3),
                  // const Color(0xFFFEBA64).withOpacity(0.3),
                  // const Color(0xFFF56F8A).withOpacity(0.3),
                  // const Color(0xFFFEBA64).withOpacity(0.3),
                ],
                center: Alignment.center,
                stops: [
                  0.0, // Red
                  0.25, // Orange
                  0.5, // Yellow (center)
                  0.75, // Green
                  1.0, // Blue
                ],

                transform: GradientRotation(45 * 3.14 / 180),
                //       begin: Alignment(-1.0, -1.0),
                // end: Alignment(2.0, 4.0),)
              ),
            )),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    //   color: Color.fromARGB(70, 250, 220, 238),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: const Color.fromARGB(84, 149, 147, 147),
                          spreadRadius: 2,
                          offset: Offset(0, 0),
                          blurRadius: 50)
                    ],
                    border: Border.all(
                      color: const Color.fromARGB(138, 255, 255, 255),
                    )),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),

                    Image.asset(
                      "assets/images/a1.png",
                      height: 90,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Reset Password",
                        style: GoogleFonts.roboto(
                          color: AppTheme.bodyTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )),
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: forget,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Password",
                                style: GoogleFonts.roboto(
                                  color: AppTheme.hintTextColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                )),
                            MyTextField(
                                preicon: SvgPicture.asset(
                                    "assets/images/lock.svg",
                                    height: 10,
                                    fit: BoxFit.scaleDown),
                                textEditingController:
                                    _controller.Resetpassword,
                                validation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                                hintText: "Enter Password",
                                color: const Color(0xff585A60)),
                            SizedBox(
                              height: 4,
                            ),
                            Text("Confirm Password",
                                style: GoogleFonts.roboto(
                                  color: AppTheme.hintTextColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                )),
                            MyTextField(
                                preicon: SvgPicture.asset(
                                    "assets/images/lock.svg",
                                    height: 10,
                                    fit: BoxFit.scaleDown),
                                textEditingController:
                                    _controller.Resetpassword,
                                validation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                                hintText: "Enter Confirm Password",
                                color: const Color(0xff585A60)),
                            SizedBox(
                              height: 16,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Button(
                                  tittle: "Submit",
                                  tap: () {
                                    // Get.to(OtpPage());
                                    if (forget.currentState!.validate()) {
                                      //  _controller.submitForgetPassword();
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16),
                    // ...List.generate(socialLogis.length, (index) {
                    //   if(!kIsWeb){

                    //   if (!Platform.isIOS && index == 2) {
                    //     return Container();
                    //   }
                    //   }
                    //   return Padding(
                    //     padding: const EdgeInsets.only(bottom: 12),
                    //     child: SocialLogin(
                    //       assets: socialLogis[index]["logo"],
                    //       tittle: socialLogis[index]["title"],
                    //       webview: socialLogis[index]["webview"],
                    //     ),
                    //   );
                    // }),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
