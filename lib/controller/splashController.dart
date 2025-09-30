import 'dart:async';
import 'package:chatbot/service/shared_pref.dart';
import 'package:chatbot/utils/app_routes.dart';
import 'package:chatbot/view/login.dart';
import 'package:get/get.dart';

import '../view/home.dart';

class splashController extends GetxController {
  final image =  "assets/images/aoenlyf.png";

  @override
  void onReady() {
    super.onReady();
    Timer(const Duration(seconds: 2), () {
      if (PreferenceUtils.isLoggedIn()) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    });
    // }
  }
}
