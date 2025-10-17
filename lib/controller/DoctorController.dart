import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:chatbot/service/home_repo.dart';
import 'package:chatbot/utils/custom_print.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../view/videocall/components/symptoms_modal.dart';
import '../view/videocall/components/trained_mock_positions.dart';

class Doctorcontroller extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getMeeting();
    loadImage();
    updateSymptomsFromJson(mockSymptomJsonPayload);

    // update();
    //print(parameters["pageIndex"]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  changeSelectDate(value) {
    isLoaded = false;
    selectedDate = value;
    update();
    getMeeting();
  }

  String selectedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  List appointmentList = [];
  bool isLoaded = false;
  void getMeeting() async {
    appointmentList.clear();
    HomeService().apiGetMeeting(selectedDate).then((value) {
      switch (value.statusCode) {
        case 200:
          isLoaded = true;
          final decodedData = jsonDecode(value.body);
          //if (decodedData["data"].isNotEmpty) {
          print(decodedData);
          appointmentList.add(decodedData);
          //  }

          update();
          break;
        case 401:
          Get.offAndToNamed("/login");
          //DialogHelper.showErroDialog(description: "Token not valid");
          break;
        case 1:
          break;
        default:
          break;
      }
    });
  }

  ///for body mapping
  ui.Image? bodyImage;
  List<SymptomsModal> symptomsList = [];
  Future<void> loadImage() async {
    final imageData = await rootBundle.load("assets/images/fullBody.png");
    final codec =
        await ui.instantiateImageCodec(imageData.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    bodyImage = frame.image;
    successPrint("Image Loaded successfully");
    update();
  }

  void updateSymptomsFromJson(String jsonPayLoad) {
    List<SymptomsModal> newSymptoms = [];
    final List<dynamic> decodedPayLoad = json.decode(jsonPayLoad);

    for (var symptomData in decodedPayLoad) {
      String bodyPart = symptomData['body_part']?.toLowerCase() ?? '';
      String severityStr = symptomData['severity']?.toLowerCase() ?? 'moderate';

      String description = symptomData['description'] ?? 'No description.';

      if (bodyPartCoordinates.containsKey(bodyPart)) {
        PainSeverity painSeverity;
        switch (severityStr) {
          case "mild":
            painSeverity = PainSeverity.mild;
            break;
          case "high":
          case 'severe':
            painSeverity = PainSeverity.high;
            break;
          default:
            painSeverity = PainSeverity.moderate;
        }
        final Offset position = bodyPartCoordinates[bodyPart]!;

        newSymptoms.add(SymptomsModal(
            relativePosition: position,
            painSeverity: painSeverity,
            description: description));
      }
    }

    symptomsList = newSymptoms;
    successPrint("Symptoms list updated with ${symptomsList.length} items.");
    update();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
