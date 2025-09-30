import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chatbot/service/home_repo.dart';
import 'package:chatbot/service/shared_pref.dart';
import 'package:chatbot/utils/app_routes.dart';
import 'package:chatbot/view/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../components/commons.dart';
import '../view/home.dart';

class Profilecontroller extends GetxController {
  int selectedIndex = 0;
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final mobile = TextEditingController();
  final email = TextEditingController();
  final currentPassword = TextEditingController();
  final newPassword = TextEditingController();
  final newConfirmPassword = TextEditingController();
  bool isnotification = false;
  bool isSound = false;
  @override
  void onInit() {
    super.onInit();
    debugPrint("onInit yes");
  }

  changeIndex(index) {
    selectedIndex = index;
    update();
  }

  @override
  void onReady() {
    super.onReady();
  }

  Uint8List? fileBytes;

  File? ProfileImage;
  Future getImage(ImageSource img) async {
    try {
      final image = await ImagePicker().pickImage(
        source: img,
      );
      if (image == null) return;

      final imageTemp = File(
        image.path,
      );

      if (!kIsWeb) {
        if (image != null) {
          ProfileImage = File(image.path);
        }
         } else {
          fileBytes = await image.readAsBytes();
        }
     
      // setState(() {

      update();
      Get.back();
    } on PlatformException catch (e) {
      print(e);
    }
  }

  updateInfo() async {
    HomeService()
        .apiUpdateProfile(
            firstName.text, lastName.text, mobile.text, email.text, "")
        .then((value) {
      print(value.statusCode);
      DialogHelper.hideLoading();
      switch (value.statusCode) {
        case 200:
          var data2 = jsonDecode(value.body);
          print(value.body);
          //var data2 = jsonDecode(value.data);
          DialogHelper.showErroDialog(description: "Profile Updated");
          break;
        case 404:
          var data2 = jsonDecode(value.body);
          DialogHelper.showErroDialog(description: data2["detail"].toString());

          break;
        case 1:
          break;
        default:
          var data2 = jsonDecode(value.body);
          DialogHelper.showErroDialog(description: data2["detail"].toString());
          break;
      }
    });
  }
}
