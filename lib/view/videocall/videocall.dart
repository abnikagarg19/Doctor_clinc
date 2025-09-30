import 'dart:typed_data';

import 'package:chatbot/utils/constant.dart';
import 'package:chatbot/videocall/api.dart';
import 'package:chatbot/videocall/audio_class.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart' hide VoidCallback;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:videosdk/videosdk.dart';
import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:convert';
import 'dart:html';
import 'dart:html' hide VoidCallback; // Only for Flutter Web
import '../../../../videocall/participant.dart';
import 'dart:typed_data';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:html' as html;

import '../../components/multiline_textbox.dart' show InputTextFieldMaxlines;
import '../../theme/apptheme.dart';
import 'components/web_cosket.dart';

class DoctorVideoCall extends StatefulWidget {
  final String meetingId;
  final String token;

  const DoctorVideoCall(
      {super.key, required this.meetingId, required this.token});

  @override
  State<DoctorVideoCall> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<DoctorVideoCall> {
  late Room _room;
  bool micEnabled = true;
  bool camEnabled = true;
  late TextEditingController summaryText;
  String selectedTab = "vitals";
  // 4️⃣ Extract tests_ordered as a list
  final List tests = [];
  // 3️⃣ Extract medicines_prescribed as a list of names
  final List medicines = [];
  Map<String, Participant> participants = {};
  late ChatWebSocketService chatService;
  final List<String> messages = [];
  String patientSummary = "";
  String lifestyle_recommendations = "";
  @override
  void initState() {
    super.initState();
    summaryText = TextEditingController();
    createMeeting();

    // Create and join room
    // _room = VideoSDK.createRoom(
    //   roomId: widget.meetingId,
    //   token: widget.token,
    //   displayName: "Doctor",
    //   micEnabled: micEnabled,
    //   defaultCameraIndex: 0,
    //   camEnabled: camEnabled,
    // );
    _room = VideoSDK.createRoom(
      roomId: widget.meetingId ?? "",
      token: widget.token ?? "",
      displayName: "Doctor",
      micEnabled: micEnabled,
      defaultCameraIndex: 0,
      camEnabled: camEnabled,
    );

    setMeetingEventListener();
    // 👇 initialize your service here
    chatService = ChatWebSocketService(
      url: "wss://api.carepal.in/api/v1/appointment/session/stream",
      token: 'Bearer $token', // replace with real token
    );
// Listen to the message stream
    chatService.messageStream.listen((message) {
      // 1️⃣ Convert the full JSON to pretty string for the TextField
      String displayText;
      try {
        displayText = const JsonEncoder.withIndent('  ').convert(message);
      } catch (_) {
        displayText = message.toString();
      }

      // Update the TextField
      summaryText.text = displayText;
      summaryText.selection = TextSelection.fromPosition(
        TextPosition(offset: summaryText.text.length),
      );

      // 2️⃣ Extract patient_summary
      patientSummary = message['patient_summary'] ?? "";

      if (message['medicines_prescribed'] != null) {
        medicines.clear();
        for (var med in message['medicines_prescribed']) {
          medicines.add(med);
        }
      }

      if (message['tests_ordered'] != null) {
        tests.clear();
        for (var test in message['tests_ordered']) {
          tests.add(test.toString());
        }
      }
      if (message['lifestyle_recommendations'] != null) {
        lifestyle_recommendations="";
        for (var test in message['lifestyle_recommendations']) {
          lifestyle_recommendations += test;
        }
      }

      // 👇 You can now use these variables as needed
      print("Patient Summary: $patientSummary");
      print("Patient Summary: $patientSummary");
      print("Medicines: $medicines");
      print("Tests: $tests");
      setState(() {});
    });

    // 👇 listen for messages
  }

  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isPlayerInited = false;
  Future<void> initAudioPlayer() async {
    await _player.openPlayer();
    _isPlayerInited = true;
    await _player.startPlayer(
      fromDataBuffer: Uint8List(0), // start empty
      codec: Codec.pcm16,
      sampleRate: 16000,
      numChannels: 1,
    );
  }

  WebSocket? _socket;
  final _messages = <String>[];
  final _controller = TextEditingController();
  late StreamSubscription _onMessageSub, _onOpenSub, _onCloseSub, _onErrorSub;

  String _status = "Disconnected";

  @override
  void dispose() {
    _onMessageSub.cancel();
    _onOpenSub.cancel();
    _onCloseSub.cancel();
    _onErrorSub.cancel();
    _socket?.close();
    super.dispose();
  }

  List<FlSpot> ecgPoints = [];
  double xValue = 0;

  // Keep last N points (like 500)
  final int maxSamples = 500;

  void onEcgMessage(dynamic data) {
    try {
      if (data is Map<String, dynamic> && data.containsKey('batch')) {
        // Batch of ECG values
        for (var item in data['batch']) {
          final double ecgValue = (item['ecg_value'] as num).toDouble();
          final double ts = (item['timestamp'] as num).toDouble();

          setState(() {
            ecgPoints.add(FlSpot(ts, ecgValue));
            if (ecgPoints.length > maxSamples) {
              ecgPoints.removeAt(0);
            }
          });
        }
      } else if (data is Map<String, dynamic>) {
        // Single ECG value
        final double ecgValue = (data['ecg_value'] as num).toDouble();
        final double ts = (data['timestamp'] as num).toDouble();

        setState(() {
          ecgPoints.add(FlSpot(ts, ecgValue));
          if (ecgPoints.length > maxSamples) {
            ecgPoints.removeAt(0);
          }
        });
      }
    } catch (e) {
      print("❌ Error parsing ECG: $e");
    }
  }

  Map<String, Participant> remoteParticipants = {};

  void setMeetingEventListener() {
    _room.on(Events.roomJoined, () {
      setState(() {
        participants[_room.localParticipant.id] = _room.localParticipant;
      });

      // 🔁 Listen to own stream updates (optional)
      _room.localParticipant.on(Events.streamEnabled, (Stream stream) {
        setState(() {});
      });
    });

    _room.on(Events.participantJoined, (Participant participant) {
      setState(() {
        participants[participant.id] = participant;
      });
      // participant.enableCam().then((value) {
      //   print("Camera enabled");
      // }).catchError((e) {
      //   print("Error enabling camera: $e");
      // });

      participant.on(Events.streamEnabled, (_) => setState(() {}));
      participant.on(Events.streamDisabled, (_) => setState(() {}));
    });

    _room.on(Events.participantLeft, (String participantId) {
      setState(() {
        participants.remove(participantId);
        print("Remote participant left: ${participantId}");
      });
    });

    _room.on(Events.transcriptionText, (TranscriptionText data) {
      final type = data.type; // correct
      final text = data.text; // correct
      final participantName = data.participantName; // correct

      if (type == "fullSentence" && text != null && participantName != null) {
        print("FINAL: $participantName said: $text");

        // Forward to WebSocket chat
        chatService.sendPatientMessage("[patient]: $text");
      }
    });

    // _room.on(Events.transcriptionText, (data) {
    //   data.toJson().forEach(
    //       (key, value) => print('$key: $value')); // if SDK supports toJson()
    // });
    // _room.join();

    TranscriptionConfig transcriptionConfig = TranscriptionConfig(
      webhookUrl:
          "https://recurrently-congruent-millard.ngrok-free.dev/webhook",
      summaryConfig: SummaryConfig(
        enabled: false,
        prompt:
            "Write summary in sections like Title, Agenda, Speakers, Action Items, Outlines, Notes and Summary",
      ),
    );
    _room.join().then((_) {
      print("Room joined successfully");

      // Now start transcription
      try {
        _room.startTranscription(transcriptionConfig: transcriptionConfig);
      } catch (e, s) {
        print("Error starting transcription: $e\n$s");
      }
    });
  }

  Future<bool> _onWillPop() async {
    _room.leave();
    return true;
  }

  List tabsLIst = [
    "Summary",
    "Timeline",
    "Concerns",
    "Lab Results",
    "Medications"
  ];
  bool isPlaying = false;
  AudioElement? _audioEl;
  String? _wavUrl;

  // void prepareAudio() {
  //    if (_pcmChunks.isEmpty) {
  //   print("⚠️ No audio data yet.");
  //   return;
  // }
  //   final wavBytes = pcmToWav(_pcmChunks);

  //   final blob = html.Blob([wavBytes]);
  //   _wavUrl = html.Url.createObjectUrlFromBlob(blob);

  //   _audioEl = html.AudioElement(_wavUrl!)
  //     ..controls = false
  //     ..autoplay = true;
  //   _audioEl!.play().catchError((err) {
  //     print("⚠️ Autoplay blocked: $err");
  //   });
  // }
  /// Optional: amplify PCM16 audio
  Uint8List amplifyPCM16(Uint8List pcm, {double gain = 2.0}) {
    final int16 = pcm.buffer.asInt16List();
    final out = Int16List(int16.length);

    for (int i = 0; i < int16.length; i++) {
      int amplified = (int16[i] * gain).toInt();
      if (amplified > 32767) amplified = 32767;
      if (amplified < -32768) amplified = -32768;
      out[i] = amplified;
    }

    return out.buffer.asUint8List();
  }

  Uint8List pcmToWav(List<int> pcmData,
      {int sampleRate = 16000, int channels = 1}) {
    int byteRate = sampleRate * channels * 2; // 16-bit PCM
    int blockAlign = channels * 2;
    int dataLength = pcmData.length;
    int fileSize = 36 + dataLength;

    final header = BytesBuilder();
    header.add(ascii.encode('RIFF'));
    header.add(_intToBytes(fileSize, 4));
    header.add(ascii.encode('WAVE'));
    header.add(ascii.encode('fmt '));
    header.add(_intToBytes(16, 4)); // Subchunk1 size
    header.add(_intToBytes(1, 2)); // PCM format
    header.add(_intToBytes(channels, 2));
    header.add(_intToBytes(sampleRate, 4));
    header.add(_intToBytes(byteRate, 4));
    header.add(_intToBytes(blockAlign, 2));
    header.add(_intToBytes(16, 2)); // Bits per sample
    header.add(ascii.encode('data'));
    header.add(_intToBytes(dataLength, 4));

    return Uint8List.fromList(header.toBytes() + pcmData);
  }

  List<int> _intToBytes(int value, int byteCount) {
    final bytes = <int>[];
    for (int i = 0; i < byteCount; i++) {
      bytes.add((value >> (8 * i)) & 0xFF);
    }
    return bytes;
  }

  int selectTabs = 0;
  @override
  Widget build(BuildContext context) {
    final local = _room.localParticipant;
    final remoteParticipants =
        participants.values.where((p) => p.id != local.id).toList();

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(242, 246, 255, 1),
          // appBar: AppBar(
          //   title: const Text(
          //     "Doctor Appointment",
          //     style: TextStyle(fontSize: 16),
          //   ),
          //   centerTitle: true,
          //   backgroundColor: const Color.fromARGB(255, 211, 231, 248),
          //   elevation: 0,
          //   leading: IconButton(
          //     icon: const Icon(Icons.menu, color: Colors.black),
          //     onPressed: () {},
          //   ),
          // ),
          body: LayoutBuilder(
              // If our width is more than 1100 then we consider it a desktop
              builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(children: [
                // Video Call Section
                Expanded(
                  flex: 7,
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            // Positioned.fill(
                            //   child: ClipRRect(
                            //     borderRadius: BorderRadius.circular(12),
                            //     child: ParticipantTile(
                            //       key: Key(_room.localParticipant.id),
                            //       participant: local,
                            //     ),
                            //   ),
                            // ),

                            // if (remoteParticipants.isNotEmpty)
                            //   Positioned(
                            //     top: 16,
                            //     left: 16,
                            //     child: ClipRRect(
                            //       borderRadius: BorderRadius.circular(12),
                            //       child: Container(
                            //         width: 150,
                            //         height: 180,
                            //         decoration: BoxDecoration(
                            //           color: Colors.black,
                            //           borderRadius: BorderRadius.circular(12),
                            //         ),
                            //         child: ParticipantTile(
                            //           participant: remoteParticipants.first,
                            //           smallView: true,
                            //         ),
                            //       ),
                            //     ),
                            //   )
                            // else
                            //   Positioned(
                            //     top: 16,
                            //     left: 16,
                            //     child: ClipRRect(
                            //       borderRadius: BorderRadius.circular(12),
                            //       child: Container(
                            //           width: 150,
                            //           height: 180,
                            //           decoration: BoxDecoration(
                            //             color: Colors.black,
                            //             border: Border.all(
                            //                 color: AppTheme.backGround),
                            //             borderRadius: BorderRadius.circular(12),
                            //           ),
                            //           child: Center(
                            //               child: Text("No Video",
                            //                   style: GoogleFonts.rubik(
                            //                       color: AppTheme
                            //                           .whiteBackgroundColor,
                            //                       fontSize: 12,
                            //                       fontWeight:
                            //                           FontWeight.w500)))),
                            //     ),
                            //   ),
                            Positioned.fill(
                              child: remoteParticipants.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: ParticipantTile(
                                        participant: remoteParticipants.first,
                                      ),
                                    )
                                  : Container(
                                      color: Colors.black,
                                      child: Center(
                                          child: Text("Waiting for Patient...",
                                              style: GoogleFonts.rubik(
                                                  color: AppTheme
                                                      .whiteBackgroundColor,
                                                  fontSize: 12,
                                                  fontWeight:
                                                      FontWeight.w500))),
                                    ),
                            ),

                            // if (remoteParticipants.isNotEmpty)
                            Positioned(
                              top: 16,
                              left: 16,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: 150,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ParticipantTile(
                                    key: Key(_room.localParticipant.id),
                                    participant: local,
                                    //   participant: remoteParticipants.first,
                                    smallView: true,
                                  ),
                                ),
                              ),
                            ),

                            Positioned(
                              bottom: 16,
                              left: 20,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  _controlButton(
                                    micEnabled ? Icons.mic : Icons.mic_off,
                                    micEnabled ? Colors.grey : Colors.red,
                                    () {
                                      micEnabled
                                          ? _room.muteMic()
                                          : _room.unmuteMic();
                                      setState(() => micEnabled = !micEnabled);
                                    },
                                  ),
                                  const SizedBox(width: 20),
                                  _controlButton(
                                    camEnabled
                                        ? Icons.videocam
                                        : Icons.videocam_off,
                                    camEnabled ? Colors.grey : Colors.red,
                                    () {
                                      camEnabled
                                          ? _room.disableCam()
                                          : _room.enableCam();
                                      setState(() => camEnabled = !camEnabled);
                                    },
                                  ),
                                  const SizedBox(width: 20),
                                  _controlButton(Icons.call_end, Colors.red,
                                      () {
                                    _room.leave();
                                  }),
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    border: Border.all(
                                                        color: Colors.black12)),
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        "${medicines[index]["name"]}",
                                                        style: GoogleFonts
                                                            .rubik(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        1),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                    Row(
                                                      children: [
                                                        Text(
                                                            "${medicines[index]["dosage"]} - ",
                                                            style: GoogleFonts.rubik(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        72,
                                                                        72,
                                                                        72,
                                                                        1),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                        Text(
                                                            "${medicines[index]["frequency"]}",
                                                            style: GoogleFonts.rubik(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        72,
                                                                        72,
                                                                        72,
                                                                        1),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                      ],
                                                    ),
                                                    Text(
                                                        "${medicines[index]["side_effects"]}",
                                                        style:
                                                            GoogleFonts.rubik(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        72,
                                                                        72,
                                                                        72,
                                                                        1),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: List.generate(
                                          tests.length,
                                          (index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("${tests[index]}",
                                                  style: GoogleFonts.rubik(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400)),
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

                if (constraints.maxHeight < constraints.maxWidth)
                  const SizedBox(width: 20),
                if (constraints.maxHeight < constraints.maxWidth)
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Patient Summary",
                            style: GoogleFonts.rubik(
                                color: Color.fromRGBO(54, 100, 188, 1),
                                fontSize: Constant.subHeading(context),
                                fontWeight: FontWeight.w700)),
                        SizedBox(
                          height: 20,
                        ),
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
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                        color: selectTabs == index
                                            ? Color.fromRGBO(60, 150, 255, 1)
                                            : AppTheme.whiteTextColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                132, 149, 147, 147),
                                            spreadRadius: 1,
                                            offset: const Offset(0, 6),
                                            blurRadius: 10,
                                          )
                                        ],
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        )),
                                    child: Center(
                                      child: Text("${tabsLIst[index]}",
                                          style: GoogleFonts.rubik(
                                              color: selectTabs == index
                                                  ? Color.fromRGBO(
                                                      255, 255, 255, 1)
                                                  : Color.fromRGBO(
                                                      142, 142, 142, 1),
                                              fontSize: Constant.verysmallbody(
                                                  context),
                                              fontWeight: FontWeight.w500)),
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
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 30),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 255, 255, 1),
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text("Patient:",
                                                style: GoogleFonts.rubik(
                                                    color: AppTheme.blackColor,
                                                    fontSize:
                                                        Constant.twetysixtext(
                                                            context),
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(patientSummary,
                                                style: GoogleFonts.quicksand(
                                                    color: AppTheme.blackColor,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text("Description:",
                                                style: GoogleFonts.rubik(
                                                    color: AppTheme.blackColor,
                                                    fontSize:
                                                        Constant.smallbody(
                                                            context),
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(lifestyle_recommendations,
                                                style: GoogleFonts.quicksand(
                                                    color: AppTheme.blackColor,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 80,
                                      ),
                                      Image.asset("assets/images/full_body.png")
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
                      ],
                    ),
                  ),
                //  ],
              ]),
            );
          }),
        ));
  }

  Widget PatientVitalsWidget(double height, double width) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(width * 0.015)),
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.02, vertical: height * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  _infoText("Name:", "Rajesh Kumar"),
                  SizedBox(height: 20),
                  _infoText("Age:", "52"),
                  SizedBox(height: 20),
                  _infoText("Gender:", "Male"),
                  SizedBox(height: 20),
                  _infoText(
                      "Medical History:", "Type 2 Diabetes, Hypertension"),
                  SizedBox(height: 20),
                  _infoText("Medications:", "Metformin 500 mg"),
                  SizedBox(height: 20),
                  _infoText("Surgeries:", "Appendix, Vasectomy"),
                  SizedBox(height: 20),
                  Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _infoText("Allergies:", "\nPeanut, Soy, Pollen, Dairy"),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  _infoText("Patient Summery:\n",
                      "23y old female patient presents with a mild-grade febrile illness accompanied by a productive cough yielding white, odorless, non-blood-tinged sputum. Symptoms have been gradual in onset, with no associated chills, dyspnea, chest pain, or systemic complaints. There is no past medical history suggestive of diabetes, hypertension, thyroid dysfunction, or tuberculosis. Personal and lifestyle history are unremarkable."),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget vitalCard({
    required String title,
    required String value,
    required String status,
    required Color bgColor,
    required double height,
    required double width,
    double? cwidth,
    TextStyle? titleStyle,
    TextStyle? valueStyle,
    TextStyle? statusStyle,
    double? iconSize,
    BorderRadius? borderRadius,
    bool showPlayIcon = false,
  }) {
    return Container(
      width: cwidth ?? width * 0.33,
      padding: EdgeInsets.all(width * 0.01),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius ?? BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle ??
                TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: width * 0.04,
                ),
          ),
          Text(
            value,
            style: valueStyle ??
                TextStyle(
                  fontSize: width * 0.05, // Default dynamic size
                  fontWeight: FontWeight.bold,
                ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.circle,
                size: iconSize ?? width * 0.03,
                color: status == "Danger" ? Colors.red : Colors.green,
              ),
              SizedBox(
                width: width * 0.0025,
              ),
              Text(
                status,
                style: statusStyle ??
                    TextStyle(
                      fontSize: width * 0.03,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              if (showPlayIcon) ...[
                Spacer(),
                Icon(
                  Icons.play_arrow,
                  color: Colors.black,
                  size: width * 0.012,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget infoCard(double width, double height,
      {required String title, required Widget content, double? cwidth}) {
    return Container(
      width: cwidth ?? width * 0.22,
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.03, vertical: height * 0.035),
      decoration: BoxDecoration(
        color: const Color(0xFFD9E5FF),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: Constant.twetysixtext(Get.context!),
                  fontWeight: FontWeight.w600,
                  color: Colors.black)),
          SizedBox(height: height * 0.01),
          content,
        ],
      ),
    );
  }
}

Widget _controlButton(IconData icon, Color color, VoidCallback onPressed) {
  return CircleAvatar(
    radius: 24,
    backgroundColor: color,
    child:
        IconButton(icon: Icon(icon, color: Colors.white), onPressed: onPressed),
  );
}

Widget _infoButton(String title, bool isSelected, VoidCallback onTap,
    {double? width, double? height}) {
  return TextButton(
    style: TextButton.styleFrom(
      backgroundColor: isSelected ? Colors.black : Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      minimumSize: Size(width ?? 200, height ?? 40),
    ),
    onPressed: onTap,
    child: Text(
      title,
      style: TextStyle(
        fontSize: Constant.smallbody(Get.context!),
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Widget _infoText(String title, String value) {
  if (!value.contains('\n')) {
    // Case: No \n → Show in a single line
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          text: "$title ",
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        textAlign: TextAlign.start,
      ),
    );
  } else {
    // Case: Contains \n → Split into multiple lines with spacing
    List<String> lines = value.split('\n');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: lines
                .map((line) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        line,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
