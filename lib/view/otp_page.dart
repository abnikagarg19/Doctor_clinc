import 'dart:ui';

import 'package:chatbot/controller/signupController.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' show Platform;
import '../components/button.dart';
import 'package:pinput/pinput.dart';
import '../theme/apptheme.dart';


class OtpPage extends StatelessWidget {
  OtpPage({
    super.key,
    required this.emailid,
    required this.email,
  });

  final String emailid;
  final String email;

  final loginformKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SignUpController>(builder: (_controller) {
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
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/images/a1.png",
                      ),
                      scale: 1.8)),
            ),
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

                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Form(
                        key: loginformKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("OTP Verification",
                                style: GoogleFonts.roboto(
                                  color: AppTheme.bodyTextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                )),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Enter the OTP that we sent to your registered email ($email)",
                              style: GoogleFonts.roboto(
                                color: AppTheme.hintTextColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: Pinput(
                                controller: _controller.pinController,
                                length: 6,
                                autofocus: true,
                                forceErrorState: true,
                                onCompleted: (pin) => print(pin),
                                defaultPinTheme: PinTheme(
                                  width: 38,
                                  height: 38,
                                  textStyle: TextStyle(fontSize: 16),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 206, 204, 204),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                pinputAutovalidateMode:
                                    PinputAutovalidateMode.onSubmit,
                                validator: (pin) {
                                  if (pin!.length >= 6) return null;
                                  return 'Enter Valid OTP';
                                },
                              ),
                            ),
                            SizedBox(height: 30),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Button(
                                  tittle: "Continue",
                                  tap: () {
                                    if (loginformKey.currentState!.validate()) {
                                      _controller.verifyOtp(
                                          _controller.pinController.text,
                                          emailid);
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Didn't receive the OTP ? ",
                            style: GoogleFonts.roboto(
                              color: AppTheme.hintTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            )),
                        GestureDetector(
                            onTap: () {
                              _controller.otpResendValidSubmit(email);
                            },
                            child: Text(' Resend',
                                style: GoogleFonts.roboto(
                                  color: AppTheme.linkColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ))),
                      ],
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
