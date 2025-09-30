import 'package:chatbot/controller/signupController.dart';
import 'package:chatbot/responsive.dart';
import 'package:chatbot/utils/constant.dart';
import 'package:chatbot/utils/social_logins.dart';
import 'package:chatbot/view/onboard/onboard.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/button.dart';
import '../components/input_field.dart';

import '../theme/apptheme.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final loginformKey = GlobalKey<FormState>();
  List socialLogis = [
    {
      "title": "Continue with Gooogle",
      "logo": "assets/images/google.png",
      "webview": "google",
    },
    {
      "title": "Continue with Facebook",
      "logo": "assets/images/facebook.png",
      "webview": "facebook",
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ResponsiveLayout(
          desktop: _buildLoginWidget(
              context, MediaQuery.of(context).size.width * .8),
          tablet: _buildLoginWidget(
              context, MediaQuery.of(context).size.width * .9),
          mobile: _buildLoginWidget(
              context, MediaQuery.of(context).size.width * .9)),
    );
  }

  _buildLoginWidget(context, width) {
    return GetBuilder<SignUpController>(builder: (_controller) {
      return LayoutBuilder(
          // If our width is more than 1100 then we consider it a desktop
          builder: (context, constraints) {
        return Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: width),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   if (constraints.maxWidth > 800)
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      "assets/images/aoenlyf.png",
                      // height: 150,
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
                           height: 60,
                            
                          ),
                        Form(
                          key: loginformKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Welcome Onboard!',
                                      style: GoogleFonts.rubik(
                                        color: AppTheme.blackColor,
                                        fontSize: Constant.textfourtyeight(
                                            context),
                                        fontWeight: FontWeight.w700,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              MyTextField(
                                  textEditingController: _controller.email,
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
                                  },labelText: 'Email', preicon: SvgPicture.asset("assets/svg/mail.svg",height: 10, fit: BoxFit.scaleDown,alignment: Alignment.center,),
                                  hintText: "Enter your Email",
                                  color: const Color(0xff585A60)),
                              SizedBox(
                                height: 30,
                              ),
                              MyTextField(
                                  isSuffixIcon: true,
                                  textEditingController:
                                      _controller.password,
                                  obsecureText:
                                      !_controller.passwordLoginVisibility,
                                  ontapSuffix: () {
                                    _controller.showPassword();
                                  },
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                   preicon: SvgPicture.asset("assets/svg/lock.svg", height: 15,width: 15,fit: BoxFit.scaleDown,),
                                  labelText: 'Password',
                                  hintText: 'Enter your password',
                                  color: const Color(0xff585A60)),
                              SizedBox(
                                height: 30,
                              ),
        
                              MyTextField(
                                  isSuffixIcon: true,
                                  textEditingController:
                                      _controller.confirmpassword,
                                  obsecureText:
                                      !_controller.passwordLoginVisibility2,
                                  ontapSuffix: () {
                                    _controller.showPassword2();
                                  },
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                  preicon: SvgPicture.asset("assets/svg/lock.svg", height: 15,width: 15,fit: BoxFit.scaleDown,),
                                   labelText: 'Re-enter Password',
                                  hintText: 'Re-enter Password',
                                  color: const Color(0xff585A60)),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     SizedBox(
                              //       height: 20,
                              //       child: FittedBox(
                              //         fit: BoxFit.fill,
                              //         child: Checkbox(
                              //           // This bool value toggles the switch.
                              //           value: _controller.isRemember,
                              //           activeColor:
                              //               AppTheme.lightPrimaryColor,
        
                              //           onChanged: (value) {},
                              //         ),
                              //       ),
                              //     ),
                              //     Flexible(
                              //       child: RichText(
                              //         text: TextSpan(
                              //           text: ' I agree to the',
                              //           style: GoogleFonts.rubik(
                              //             color: AppTheme.hintTextColor,
                              //             fontSize:
                              //                 Constant.smallbody(context),
                              //             fontWeight: FontWeight.w500,
                              //           ),
                              //           children: <TextSpan>[
                              //             TextSpan(
                              //                 text: ' Terms of Service',
                              //                 style: TextStyle(
                              //                     fontSize:
                              //                         Constant.smallbody(
                              //                             context),
                              //                     color:
                              //                         AppTheme.linkColor)),
                              //             TextSpan(
                              //               text: ' and',
                              //             ),
                              //             TextSpan(
                              //                 text: ' Privacy Statement',
                              //                 style: TextStyle(
                              //                     fontSize:
                              //                         Constant.smallbody(
                              //                             context),
                              //                     color:
                              //                         AppTheme.linkColor)),
                              //           ],
                              //         ),
                              //         overflow: TextOverflow.ellipsis,
                              //         maxLines: 2,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              SizedBox(
                                height: 60,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Button(
                                    tittle: "Signup",
                                    tap: () {
                                      Get.to(OnboardPage());
                                      // if (loginformKey.currentState!
                                      //     .validate()) {
                                      //   //   Get.to(AiChatBot());
                                      //   _controller.signUp();
                                      // }
                                    }),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                          ),
                          child: Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text("OR"),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: SocialLogin(
                                  assets: socialLogis[0]["logo"],
                                  webview: socialLogis[0]["webview"],
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: SocialLogin(
                                  assets: socialLogis[1]["logo"],
                                  webview: socialLogis[1]["webview"],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Already have an Account? ',
                            style: GoogleFonts.rubik(
                              color: AppTheme.hintTextColor,
                              fontSize: Constant.smallbody(context),
                              fontWeight: FontWeight.w600,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Get.back(),
                                  text: ' Login',
                                  style: TextStyle(
                                      fontSize: Constant.smallbody(context),
                                      color: AppTheme.linkColor)),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        );
      });
    });
  }
}
