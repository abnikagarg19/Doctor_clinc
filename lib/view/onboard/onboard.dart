import 'package:chatbot/controller/signupController.dart';
import 'package:chatbot/responsive.dart';
import 'package:chatbot/utils/app_routes.dart';
import 'package:chatbot/utils/constant.dart';
import 'package:chatbot/utils/social_logins.dart';
import 'package:chatbot/view/onboard/components/bank_form.dart';
import 'package:chatbot/view/onboard/components/consultation_form.dart';
import 'package:chatbot/view/onboard/components/label_common.dart';
import 'package:chatbot/view/onboard/components/other_form.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/input_field.dart';
import '../../controller/authController.dart';
import '../../theme/apptheme.dart';
import 'components/experience_form.dart';
import 'components/personal_form.dart';
import 'components/professtional_form.dart';

class OnboardPage extends StatelessWidget {
  OnboardPage({super.key});

  final loginformKey = GlobalKey<FormState>();

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
                      Expanded(
                        /// constraints: BoxConstraints(maxWidth: 500, minWidth: 400),
                        child: SingleChildScrollView(
                          child: Column(
                              //  mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: constraints.maxWidth > 900
                                  ? MainAxisAlignment.center
                                  : MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 40,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 40),
                                  decoration: BoxDecoration(
                                      color: AppTheme.whiteTextColor,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Form(
                                    key: loginformKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                'Join Our Doctor Network – Complete Your Profile',
                                                style: GoogleFonts.rubik(
                                                  color: AppTheme.blackColor,
                                                  fontSize:
                                                      Constant.twetysixtext(
                                                          context),
                                                  fontWeight: FontWeight.w700,
                                                )),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: Text(
                                              'Share your credentials, preferences, and get verified in 24–48 hours.',
                                              style: GoogleFonts.rubik(
                                                color:
                                                    AppTheme.lightHintTextColor,
                                                fontSize:
                                                    Constant.verysmallbody(
                                                        context),
                                                fontWeight: FontWeight.w300,
                                              )),
                                        ),
                                        SizedBox(
                                          height: 40,
                                        ),
                                        Text(
                                            "${_controller.onBoard[_controller.currentStep]}",
                                            style: GoogleFonts.rubik(
                                              color: AppTheme.blackColor,
                                              fontSize:
                                                  Constant.mediumbody(context),
                                              fontWeight: FontWeight.w500,
                                            )),
                                        SizedBox(
                                          height: 40,
                                        ),
                                        _buildSwitchPage(
                                            context,
                                            _controller.currentStep,
                                            _controller),
                                        //  PersonalForm(controller: _controller),
                                        SizedBox(
                                          height: 40,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            if(_controller.currentStep>0)
                                            GestureDetector(
                                              onTap: () {
                                                _controller.goToPreviousStep();
                                              },
                                              child: Container(
                                                  height: 50,
                                                  width: 150,
                                                  decoration: BoxDecoration(
                                                      color: Color.fromRGBO(142, 142, 142, 1),

                                                      /// ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              22)),
                                                  child: Center(
                                                    child: Text(
                                                      "Back",
                                                      style: GoogleFonts.inter(
                                                          fontSize: Constant
                                                              .mediumbody(
                                                                  context),
                                                          color: AppTheme
                                                              .whiteBackgroundColor,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  )),
                                            ),
                                            SizedBox(width: 20,),
                                            GestureDetector(
                                              onTap: () {
                                                _controller.goToNextStep();
                                              },
                                              child: Container(
                                                  height: 50,
                                                  width: 150,
                                                  decoration: BoxDecoration(
                                                      color: AppTheme
                                                          .lightPrimaryColor,

                                                      /// ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              22)),
                                                  child: Center(
                                                    child: Text(
                                                      "Next",
                                                      style: GoogleFonts.inter(
                                                          fontSize: Constant
                                                              .mediumbody(
                                                                  context),
                                                          color: AppTheme
                                                              .whiteBackgroundColor,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
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
                    ])));
      });
    });
  }

  _buildSwitchPage(context, selectIndex, SignUpController _controller) {
   
    switch (selectIndex) {
      case 0:
        return PersonalForm(
          controller: _controller,
        );
      case 1:
        return ProfesstionalForm(
          controller: _controller,
        );
      case 2:
        return ExperienceForm(
          controller: _controller,
        );
      case 3:
        return ConsultationForm(
          controller: _controller,
        );
      case 4:
        return BankingForm(
          controller: _controller,
        );
      case 5:
        return OtherForm(
          controller: _controller,
        );
    }
  }
}
