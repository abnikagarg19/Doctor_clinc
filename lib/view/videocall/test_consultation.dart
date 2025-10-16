// import 'dart:async';
// import 'dart:typed_data';
//
// import 'package:chatbot/controller/DoctorController.dart';
// import 'package:chatbot/utils/custom_print.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:vad/vad.dart';
//
// import '../../theme/apptheme.dart';
// import '../../utils/constant.dart';
//
// class OfflineConsultation extends StatefulWidget {
//   const OfflineConsultation({super.key});
//
//   @override
//   State<OfflineConsultation> createState() => _OfflineConsultationState();
// }
//
// class _OfflineConsultationState extends State<OfflineConsultation>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//   bool _isAiSpeaking = true;
//
//   final _vadHandler = VadHandler.create(isDebug: true);
//
//   // bool isListening = false;
//   final List<String> receivedEvents = [];
//   int selectTabs = 0;
//   List tabsLIst = [
//     "Summary",
//     "Timeline",
//     "Concerns",
//     "Lab Results",
//     "Medications"
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//         vsync: this, duration: Duration(milliseconds: 1500));
//
//     _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
//         CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
//
//     // startAnimation();
//
//     // final ws = OfflineService(
//     //   url: "wss://api.carepal.in/api/v1/voice_agent/ws",
//     //   token: PreferenceUtils.getUserToken(),
//     // );
//
// // pick file with <input type="file"> in Flutter web
//     // FileUploadInputElement upload = FileUploadInputElement();
//     // upload.accept = ".wav";
//     // upload.click();
//
//     // upload.onChange.listen((event) async {
//     //   final file = upload.files!.first;
//     //   await ws.sendAudio(file);
//     // });
//
// // listen to responses
//     // ws.messageStream.listen((msg) {
//     //   print("📥 Stream message: $msg");
//     // });
//     //  _setupVadHandler();
//   }
//
//   void startAnimation() {
//     setState(() {
//       _isAiSpeaking = true;
//     });
//     _animationController.repeat(reverse: true);
//   }
//
//   void stopAiAnimation() {
//     setState(() {
//       _isAiSpeaking = false;
//     });
//     _animationController.stop();
//     _animationController.reset();
//   }
//
//   List chatList = [];
//
//   /// Convert samples → WAV bytes
//   Future<Uint8List> saveSamplesAsWavBytes(
//     List<double> samples, {
//     int sampleRate = 16000,
//     int channels = 1,
//   }) async {
//     // Step 1: Convert Float [-1..1] → PCM16
//     final pcmBuffer = Int16List(samples.length);
//     for (int i = 0; i < samples.length; i++) {
//       final v = samples[i].clamp(-1.0, 1.0);
//       pcmBuffer[i] = (v * 32767).toInt();
//     }
//     final pcmBytes = pcmBuffer.buffer.asUint8List();
//
//     // Step 2: WAV header
//     final header = _buildWavHeader(
//       pcmBytes.length,
//       sampleRate,
//       channels,
//       16,
//     );
//
//     // Step 3: Combine
//     final wavBytes = BytesBuilder();
//     wavBytes.add(header);
//     wavBytes.add(pcmBytes);
//
//     return wavBytes.toBytes();
//   }
//
//   Uint8List _buildWavHeader(
//     int dataLength,
//     int sampleRate,
//     int channels,
//     int bitsPerSample,
//   ) {
//     final byteRate = sampleRate * channels * (bitsPerSample ~/ 8);
//     final blockAlign = channels * (bitsPerSample ~/ 8);
//     final chunkSize = 36 + dataLength;
//
//     final buffer = ByteData(44);
//     buffer.setUint32(0, 0x52494646, Endian.big); // "RIFF"
//     buffer.setUint32(4, chunkSize, Endian.little);
//     buffer.setUint32(8, 0x57415645, Endian.big); // "WAVE"
//     buffer.setUint32(12, 0x666d7420, Endian.big); // "fmt "
//     buffer.setUint32(16, 16, Endian.little); // Subchunk1Size (16 for PCM)
//     buffer.setUint16(20, 1, Endian.little); // AudioFormat (1=PCM)
//     buffer.setUint16(22, channels, Endian.little);
//     buffer.setUint32(24, sampleRate, Endian.little);
//     buffer.setUint32(28, byteRate, Endian.little);
//     buffer.setUint16(32, blockAlign, Endian.little);
//     buffer.setUint16(34, bitsPerSample, Endian.little);
//     buffer.setUint32(36, 0x64617461, Endian.big); // "data"
//     buffer.setUint32(40, dataLength, Endian.little);
//
//     return buffer.buffer.asUint8List();
//   }
//
//   String speakText = "Welcome!👋\n\nReady for a quick health check?";
//
//   Future<void> _setupVadHandler() async {
//     final controller = Doctorcontroller();
//     var status = await Permission.microphone.request();
//
//     if (status.isDenied || status.isPermanentlyDenied) {
//       warningPrint("Microphone permission denied by user or system.");
//       return;
//     }
//     _vadHandler.onSpeechStart.listen((_) {
//       alertPrint('Speech detected.');
//       setState(() => receivedEvents.add('Speech detected.'));
//     });
//
//     _vadHandler.onRealSpeechStart.listen((_) {
//       alertPrint('Real speech start detected (not a misfire).');
//       setState(() => receivedEvents.add('Real speech start detected.'));
//     });
//     _vadHandler.onVADMisfire.listen((_) {
//       alertPrint(
//           'onVADMisfire onVADMisfire onVADMisfire detected (not a misfire).');
//       setState(
//           () => receivedEvents.add('Real onVADMisfire onVADMisfire detected.'));
//     });
//
//     /// New
//     _vadHandler.onSpeechEnd.listen((List<double> samples) async {
//       alertPrint("Speech ended, processing transcription...");
//       warningPrint(
//           'Speech ended, first 10 samples: ${samples.take(10).toList()}');
//       setState(() {
//         receivedEvents.add(
//           'Speech ended, first 10 samples: ${samples.take(10).toList()}',
//         );
//       });
//
//       // ✅ Always get wavBytes
//       final wavBytes = await saveSamplesAsWavBytes(samples);
//
//       alertPrint("WAV ready in memory (${wavBytes.lengthInBytes} bytes)");
//       final transcribedText = await sendToSpeechToTextApi(wavBytes);
//       // ✅ Send to Sarvam AI
//       // await sendToSarvam(wavBytes);
//       if (transcribedText != null && transcribedText.isNotEmpty) {
//         setState(() {
//           controller.chatMessage.add({
//             "sender": controller.activeSpeaker,
//             "text": transcribedText,
//           });
//         });
//       }
//     });
//
//     _vadHandler.onFrameProcessed.listen((frameData) {
//       // debugPrint(
//       //   'Frame processed - Speech prob: ${frameData.isSpeech}, Not speech: ${frameData.notSpeech}',
//       // );
//     });
//
//     _vadHandler.onVADMisfire.listen((_) {
//       alertPrint('VAD misfire detected.');
//       setState(() => receivedEvents.add('VAD misfire detected.'));
//     });
//
//     _vadHandler.onError.listen((String message) {
//       alertPrint('Error: $message');
//       setState(() => receivedEvents.add('Error: $message'));
//     });
//     await _vadHandler.startListening(
//       submitUserSpeechOnPause: true,
//     );
//     // sendToChatApi("");
//   }
//
//   /// Dummy mock api
//   Future<String> sendToSpeechToTextApi(Uint8List wavBytes) async {
//     await Future.delayed(Duration(seconds: 2));
//     return "This is a sample transcribed text.";
//   }
//
//   @override
//   void dispose() {
//     _vadHandler.dispose();
//     super.dispose();
//   }
//
//   // 4️⃣ Extract tests_ordered as a list
//   final List tests = [];
//   // 3️⃣ Extract medicines_prescribed as a list of names
//   final List medicines = [];
//   final TextEditingController _searchController = TextEditingController();
//   final List<String> messages = [];
//   String patientSummary = "";
//   String doctor_suggestions = "";
//   String lifestyle_recommendations = "";
//   String advicePlan = "";
//   String doctorImpression = "";
//   String doctor_impression_and_diagnosis = "";
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put<Doctorcontroller>(Doctorcontroller());
//     return Expanded(
//       child: Column(
//         children: [
//           SizedBox(
//             height: 10,
//           ),
//
//           /// Top Section
//           Expanded(
//             flex: 2,
//             child: Row(
//               children: [
//                 /// AI Chat
//                 Expanded(
//                   flex: 3,
//                   child: Container(
//                     height: double.infinity,
//                     decoration: BoxDecoration(
//                       color: AppTheme.whiteTextColor,
//                       borderRadius: BorderRadius.circular(22),
//                       border: Border.all(
//                         color: const Color.fromRGBO(213, 213, 213, 1),
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: ListView.builder(
//                             itemCount: 1,
//                             padding: EdgeInsets.zero,
//                             physics: const BouncingScrollPhysics(),
//                             itemBuilder: (BuildContext context, int index) {
//                               return Container(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 20),
//                                 width: double.infinity,
//                                 child: Column(
//                                   children: [
//                                     const SizedBox(
//                                       height: 20,
//                                     ),
//                                     Container(
//                                       width: double.infinity,
//                                       margin: const EdgeInsets.only(
//                                         right: 0,
//                                       ),
//                                       child: IntrinsicHeight(
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.end,
//                                           children: [
//                                             Flexible(
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.end,
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.end,
//                                                 children: [
//                                                   Container(
//                                                     margin:
//                                                         const EdgeInsets.only(
//                                                       right: 6,
//                                                       top: 6,
//                                                       bottom: 6,
//                                                     ),
//                                                     child: Text(
//                                                       "Hi",
//                                                       style:
//                                                           GoogleFonts.quicksand(
//                                                         color: const Color
//                                                             .fromRGBO(
//                                                             0, 0, 0, 1),
//                                                         fontSize: 14,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                         height: 1.6,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             const VerticalDivider(
//                                               color: Color.fromRGBO(
//                                                   66, 217, 129, 1),
//                                               width: 20,
//                                               thickness: 4,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 20),
//                                     Align(
//                                       alignment: Alignment.topLeft,
//                                       child: IntrinsicHeight(
//                                         child: Row(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           children: [
//                                             VerticalDivider(
//                                               color: AppTheme.lightPrimaryColor,
//                                               width: 20,
//                                               thickness: 4,
//                                             ),
//                                             Flexible(
//                                               child: Container(
//                                                 alignment: Alignment.centerLeft,
//                                                 child: Container(
//                                                   margin: const EdgeInsets.only(
//                                                     left: 8,
//                                                     top: 2,
//                                                     bottom: 2,
//                                                   ),
//                                                   child: Text(
//                                                     "Hello",
//                                                     style:
//                                                         GoogleFonts.quicksand(
//                                                       color:
//                                                           const Color.fromRGBO(
//                                                               0, 0, 0, 1),
//                                                       fontSize: 14,
//                                                       fontWeight:
//                                                           FontWeight.w500,
//                                                       height: 1.6,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 20),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//
//                 /// Ai Speaking
//                 Expanded(
//                   flex: 3,
//                   child: Container(
//                     height: double.infinity,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(22),
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 12),
//                     child: SingleChildScrollView(
//                       child: Column(children: [
//                         SizedBox(
//                           height: 40,
//                         ),
//                         GestureDetector(
//                           onTap: () async {
//                             setState(() {
//                               _isAiSpeaking = !_isAiSpeaking;
//                             });
//
//                             if (_isAiSpeaking) {
//                               startAnimation();
//
//                               // Start real-time speech-to-text
//                               await controller.startListening((text) {
//                                 setState(() {
//                                   if (controller.chatMessage.isNotEmpty &&
//                                       controller.chatMessage.last['sender'] ==
//                                           controller.activeSpeaker) {
//                                     // Update last message if the speaker is same
//                                     controller.chatMessage[
//                                             controller.chatMessage.length - 1]
//                                         ['text'] = text;
//                                   } else {
//                                     // Add new message if last speaker is different
//                                     controller.chatMessage.add({
//                                       "sender": controller.activeSpeaker,
//                                       "text": text,
//                                     });
//                                   }
//                                 });
//                               });
//                             } else {
//                               stopAiAnimation();
//                               controller.stopListening();
//                             }
//                           },
//                           // onTap: () async {
//                           //                             setState(() {
//                           //                               _isAiSpeaking = !_isAiSpeaking;
//                           //                             });
//                           //                             if (_isAiSpeaking) {
//                           //                               startAnimation();
//                           //
//                           //                               await _setupVadHandler();
//                           //                             } else {
//                           //                               stopAiAnimation();
//                           //                               _vadHandler.stopListening();
//                           //                             }
//                           //                           },
//                           child: ScaleTransition(
//                             scale: _scaleAnimation,
//                             child: Container(
//                               width: 70,
//                               height: 70,
//                               decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 gradient: RadialGradient(
//                                   colors: [
//                                     Color(0xFF90F2FF),
//                                     Color(0xFF37C3FF),
//                                   ],
//                                   radius: 0.3,
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Color.fromARGB(90, 117, 218, 255),
//                                     blurRadius: 10,
//                                     spreadRadius: 5,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//
//                         Container(
//                           height: 60,
//                           width: 200,
//                           padding: const EdgeInsets.all(16.0),
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(15),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.2),
//                                 spreadRadius: 3,
//                                 blurRadius: 15,
//                                 offset: const Offset(0, 5),
//                               ),
//                             ],
//                           ),
//                           child: const Text(
//                             "Patient us feeling xxx",
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//
//                         /// chat transcribe
//                         Container(
//                           height: 300, // adjust as needed
//                           width: double.infinity,
//                           padding: EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[50],
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Obx(() => ListView.builder(
//                                 itemCount: controller.chatMessage.length,
//                                 itemBuilder: (context, index) {
//                                   final msg = controller.chatMessage[index];
//                                   final isDoctor = msg["sender"] == "doctor";
//                                   return Align(
//                                     alignment: isDoctor
//                                         ? Alignment.centerRight
//                                         : Alignment.centerLeft,
//                                     child: Container(
//                                       margin: EdgeInsets.symmetric(
//                                           vertical: 6, horizontal: 8),
//                                       padding: EdgeInsets.all(12),
//                                       decoration: BoxDecoration(
//                                         color: isDoctor
//                                             ? Colors.blue[100]
//                                             : Colors.green[100],
//                                         borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(12),
//                                           topRight: Radius.circular(12),
//                                           bottomLeft: isDoctor
//                                               ? Radius.circular(12)
//                                               : Radius.circular(0),
//                                           bottomRight: isDoctor
//                                               ? Radius.circular(0)
//                                               : Radius.circular(12),
//                                         ),
//                                       ),
//                                       child: Text(msg["text"]),
//                                     ),
//                                   );
//                                 },
//                               )),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         // Row(
//                         //   mainAxisAlignment: MainAxisAlignment.center,
//                         //   children: [
//                         //     ElevatedButton.icon(
//                         //       onPressed: () async {
//                         //         await controller
//                         //             .downloadChatPdfWeb(controller.chatMessage);
//                         //         ScaffoldMessenger.of(context).showSnackBar(
//                         //           const SnackBar(
//                         //               content: Text(
//                         //                   "Chat PDF downloaded successfully!")),
//                         //         );
//                         //       },
//                         //       icon: const Icon(Icons.download),
//                         //       label: const Text("Download"),
//                         //     ),
//                         //   ],
//                         // ),
//                       ]),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//
//                 /// Patient Details
//                 Expanded(
//                   flex: 3,
//                   child: Container(
//                     height: double.infinity,
//                     decoration: BoxDecoration(
//                       color: AppTheme.whiteTextColor,
//                       borderRadius: BorderRadius.circular(22),
//                       border: Border.all(
//                         color: const Color.fromRGBO(213, 213, 213, 1),
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: List.generate(
//                             tabsLIst.length,
//                             (index) {
//                               return Expanded(
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       selectTabs = index;
//                                     });
//                                   },
//                                   child: Container(
//                                     padding: EdgeInsets.symmetric(vertical: 8),
//                                     decoration: BoxDecoration(
//                                         color: selectTabs == index
//                                             ? Color.fromRGBO(60, 150, 255, 1)
//                                             : AppTheme.whiteTextColor,
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: const Color.fromARGB(
//                                                 132, 149, 147, 147),
//                                             spreadRadius: 1,
//                                             offset: const Offset(0, 6),
//                                             blurRadius: 10,
//                                           )
//                                         ],
//                                         borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(12),
//                                           topRight: Radius.circular(12),
//                                         )),
//                                     child: Center(
//                                       child: Text("${tabsLIst[index]}",
//                                           style: GoogleFonts.rubik(
//                                               color: selectTabs == index
//                                                   ? Color.fromRGBO(
//                                                       255, 255, 255, 1)
//                                                   : Color.fromRGBO(
//                                                       142, 142, 142, 1),
//                                               fontSize: Constant.verysmallbody(
//                                                   context),
//                                               fontWeight: FontWeight.w500)),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         SizedBox(
//                           height: 1,
//                         ),
//                         Expanded(
//                           child: Container(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 30),
//                               decoration: BoxDecoration(
//                                 color: const Color.fromRGBO(255, 255, 255, 1),
//                               ),
//                               child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       children: [
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             children: [
//                                               Text("Patient:",
//                                                   style: GoogleFonts.rubik(
//                                                       color:
//                                                           AppTheme.blackColor,
//                                                       fontSize:
//                                                           Constant.twetysixtext(
//                                                               context),
//                                                       fontWeight:
//                                                           FontWeight.w700)),
//                                               SizedBox(
//                                                 height: 20,
//                                               ),
//                                               Text(patientSummary,
//                                                   style: GoogleFonts.quicksand(
//                                                       color:
//                                                           AppTheme.blackColor,
//                                                       fontSize: 12,
//                                                       fontWeight:
//                                                           FontWeight.w500)),
//                                               SizedBox(
//                                                 height: 20,
//                                               ),
//                                               SizedBox(
//                                                 height: 20,
//                                               ),
//                                               Text("Description:",
//                                                   style: GoogleFonts.rubik(
//                                                       color:
//                                                           AppTheme.blackColor,
//                                                       fontSize:
//                                                           Constant.smallbody(
//                                                               context),
//                                                       fontWeight:
//                                                           FontWeight.w700)),
//                                               SizedBox(
//                                                 height: 10,
//                                               ),
//                                               Text(lifestyle_recommendations,
//                                                   style: GoogleFonts.quicksand(
//                                                       color:
//                                                           AppTheme.blackColor,
//                                                       fontSize: 12,
//                                                       fontWeight:
//                                                           FontWeight.w500)),
//                                             ],
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 80,
//                                         ),
//                                         Image.asset(
//                                             "assets/images/full_body.png")
//                                       ],
//                                     ),
//                                   ])),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//
//           /// Bottom Section
//           Expanded(
//             flex: 1,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Row(
//                     children: [
//                       /// Search
//                       Expanded(
//                         flex: 2,
//                         child: Container(
//                           height: double.infinity,
//                           decoration: BoxDecoration(
//                             color: AppTheme.whiteTextColor,
//                             borderRadius: BorderRadius.circular(22),
//                             border: Border.all(
//                               color: const Color.fromRGBO(213, 213, 213, 1),
//                             ),
//                           ),
//                           child: Column(
//                             spacing: 10,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: TextField(
//                                   controller: _searchController,
//                                   style: GoogleFonts.rubik(
//                                     color: const Color.fromRGBO(0, 0, 0, 1),
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                   onChanged: (value) {
//                                     print('Searching for: $value');
//                                   },
//                                   decoration: InputDecoration(
//                                     hintText: "Search...", // Placeholder text
//                                     hintStyle: GoogleFonts.rubik(
//                                       // Style for the placeholder text
//                                       color: Colors.grey.shade500,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                     prefixIcon: Icon(
//                                       // Search icon on the left
//                                       Icons.search,
//                                       color: Colors.grey.shade600,
//                                     ),
//                                     // Styling the border
//                                     contentPadding: const EdgeInsets.symmetric(
//                                         vertical: 10.0, horizontal: 15.0),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: BorderSide(
//                                           color: Colors.grey.shade300,
//                                           width: 1.5),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: BorderSide(
//                                           color: Colors.grey.shade300,
//                                           width: 1.5),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: BorderSide(
//                                           color: AppTheme.lightPrimaryColor,
//                                           width: 2.0),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: SingleChildScrollView(
//                                   child: Column(
//                                     children: List.generate(
//                                       medicines.length,
//                                       (index) {
//                                         return Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Container(
//                                             width: double.infinity,
//                                             decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(12),
//                                                 border: Border.all(
//                                                     color: Colors.black12)),
//                                             padding: const EdgeInsets.all(12.0),
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                     "${medicines[index]["name"]}",
//                                                     style: GoogleFonts.rubik(
//                                                         color: Color.fromRGBO(
//                                                             0, 0, 0, 1),
//                                                         fontSize: 14,
//                                                         fontWeight:
//                                                             FontWeight.w400)),
//                                                 Row(
//                                                   children: [
//                                                     Text(
//                                                         "${medicines[index]["dosage"]} - ",
//                                                         style:
//                                                             GoogleFonts.rubik(
//                                                                 color: Color
//                                                                     .fromRGBO(
//                                                                         72,
//                                                                         72,
//                                                                         72,
//                                                                         1),
//                                                                 fontSize: 14,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w400)),
//                                                     Text(
//                                                         "${medicines[index]["frequency"]}",
//                                                         style:
//                                                             GoogleFonts.rubik(
//                                                                 color: Color
//                                                                     .fromRGBO(
//                                                                         72,
//                                                                         72,
//                                                                         72,
//                                                                         1),
//                                                                 fontSize: 14,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w400)),
//                                                   ],
//                                                 ),
//                                                 Text(
//                                                     "${medicines[index]["side_effects"]}",
//                                                     style: GoogleFonts.rubik(
//                                                         color: Color.fromRGBO(
//                                                             72, 72, 72, 1),
//                                                         fontSize: 14,
//                                                         fontWeight:
//                                                             FontWeight.w400)),
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//
//                       /// Details
//                       Expanded(
//                         flex: 2,
//                         child: Container(
//                           height: double.infinity,
//                           decoration: BoxDecoration(
//                             color: AppTheme.whiteTextColor,
//                             borderRadius: BorderRadius.circular(22),
//                             border: Border.all(
//                               color: const Color.fromRGBO(213, 213, 213, 1),
//                             ),
//                           ),
//                           child: Column(
//                             spacing: 10,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: TextField(
//                                   controller: _searchController,
//                                   style: GoogleFonts.rubik(
//                                     color: const Color.fromRGBO(0, 0, 0, 1),
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                   onChanged: (value) {
//                                     print('Searching for: $value');
//                                   },
//                                   decoration: InputDecoration(
//                                     hintText: "Search...", // Placeholder text
//                                     hintStyle: GoogleFonts.rubik(
//                                       // Style for the placeholder text
//                                       color: Colors.grey.shade500,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                     prefixIcon: Icon(
//                                       // Search icon on the left
//                                       Icons.search,
//                                       color: Colors.grey.shade600,
//                                     ),
//                                     // Styling the border
//                                     contentPadding: const EdgeInsets.symmetric(
//                                         vertical: 10.0, horizontal: 15.0),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: BorderSide(
//                                           color: Colors.grey.shade300,
//                                           width: 1.5),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: BorderSide(
//                                           color: Colors.grey.shade300,
//                                           width: 1.5),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: BorderSide(
//                                           color: AppTheme.lightPrimaryColor,
//                                           width: 2.0),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: SingleChildScrollView(
//                                   child: Column(
//                                     children: List.generate(
//                                       medicines.length,
//                                       (index) {
//                                         return Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Container(
//                                             width: double.infinity,
//                                             decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(12),
//                                                 border: Border.all(
//                                                     color: Colors.black12)),
//                                             padding: const EdgeInsets.all(12.0),
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                     "${medicines[index]["name"]}",
//                                                     style: GoogleFonts.rubik(
//                                                         color: Color.fromRGBO(
//                                                             0, 0, 0, 1),
//                                                         fontSize: 14,
//                                                         fontWeight:
//                                                             FontWeight.w400)),
//                                                 Row(
//                                                   children: [
//                                                     Text(
//                                                         "${medicines[index]["dosage"]} - ",
//                                                         style:
//                                                             GoogleFonts.rubik(
//                                                                 color: Color
//                                                                     .fromRGBO(
//                                                                         72,
//                                                                         72,
//                                                                         72,
//                                                                         1),
//                                                                 fontSize: 14,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w400)),
//                                                     Text(
//                                                         "${medicines[index]["frequency"]}",
//                                                         style:
//                                                             GoogleFonts.rubik(
//                                                                 color: Color
//                                                                     .fromRGBO(
//                                                                         72,
//                                                                         72,
//                                                                         72,
//                                                                         1),
//                                                                 fontSize: 14,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w400)),
//                                                   ],
//                                                 ),
//                                                 Text(
//                                                     "${medicines[index]["side_effects"]}",
//                                                     style: GoogleFonts.rubik(
//                                                         color: Color.fromRGBO(
//                                                             72, 72, 72, 1),
//                                                         fontSize: 14,
//                                                         fontWeight:
//                                                             FontWeight.w400)),
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//
//                       /// Vitals
//                       Expanded(
//                         flex: 2,
//                         child: Column(
//                           children: [
//                             /// Vitals
//                             Expanded(
//                               flex: 2,
//                               child: Container(
//                                 height: double.infinity,
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(22),
//                                 ),
//                                 padding: EdgeInsets.symmetric(horizontal: 12),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Text(
//                                         "Vitals",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 10,
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               children: [
//                                                 Text("Temp : "),
//                                                 Text("${100} F")
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               height: 5,
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               children: [
//                                                 Text("SpO2 : "),
//                                                 Text("${98} %")
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               height: 5,
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               children: [
//                                                 Text("Resp Rate : "),
//                                                 Text("${16}/min")
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                         SizedBox(
//                                           width: 10,
//                                         ),
//                                         Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               children: [
//                                                 Text("Temp : "),
//                                                 Text("100")
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               height: 5,
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               children: [
//                                                 Text("Temp"),
//                                                 Text("100")
//                                               ],
//                                             ),
//                                           ],
//                                         )
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//
//                             /// Doctor impression and diagnosis
//                             Expanded(
//                               flex: 2,
//                               child: Container(
//                                 height: double.infinity,
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(22),
//                                 ),
//                                 padding: EdgeInsets.symmetric(horizontal: 12),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Text(
//                                         "Doctor Impression and diagnosis",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 10,
//                                     ),
//                                     Text(
//                                         'This is the doctor impression and diagnosis text.')
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//
//                       /// Examination
//                       Expanded(
//                         flex: 2,
//                         child: Column(
//                           children: [
//                             Expanded(
//                               flex: 2,
//                               child: Container(
//                                   height: double.infinity,
//                                   width: double.infinity,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(22),
//                                   ),
//                                   padding: EdgeInsets.symmetric(horizontal: 12),
//                                   child: SingleChildScrollView(
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Text(
//                                             "Examination",
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 10,
//                                         ),
//                                         Text(
//                                             'Respiratory: This is the examination text.'),
//                                         SizedBox(
//                                           height: 5,
//                                         ),
//                                         Text(
//                                             'PNS Exam: This is the examination text.'),
//                                       ],
//                                     ),
//                                   )),
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//
//                             ///Advice and plan
//                             Expanded(
//                               flex: 2,
//                               child: Container(
//                                 height: double.infinity,
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(22),
//                                 ),
//                                 padding: EdgeInsets.symmetric(horizontal: 12),
//                                 child: SingleChildScrollView(
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "Advice and plan",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       SizedBox(
//                                         height: 10,
//                                       ),
//                                       Text(
//                                           'Use Controller Inhaler, dont skip even if well'),
//                                       SizedBox(
//                                         height: 5,
//                                       ),
//                                       Text(
//                                           'Carry rescue inhaler, check canister regularly'),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//         ],
//       ),
//     );
//   }
// }
