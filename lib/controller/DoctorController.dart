import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';

import 'package:chatbot/service/home_repo.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Doctorcontroller extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getMeeting();
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

  Future<File> generateChatPdf(List<Map<String, dynamic>> chatMessages) async {
    final ttf = await rootBundle.load("assets/font/SWItal Regular.ttf");
    final font = pw.Font.ttf(ttf);

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Text(
                "Doctor-Patient Consultation Chat",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 16),
            ...chatMessages.map((msg) {
              final isDoctor = msg["sender"] == "doctor";
              return pw.Container(
                alignment: isDoctor
                    ? pw.Alignment.centerRight
                    : pw.Alignment.centerLeft,
                margin: const pw.EdgeInsets.symmetric(vertical: 6),
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: isDoctor ? PdfColors.blue100 : PdfColors.green100,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Text(
                  "${isDoctor ? 'Doctor:' : 'Patient:'} ${msg['text']}",
                  style: pw.TextStyle(fontSize: 12, font: font),
                ),
              );
            }),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/consultation_chat.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Generate pdf for web
  Future<Uint8List> generateChatPdfWeb(
      List<Map<String, dynamic>> chatMessages) async {
    final pdf = pw.Document();

    final ttf = await rootBundle.load("assets/font/SWItal Regular.ttf");
    final font = pw.Font.ttf(ttf);

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Center(
            child: pw.Text(
              "Doctor-Patient Consultation Chat",
              style: pw.TextStyle(
                  font: font, fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          ...chatMessages.map((msg) {
            final isDoctor = msg['sender'] == 'doctor';
            return pw.Align(
              alignment:
                  isDoctor ? pw.Alignment.centerRight : pw.Alignment.centerLeft,
              child: pw.Container(
                margin: const pw.EdgeInsets.symmetric(vertical: 6),
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: isDoctor ? PdfColors.blue100 : PdfColors.green100,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Text(
                  "${isDoctor ? 'Doctor:' : 'Patient:'} ${msg['text']}",
                  style: pw.TextStyle(font: font, fontSize: 12),
                ),
              ),
            );
          }),
        ],
      ),
    );

    return pdf.save();
  }

  Future<void> downloadChatPdfWeb(
      List<Map<String, dynamic>> chatMessages) async {
    final pdfBytes = await generateChatPdfWeb(chatMessages);
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'doctor_patient_chat.pdf')
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
