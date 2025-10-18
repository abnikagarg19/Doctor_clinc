import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';
import 'dart:typed_data';

import 'package:chatbot/utils/custom_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:vad/vad.dart';

import '../service/chat_service.dart';
import '../service/shared_pref.dart';
import '../service/voice_agent.dart';
import '../utils/app_urls.dart';
import '../view/chat/service/chat_service.dart' show ChatWebSocketService;

class ChatController extends GetxController
    with GetSingleTickerProviderStateMixin {
  @override
  void onInit() {
    super.onInit();
    initWebsocket();

    /// Scroll whenever messages change
    ever(chatMessage, (_) {
      // Listen to the correct list
      _scrollToBottom();
    });
    slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 2), // Start off-screen (bottom)
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: slideController, curve: Curves.easeOut));
  }

  var isVoiceAgentVisible = false.obs;
  var isVoiceAgentMinimized = true.obs;
  var voiceAgentTranscript = ''.obs;

  // Animation controller for smooth transitions
  late AnimationController slideController;
  late Animation<Offset> slideAnimation;

  final ChatService _chatService = ChatService();

  var messages = [].obs; // chat messages list
  var patients = [].obs; // list of patients
  var isLoading = false.obs;
  var isLoadingChatHistory = false.obs;
  var errorMessage = ''.obs;
  final scrollController = ScrollController();
  ChatWebSocketService? _ws;
  final chatcontroller = TextEditingController();
  var isChatPopupVisible = false.obs;
  var isChatPopupMinimized = false.obs;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  initWebsocket() {
    // connect with token
    // _ws = ChatWebSocketService(
    //   url: "ws://api.carepal.in:8000/api/v1/doctor_chat/ws",
    //   token: PreferenceUtils.getUserToken(),
    // );

    // _ws.messageStream.listen((msg) {
    //   // Assuming msg is already a Map
    //   final formattedMessage = {
    //     "message_content": msg['message'],
    //     "id": DateTime.now().millisecondsSinceEpoch, // generate unique id
    //     "sender_id": msg['from'],
    //     "sent_at": DateTime.now().toUtc().toIso8601String(),
    //     "sender_type": "patient", // or determinRRe based on sender_id
    //     "recipient_id": msg['to'],
    //   };
    //   messages.add(formattedMessage);
    // });
  }

  // void sendInitMessage(String from, String to, String message) {
  //   _ws.sendMessage(from, to, message);

  //   // optimistic UI update
  //   messages.add({
  //     "from_": from,
  //     "to": to,
  //     "message": message,
  //     "timestamp": DateTime.now().toIso8601String(),
  //   });
  // }

  RxBool sendButton = false.obs;
  void changeStatus(value) {
    // if(!mounted)
    Future.delayed(Duration.zero, () async {
      if (value == "") {
        sendButton.value = false;
      } else {
        sendButton.value = true;
      }
      update();
    });
  }

  /// Fetch chat history with a patient
  Future<void> loadChatHistory(String patientId, isloaded2) async {
    if (isloaded2) {
      isLoadingChatHistory.value = true;
    }
    errorMessage.value = '';
    try {
      final response = await _chatService.apiChatHistory(patientId);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        _scrollToBottom();
        print(decoded);
        messages.value = decoded;
      } else {
        errorMessage.value =
            "Failed to load chat history: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
      print(errorMessage);
    } finally {
      isLoadingChatHistory.value = false;
    }
  }

  selectChat(patient) async {
    selectedPatient.value = patient;
    final patientId = selectedPatient.value!["user_id"].toString();
    await loadChatHistory(patientId, true);
  }

  /// Send a message to a patient
  Future<void> sendMessage() async {
    try {
      final response = await _chatService.apiSendMessage(
          selectedPatient.value!["user_id"], chatcontroller.text);
      if (response.statusCode == 200) {
        chatcontroller.clear();
        sendButton.value = false;
        final decoded = jsonDecode(response.body);
        // Add message to local list (optimistic update)
        // messages.add({
        //   "sender_id": userId,
        //   "message_content": message,
        //   "sent_at": DateTime.now().toIso8601String(),
        //   "sender_type": "doctor",
        //   "recipient_id": "22"
        // });

        await loadChatHistory(selectedPatient.value!["user_id"], false);
      } else {
        errorMessage.value = "Failed to send message";
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
    }
  }

  var selectedPatient = Rxn<Map<String, dynamic>>(); // null safe

  /// Fetch patient list
  Future<void> loadPatients() async {
    alertPrint("Loading Patient Start");
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _chatService.apiGetPatient();
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        patients.value = decoded ?? [];
        successPrint("Patient Data Loaded $decoded");
        if (patients.isNotEmpty) {
          selectedPatient.value = patients.first;
          final patientId = selectedPatient.value!["user_id"].toString();
          await loadChatHistory(patientId, true);
        }
      } else {
        errorMessage.value = "Failed to load patients: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
      errorPrint("Error $errorMessage");
    } finally {
      isLoading.value = false;
    }
  }

  ///download pdf
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
  Future<Future<Uint8List>> generateChatPdfWeb(
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

  /// Patient and doctor Audio Streaming
  final _vadHandler = VadHandler.create(isDebug: true);
  VoiceAgentService? _voiceAgentService;
  final isAiSpeaking = false.obs;

  // final stt.SpeechToText _speechToText = stt.SpeechToText();
  // late Function(String) _onResultCallback;
  // bool isCurrentBubbleActive = false;
  final chatMessage = <Map<String, dynamic>>[].obs;
  String activeSpeaker = "doctor";

  void toggleVoiceAgentMinimize() {
    isVoiceAgentMinimized.toggle();
  }

  Future<void> startVoiceSession() async {
    slideController.reverse().whenComplete(() {
      isVoiceAgentVisible.value = false;
    });
    alertPrint("Voice Session Starting...");
    chatMessage.clear();
    var status = await Permission.microphone.request();
    if (status.isDenied) {
      alertPrint("Microphone permission denied.");
      return;
    }
    var url = Uri.parse(AppUrls.audioSendingSocket);

    /// 1. Initialize and connect the Voice WebSocket
    _voiceAgentService =
        VoiceAgentService(url: "$url", token: PreferenceUtils.getUserToken());
    await _voiceAgentService!.connect();

    /// 2. Listen for text responses from the WebSocket
    _voiceAgentService!.messageStream.listen((textResponse) {
      chatMessage.add({
        "sender": "patient",
        "text": textResponse,
      });
      successPrint(
          "Listen fot text response from the websocket ${chatMessage.length}");
    }, onError: (error) {
      errorPrint("Voice agent WebSocket error: $error");
    });

    /// 3. Configure VAD to send audio when speech is detected
    _vadHandler.onSpeechEnd.listen((List<double> samples) async {
      alertPrint(
          "VAD: Speech ended, processing ${samples.length} audio samples.");
      final wavBytes = await _saveSamplesAsWavBytes(samples);
      _voiceAgentService?.sendAudio(wavBytes);
      successPrint("Sending audio when speech $_voiceAgentService");
    });

    // 4. Start listening with VAD
    alertPrint("VAD: Attempting to start microphone...");
    await _vadHandler.startListening(submitUserSpeechOnPause: true);
    successPrint("VAD: Microphone is now active and recording!");
    alertPrint("Voice session started. Listening for speech...");
  }

  void stopVoiceSession() {
    _vadHandler.stopListening();
    _voiceAgentService?.close();
    _voiceAgentService = null;
    alertPrint("Voice session stopped.");
  }

  Future<Uint8List> _saveSamplesAsWavBytes(List<double> samples,
      {int sampleRate = 16000}) async {
    final pcmBuffer = Int16List(samples.length);
    for (int i = 0; i < samples.length; i++) {
      pcmBuffer[i] = (samples[i].clamp(-1.0, 1.0) * 32767).toInt();
    }
    final pcmBytes = pcmBuffer.buffer.asUint8List();
    final header = _buildWavHeader(pcmBytes.length, sampleRate, 1, 16);
    return Uint8List.fromList([...header, ...pcmBytes]);
  }

  Uint8List _buildWavHeader(
      int dataLength, int sampleRate, int channels, int bitsPerSample) {
    final byteRate = sampleRate * channels * (bitsPerSample ~/ 8);
    final blockAlign = channels * (bitsPerSample ~/ 8);
    final chunkSize = 36 + dataLength;

    final buffer = ByteData(44);
    buffer.setUint32(0, 0x52494646, Endian.big); // "RIFF"
    buffer.setUint32(4, chunkSize, Endian.little);
    buffer.setUint32(8, 0x57415645, Endian.big); // "WAVE"
    buffer.setUint32(12, 0x666d7420, Endian.big); // "fmt "
    buffer.setUint32(16, 16, Endian.little);
    buffer.setUint16(20, 1, Endian.little);
    buffer.setUint16(22, channels, Endian.little);
    buffer.setUint32(24, sampleRate, Endian.little);
    buffer.setUint32(28, byteRate, Endian.little);
    buffer.setUint16(32, blockAlign, Endian.little);
    buffer.setUint16(34, bitsPerSample, Endian.little);
    buffer.setUint32(36, 0x64617461, Endian.big); // "data"
    buffer.setUint32(40, dataLength, Endian.little);

    return buffer.buffer.asUint8List();
  }

  @override
  void onClose() {
    stopVoiceSession();
    _ws?.close();
    scrollController.dispose();
    chatcontroller.dispose();
    slideController.dispose();
    super.onClose();
    // _speechToText.cancel(); // Us
  }
}
