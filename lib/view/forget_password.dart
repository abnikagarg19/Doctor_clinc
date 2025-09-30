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

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key});

  final forget = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetBuilder<AuthController>(builder: (_controller) {
      return  LayoutBuilder(
          // If our width is more than  1100 then we consider it a desktop
          builder: (context, constraints) {
          return Stack(
            children: [
              Positioned(
                bottom: -50,
                child: Image.asset(
                  "assets/images/bg2.png",
                  height: Get.height / 1.7,
                ),
              ),
              Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth:  MediaQuery.of(context).size.width * .9),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (constraints.maxWidth > 800)
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Image.asset(
                                "assets/images/logo.png",
                                height: 150,
                              ),
                            ),
                          ),
                        Expanded(
                          /// constraints: BoxConstraints(maxWidth: 500, minWidth: 400),
                          child: Column(
                              //  mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: constraints.maxWidth > 900
                                  ? MainAxisAlignment.center
                                  : MainAxisAlignment.start,
                              children: [
                                if (constraints.maxWidth < 900)
                                  Container(
                                    padding: EdgeInsets.only(
                                        bottom: 30, top: 50, right: 40),
                                    child: Image.asset(
                                      "assets/images/logo.png",
                                      height: 100,
                                    ),
                                  ),
                                Form(
                                  key: forget,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Forgot Password",
                                          style: GoogleFonts.roboto(
                                            color: AppTheme.bodyTextColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                          "Enter the registered email and we will send an otp",
                                          style: GoogleFonts.roboto(
                                            color: AppTheme.hintTextColor,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          )),
                                      SizedBox(
                                        height: 12,
                                      ),
                                    
                                      MyTextField(
                                          textEditingController:
                                              _controller.emailForget,
                                          validation: (value) {
                                            RegExp emailValidatorRegExp = RegExp(
                                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                                            if (value == null || value.isEmpty) {
                                              return 'Required';
                                              // }
                                            } else if (!emailValidatorRegExp
                                                .hasMatch(value.trim())) {
                                              return 'Enter Valid email';
                                            }
                                            return null;
                                          },
                                          hintText: "Enter your Email",
                                          color: const Color(0xff585A60)),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: Button(
                                            tittle: "Submit",
                                            tap: () {
                                              if (forget.currentState!.validate()) {
                                                _controller.submitForgetPassword();
                                              }
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ]),
                        ),
                      ]),
                ),
              ),
            ],
          );
        }
      );
    }));
  }
}
