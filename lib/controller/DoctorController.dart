import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:chatbot/service/home_repo.dart';
import 'package:chatbot/utils/custom_print.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/patient_modal.dart';
import '../view/videocall/components/symptoms_modal.dart';
import '../view/videocall/components/trained_mock_positions.dart';

class Doctorcontroller extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getMeeting();
    loadImage();
    updateSymptomsFromJson(mockSymptomJsonPayload);
    applyFilter();
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
  List appointmentListMock = [
    {
      "meeting": [
        {
          "meeting_id_front": "MTG001",
          "patient_name": "John Smith",
          "from_time": "10:30 AM",
          "description": "Weekly visit",
          "status": "confirmed",
          "is_online": true
        },
        {
          "meeting_id_front": "MTG002",
          "patient_name": "Sarah Johnson",
          "from_time": "11:45 AM",
          "description": "Follow-up consultation",
          "status": "confirmed",
          "is_online": false
        },
        {
          "meeting_id_front": "MTG003",
          "patient_name": "Michael Brown",
          "from_time": "02:15 PM",
          "description": "Initial diagnosis",
          "status": "completed",
          "is_online": true
        },
        {
          "meeting_id_front": "MTG004",
          "patient_name": "Emily Davis",
          "from_time": "03:30 PM",
          "description": "Routine checkup",
          "status": "confirmed",
          "is_online": true
        },
        {
          "meeting_id_front": "MTG005",
          "patient_name": "Robert Wilson",
          "from_time": "04:45 PM",
          "description": "Therapy session",
          "status": "cancelled",
          "is_online": false
        }
      ]
    }
  ];
  bool isLoaded = true;
  final appointmentLoading = false.obs;
  List<Map<String, dynamic>> filteredAppointments = [];
  final List<String> filterOptions = ['All', 'Follow up', 'New Patient'];
  String selectedFilter = 'All';

  ///filter the appointment

  void applyFilter() {
    appointmentLoading.value = false;
    if (appointmentListMock.isEmpty ||
        appointmentListMock[0]['meeting'] == null) {
      filteredAppointments = [];
      update();
      return;
    }

    final allAppointments = appointmentListMock[0]['meeting'] as List;

    if (selectedFilter == 'All') {
      filteredAppointments = List<Map<String, dynamic>>.from(allAppointments);
      appointmentLoading.value = true;
    } else {
      filteredAppointments = allAppointments
          .where((appointment) {
            // We'll filter by the 'tag' in your data to match the dropdown options
            final String tag = appointment['tag']?.toString() ?? '';
            return tag == selectedFilter;
          })
          .map((item) => item as Map<String, dynamic>)
          .toList();
    }
    appointmentLoading.value = true;
    update();
  }

  void changeFilter(String? newFilter) {
    if (newFilter != null) {
      selectedFilter = newFilter;
      applyFilter();
    }
  }

  /// Patient list on dashboard
  final List<PatientGridItem> patientGridData = [
    PatientGridItem(
        name: "John Doe",
        symptom: "Fever, Cough",
        messageCount: 3,
        progressLevel: 'critical',
        condition: ''),
    PatientGridItem(
        name: "Jane Smith",
        symptom: "Headache",
        messageCount: 0,
        progressLevel: 'improving',
        condition: ''),
    PatientGridItem(
        name: "Snow Smith",
        symptom: "last visit",
        messageCount: 1,
        progressLevel: 'moderate',
        condition: 'condition'),
  ];

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
