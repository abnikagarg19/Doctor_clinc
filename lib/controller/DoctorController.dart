import 'dart:async';
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
import 'package:speech_to_text/speech_to_text.dart' as stt;

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

  final stt.SpeechToText _speechToText = stt.SpeechToText();
  late Function(String) _onResultCallback;
  bool isCurrentBubbleActive = false;
  final chatMessage = <Map<String, dynamic>>[].obs;
  String activeSpeaker = "doctor";
  String _lastFinalizedText = "";
  bool _isListeningManuallyStopped = true;

  Future<void> _initializeSpeech() async {
    await _speechToText.initialize(
      onError: (error) => print('STT Init Error: $error'),
      onStatus: (status) {
        print('STT Status: $status');

        if (status == 'done' || status == 'notListening') {
          if (chatMessage.isNotEmpty && isCurrentBubbleActive) {
            _lastFinalizedText = chatMessage.map((m) => m['text']).join(' ');
          }
          isCurrentBubbleActive = false;

          // <-- SOLUTION: Add a small delay before restarting
          // This prevents the race condition that causes the InvalidStateError.
          Future.delayed(const Duration(milliseconds: 100), () {
            _startRecognitionCycle();
          });
        }
      },
    );
  }

  Future<void> startListening(Function(String) onResult) async {
    if (_speechToText.isListening) return;

    _onResultCallback = onResult;
    _isListeningManuallyStopped = false;
    _lastFinalizedText = "";
    isCurrentBubbleActive = false;
    chatMessage.clear(); // Clear previous chat on start

    if (!_speechToText.isAvailable) {
      await _initializeSpeech();
    }

    if (_speechToText.isAvailable) {
      _startRecognitionCycle();
    } else {
      print("Speech recognition not available.");
    }
  }

  void _startRecognitionCycle() {
    // Exit condition for the loop. Also, add a safety check for `isListening`.
    if (_isListeningManuallyStopped || _speechToText.isListening) {
      return;
    }

    _speechToText.listen(
      onResult: (result) {
        String fullTranscript = result.recognizedWords;
        // Logic to get only the new text for the current bubble
        String currentUtteranceText =
            fullTranscript.replaceFirst(_lastFinalizedText, '').trim();

        if (currentUtteranceText.isEmpty && !result.finalResult) return;

        if (!isCurrentBubbleActive) {
          // Only add a new bubble if there's actual new text
          if (currentUtteranceText.isNotEmpty) {
            chatMessage.add({
              "sender": activeSpeaker,
              "text": currentUtteranceText,
            });
            isCurrentBubbleActive = true;
          }
        } else {
          chatMessage.last['text'] = currentUtteranceText;
        }
        _onResultCallback(fullTranscript);
      },
      pauseFor: const Duration(seconds: 10),
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
      ),
    );
  }

  void stopListening() {
    print("Manual stop initiated.");
    _isListeningManuallyStopped = true;
    _speechToText.stop(); // Use stop() for a graceful shutdown
    isCurrentBubbleActive = false;
  }

  @override
  void onClose() {
    _isListeningManuallyStopped = true;
    _speechToText.cancel(); // Use cancel() for immediate termination in dispose
    super.onClose();
  }
}
