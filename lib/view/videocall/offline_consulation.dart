import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:chatbot/view/videocall/components/offline_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vad/vad.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../service/shared_pref.dart';
import '../../theme/apptheme.dart';
import '../../utils/constant.dart';

class OfflineConsulation extends StatefulWidget {
  const OfflineConsulation({super.key});

  @override
  State<OfflineConsulation> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<OfflineConsulation> {
  final _vadHandler = VadHandler.create(isDebug: true);
  bool isListening = false;
  final List<String> receivedEvents = [];
  int selectTabs = 0;
  List tabsLIst = [
    "Summary",
    "Timeline",
    "Concerns",
    "Lab Results",
    "Medications"
  ];
  @override
  void initState() {
    super.initState();
    // final ws = OfflineService(
    //   url: "wss://api.carepal.in/api/v1/voice_agent/ws",
    //   token: PreferenceUtils.getUserToken(),
    // );

// pick file with <input type="file"> in Flutter web
    // FileUploadInputElement upload = FileUploadInputElement();
    // upload.accept = ".wav";
    // upload.click();

    // upload.onChange.listen((event) async {
    //   final file = upload.files!.first;
    //   await ws.sendAudio(file);
    // });

// listen to responses
    // ws.messageStream.listen((msg) {
    //   print("📥 Stream message: $msg");
    // });
    _setupVadHandler();
  }

  List chatList = [];

  /// Convert samples → WAV bytes
  Future<Uint8List> saveSamplesAsWavBytes(
    List<double> samples, {
    int sampleRate = 16000,
    int channels = 1,
  }) async {
    // Step 1: Convert Float [-1..1] → PCM16
    final pcmBuffer = Int16List(samples.length);
    for (int i = 0; i < samples.length; i++) {
      final v = samples[i].clamp(-1.0, 1.0);
      pcmBuffer[i] = (v * 32767).toInt();
    }
    final pcmBytes = pcmBuffer.buffer.asUint8List();

    // Step 2: WAV header
    final header = _buildWavHeader(
      pcmBytes.length,
      sampleRate,
      channels,
      16,
    );

    // Step 3: Combine
    final wavBytes = BytesBuilder();
    wavBytes.add(header);
    wavBytes.add(pcmBytes);

    return wavBytes.toBytes();
  }

  Uint8List _buildWavHeader(
    int dataLength,
    int sampleRate,
    int channels,
    int bitsPerSample,
  ) {
    final byteRate = sampleRate * channels * (bitsPerSample ~/ 8);
    final blockAlign = channels * (bitsPerSample ~/ 8);
    final chunkSize = 36 + dataLength;

    final buffer = ByteData(44);
    buffer.setUint32(0, 0x52494646, Endian.big); // "RIFF"
    buffer.setUint32(4, chunkSize, Endian.little);
    buffer.setUint32(8, 0x57415645, Endian.big); // "WAVE"
    buffer.setUint32(12, 0x666d7420, Endian.big); // "fmt "
    buffer.setUint32(16, 16, Endian.little); // Subchunk1Size (16 for PCM)
    buffer.setUint16(20, 1, Endian.little); // AudioFormat (1=PCM)
    buffer.setUint16(22, channels, Endian.little);
    buffer.setUint32(24, sampleRate, Endian.little);
    buffer.setUint32(28, byteRate, Endian.little);
    buffer.setUint16(32, blockAlign, Endian.little);
    buffer.setUint16(34, bitsPerSample, Endian.little);
    buffer.setUint32(36, 0x64617461, Endian.big); // "data"
    buffer.setUint32(40, dataLength, Endian.little);

    return buffer.buffer.asUint8List();
  }

  String speakText = "Welcome!👋\n\nReady for a quick health check?";

  Future<void> _setupVadHandler() async {
    _vadHandler.onSpeechStart.listen((_) {
      debugPrint('Speech detected.');
      setState(() => receivedEvents.add('Speech detected.'));
    });

    _vadHandler.onRealSpeechStart.listen((_) {
      debugPrint('Real speech start detected (not a misfire).');
      setState(() => receivedEvents.add('Real speech start detected.'));
    });
    _vadHandler.onVADMisfire.listen((_) {
      debugPrint(
          'onVADMisfire onVADMisfire onVADMisfire detected (not a misfire).');
      setState(
          () => receivedEvents.add('Real onVADMisfire onVADMisfire detected.'));
    });

    _vadHandler.onSpeechEnd.listen((List<double> samples) async {
      debugPrint(
          'Speech ended, first 10 samples: ${samples.take(10).toList()}');
      setState(() {
        receivedEvents.add(
          'Speech ended, first 10 samples: ${samples.take(10).toList()}',
        );
      });

      // ✅ Always get wavBytes
      final wavBytes = await saveSamplesAsWavBytes(samples);

      debugPrint("WAV ready in memory (${wavBytes.lengthInBytes} bytes)");

      // ✅ Send to Sarvam AI
      // await sendToSarvam(wavBytes);
    });

    _vadHandler.onFrameProcessed.listen((frameData) {
      // debugPrint(
      //   'Frame processed - Speech prob: ${frameData.isSpeech}, Not speech: ${frameData.notSpeech}',
      // );
    });

    _vadHandler.onVADMisfire.listen((_) {
      debugPrint('VAD misfire detected.');
      setState(() => receivedEvents.add('VAD misfire detected.'));
    });

    _vadHandler.onError.listen((String message) {
      debugPrint('Error: $message');
      setState(() => receivedEvents.add('Error: $message'));
    });
    await _vadHandler.startListening(
      submitUserSpeechOnPause: true,
    );
    // sendToChatApi("");
  }

  @override
  void dispose() {
    _vadHandler.dispose();
    super.dispose();
  }

  // 4️⃣ Extract tests_ordered as a list
  final List tests = [];
  // 3️⃣ Extract medicines_prescribed as a list of names
  final List medicines = [];

  final List<String> messages = [];
  String patientSummary = "";
  String doctor_suggestions = "";
  String lifestyle_recommendations = "";
  String advicePlan = "";
  String doctorImpression = "";
  String doctor_impression_and_diagnosis = "";
  @override
  Widget build(BuildContext context) {
    return Expanded(child: LayoutBuilder(
        // If our width is more than 1100 then we consider it a desktop
        builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(children: [
          // Video Call Section
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                        color: AppTheme.whiteTextColor,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                            color: Color.fromRGBO(213, 213, 213, 1))),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            // reverse: true,
                            // controller: controller
                            //     .scrollController, // 👈 attach controller
                            //controller: controller.scrollcontroller,
                            itemCount: 1,
                            padding: EdgeInsets.zero,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              // final words = controller.aichatList[index]["ans"]
                              //     .toString()
                              //     .split(' ');

                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    // if (controller.messages[index]
                                    //         ["sender_type"] ==
                                    //     "doctor")
                                      Container(
                                        // color:
                                        //     Theme.of(context).scaffoldBackgroundColor,
                                        child: Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(
                                            right: 0,
                                          ),
                                          // decoration: BoxDecoration(
                                          //   color: AppTheme.whiteBackgroundColor,
                                          //   borderRadius: BorderRadius.circular(12),
                                          // ),
                                          child: IntrinsicHeight(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                            right: 6,
                                                            top: 6,
                                                            bottom: 6,
                                                          ),
                                                          child: Text(
                                                              "Hi",
                                                              style: GoogleFonts
                                                                  .quicksand(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        1),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                height: 1.6,
                                                              )))
                                                    ],
                                                  ),
                                                ),
                                                VerticalDivider(
                                                  color: Color.fromRGBO(
                                                      66, 217, 129, 1),
                                                  width: 20,
                                                  thickness: 4,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    SizedBox(height: 20),
                                    // if (controller.messages[index]
                                    //         ["sender_type"] ==
                                    //     "patient")
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: IntrinsicHeight(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              VerticalDivider(
                                                color:
                                                    AppTheme.lightPrimaryColor,
                                                width: 20,
                                                thickness: 4,
                                              ),
                                              Flexible(
                                                child: Container(
                                                  // margin:
                                                  //     EdgeInsets
                                                  //         .only(
                                                  //   right: 40,
                                                  // ),
                                                  // width: MediaQuery.of(
                                                  //             context)
                                                  //         .size
                                                  //         .width /
                                                  //     2.6,
                                                  // decoration: BoxDecoration(
                                                  //   color: AppTheme.whiteBackgroundColor,
                                                  //   borderRadius: BorderRadius.circular(12),
                                                  // ),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                      left: 8,
                                                      top: 2,
                                                      bottom: 2,
                                                    ),
                                                    child: Text(
                                                      "Hello",
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 1),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1.6,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    SizedBox(height: 20),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                     ]
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        height: 200, // fixed height to enable scrolling
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text("Medications prescribed",
                                style: GoogleFonts.rubik(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: List.generate(
                                    medicines.length,
                                    (index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  color: Colors.black12)),
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "${medicines[index]["name"]}",
                                                  style: GoogleFonts.rubik(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              Row(
                                                children: [
                                                  Text(
                                                      "${medicines[index]["dosage"]} - ",
                                                      style: GoogleFonts.rubik(
                                                          color: Color.fromRGBO(
                                                              72, 72, 72, 1),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  Text(
                                                      "${medicines[index]["frequency"]}",
                                                      style: GoogleFonts.rubik(
                                                          color: Color.fromRGBO(
                                                              72, 72, 72, 1),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                ],
                                              ),
                                              Text(
                                                  "${medicines[index]["side_effects"]}",
                                                  style: GoogleFonts.rubik(
                                                      color: Color.fromRGBO(
                                                          72, 72, 72, 1),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ],
                                          ),
                                        ),
                                      );
                                      ;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        height: 200, // fixed height to enable scrolling
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text("Test prescribed",
                                style: GoogleFonts.rubik(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    tests.length,
                                    (index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("${tests[index]}",
                                            style: GoogleFonts.rubik(
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400)),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 8,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            if (constraints.maxHeight < constraints.maxWidth)
                              const SizedBox(width: 20),
                            Expanded(
                              flex: 4,
                              child: Container(
                                height: double.infinity,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Image.asset(
                                        "assets/images/aicon.png",
                                        width: 120,
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Text("$doctor_suggestions",
                                          style: GoogleFonts.rubik(
                                              color:
                                                  Color.fromRGBO(12, 12, 12, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400)),
                                      SizedBox(
                                        height: 40,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (constraints.maxHeight < constraints.maxWidth)
                              const SizedBox(width: 20),
                            if (constraints.maxHeight < constraints.maxWidth)
                              Expanded(
                                flex: 8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: List.generate(
                                        tabsLIst.length,
                                        (index) {
                                          return Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectTabs = index;
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8),
                                                decoration: BoxDecoration(
                                                    color: selectTabs == index
                                                        ? Color.fromRGBO(
                                                            60, 150, 255, 1)
                                                        : AppTheme
                                                            .whiteTextColor,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: const Color
                                                            .fromARGB(
                                                            132, 149, 147, 147),
                                                        spreadRadius: 1,
                                                        offset:
                                                            const Offset(0, 6),
                                                        blurRadius: 10,
                                                      )
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(12),
                                                      topRight:
                                                          Radius.circular(12),
                                                    )),
                                                child: Center(
                                                  child: Text(
                                                      "${tabsLIst[index]}",
                                                      style: GoogleFonts.rubik(
                                                          color: selectTabs ==
                                                                  index
                                                              ? Color.fromRGBO(
                                                                  255,
                                                                  255,
                                                                  255,
                                                                  1)
                                                              : Color.fromRGBO(
                                                                  142,
                                                                  142,
                                                                  142,
                                                                  1),
                                                          fontSize: Constant
                                                              .verysmallbody(
                                                                  context),
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1,
                                    ),
                                    Expanded(
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 30),
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                255, 255, 255, 1),
                                          ),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text("Patient:",
                                                              style: GoogleFonts.rubik(
                                                                  color: AppTheme
                                                                      .blackColor,
                                                                  fontSize: Constant
                                                                      .twetysixtext(
                                                                          context),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700)),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text(patientSummary,
                                                              style: GoogleFonts.quicksand(
                                                                  color: AppTheme
                                                                      .blackColor,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text("Description:",
                                                              style: GoogleFonts.rubik(
                                                                  color: AppTheme
                                                                      .blackColor,
                                                                  fontSize: Constant
                                                                      .smallbody(
                                                                          context),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700)),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                              lifestyle_recommendations,
                                                              style: GoogleFonts.quicksand(
                                                                  color: AppTheme
                                                                      .blackColor,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 80,
                                                    ),
                                                    Image.asset(
                                                        "assets/images/full_body.png")
                                                  ],
                                                ),
                                                // Row(
                                                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                //   children: [
                                                //     _infoButton(
                                                //         "Patient Vitals", selectedTab == "vitals", () {
                                                //       setState(() => selectedTab = "vitals");
                                                //     }),
                                                //     _infoButton(
                                                //         "Patient Summary", selectedTab == "summary",
                                                //         () {
                                                //       setState(() => selectedTab = "summary");
                                                //     }),
                                                //   ],
                                                // ),
                                                // const SizedBox(height: 20),
                                                // Expanded(
                                                //     child: selectedTab == "vitals"
                                                //         ? PatientVitalsWidget(height, width)
                                                //         : PatientSummaryWidget(height, width))
                                              ])),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              height: 200, // fixed height to enable scrolling
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Doctor impression and diagnoses",
                                      style: GoogleFonts.rubik(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700)),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Expanded(
                                      child: Container(
                                    child:
                                        Text(doctor_impression_and_diagnosis),
                                  )),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              height: 200, // fixed height to enable scrolling
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Advice and plan",
                                      style: GoogleFonts.rubik(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700)),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: Text("$lifestyle_recommendations",
                                        style: GoogleFonts.rubik(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ]),
      );
    }));
  }
}
