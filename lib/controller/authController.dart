import 'dart:convert';

import 'package:chatbot/service/auth_service.dart';
import 'package:chatbot/utils/app_routes.dart';
import 'package:chatbot/view/home.dart';
import 'package:chatbot/view/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/commons.dart';
import '../service/shared_pref.dart';
import '../videocall/join_screen.dart';
import '../view/components/side_menu.dart';
import '../view/otp_forget.dart';

class AuthController extends GetxController {
  final email = TextEditingController();
  final password = TextEditingController();
  final emailForget = TextEditingController();
  final Resetpassword = TextEditingController();
  final ResetpasswordConfirm = TextEditingController();
  bool isRemember = false;
  var passwordLoginVisibility = false;
  void showPassword() {
    passwordLoginVisibility = !passwordLoginVisibility;
    update();
  }

  final service = AuthService();

  login() {
    DialogHelper.showLoading();
    service.apiLoginService(email.text, password.text).then((value) {
      print(value.statusCode);
      DialogHelper.hideLoading();
      switch (value.statusCode) {
        case 200:
          var data2 = jsonDecode(value.body);
          print(value.body);
          //var data2 = jsonDecode(value.data);
          if (data2["status"]) {
            PreferenceUtils.setString("email", email.text.toString());
            PreferenceUtils.setString(
                "id", data2["data"]["user_id"].toString());
            PreferenceUtils.setString("name", data2["data"]["name"].toString());
            PreferenceUtils.saveUserToken(data2["access_token"].toString());
            Get.toNamed(Routes.HOME);
          } else {
            DialogHelper.showErroDialog(
                description: data2["message"].toString());
          }
          break;
        case 404:
          var data2 = jsonDecode(value.body);
          DialogHelper.showErroDialog(description: data2["message"].toString());

          break;
        case 1:
          break;
        default:
          var data2 = jsonDecode(value.body);
          DialogHelper.showErroDialog(description: data2["message"].toString());
          break;
      }
    });
  }

  void submitForgetPassword() {
    DialogHelper.showLoading();
    service.apiForgetPassword(emailForget.text).then((value) {
      print(value.statusCode);
      DialogHelper.hideLoading();
      switch (value.statusCode) {
        case 200:
          var data2 = jsonDecode(value.body);
          Get.to(OtpForgetPage(
            email: emailForget.text,
            emailid: data2["email_id"].toString(),
          ));
          break;
        case 400:
          var data2 = jsonDecode(value.body);
          DialogHelper.showErroDialog(description: data2["detail"].toString());
          break;
        case 1:
          break;
        default:
          DialogHelper.showErroDialog(description: "Try again later");
          break;
      }
    });
  }

  final pinController = TextEditingController();
  void verifyOtp(String otp, emailid) async {
    DialogHelper.showLoading();
    service.apiVerifyOtpForgetService(otp, emailid).then((value) {
      print(value.body);
      DialogHelper.hideLoading();
      switch (value.statusCode) {
        case 200:
          var data2 = jsonDecode(value.body);

          // PreferenceUtils.setString("email", data2["email"].toString());
          // PreferenceUtils.setString("id", data2["id"].toString());
          // PreferenceUtils.setString("name", data2["name"].toString());
          // PreferenceUtils.saveUserToken(data2["token"].toString());
          // Get.offAll(MainScreen());
          Get.to(ResetPassword());

          break;
        case 400:
          var data2 = jsonDecode(value.body);
          DialogHelper.showErroDialog(description: data2["detail"].toString());

          break;
        case 1:
          break;
        default:
          DialogHelper.showErroDialog(description: "Try again later");
          break;
      }
    });
  }

  void otpResendValidSubmit(String email) async {
    DialogHelper.showLoading();
    service.apiResendOtp(email).then((value) {
      print(value.statusCode);
      DialogHelper.hideLoading();
      switch (value.statusCode) {
        case 200:
          pinController.text = "";
          DialogHelper.showErroDialog(description: "Resend Successfully");
          break;
        case 400:
          var data2 = jsonDecode(value.body);
          DialogHelper.showErroDialog(description: data2["detail"].toString());

          break;
        case 1:
          break;
        default:
          DialogHelper.showErroDialog(description: "Try again later");
          break;
      }
    });
  }
}
