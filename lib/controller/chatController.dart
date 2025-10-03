import 'dart:convert';

import 'package:chatbot/service/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../service/chat_service.dart';
import '../view/chat/service/chat_service.dart' show ChatWebSocketService;

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();

  var messages = [].obs; // chat messages list
  var patients = [].obs; // list of patients
  var isLoading = false.obs;
  var isLoadingChatHistory = false.obs;
  var errorMessage = ''.obs;
  final scrollController = ScrollController();
  late ChatWebSocketService _ws;
  final chatcontroller = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    // Whenever messages list updates → scroll to bottom

    initWebsocket();

    /// Scroll whenever messages change
    ever(messages, (_) {
      _scrollToBottom();
    });
  }

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

  @override
  void onClose() {
    _ws.close();
    super.onClose();
  }

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
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _chatService.apiGetPatient();
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        patients.value = decoded ?? [];
        print(decoded);
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
      print(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }
}
