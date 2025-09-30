import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vad/vad.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../theme/apptheme.dart';
import 'doctor_page.dart';

class VoiceChat extends StatefulWidget {
  const VoiceChat({super.key});

  @override
  State<VoiceChat> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<VoiceChat> {
  final _vadHandler = VadHandler.create(isDebug: true);
  bool isListening = false;
  final List<String> receivedEvents = [];

  @override
  void initState() {
    super.initState();
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
      await sendToSarvam(wavBytes);
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
    sendToChatApi("");
  }

  final String apiKey = 'sk_3pushmp9_X5JBuMdZAopPblkzMHWKiQ18';

  Future<void> sendToSarvam(Uint8List wavBytes) async {
    try {
      final uri = Uri.parse('https://api.sarvam.ai/speech-to-text');
      print("file api hit");
      final request = http.MultipartRequest('POST', uri)
        ..headers['api-subscription-key'] = apiKey
        ..fields['model'] = 'saarika:v2.5'
        ..fields['language_code'] = 'en-IN'
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          wavBytes,
          filename: 'speech.wav',
          contentType: MediaType('audio', 'wav'),
        ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        debugPrint("Sarvam response: $responseData");

        var decoded = jsonDecode(responseData);
        print("Transcription: ${decoded["transcript"]}");

        if (decoded["transcript"] != "") {
          setState(() {
            speakText = decoded["transcript"];
          });
          sendToChatApi(decoded["transcript"]);
        }
        //setState(() => receivedEvents.add("Sarvam: $responseData"));
      } else {
        debugPrint("Sarvam error: ${response.stream}");
        setState(
            () => receivedEvents.add("Sarvam error: ${response.statusCode}"));
      }
    } catch (e) {
      debugPrint("Sarvam exception: $e");
      setState(() => receivedEvents.add("Sarvam exception: $e"));
    }
  }

  int count = 0;

  /// Call your chat API
  Future<void> sendToChatApi(String message) async {
    try {
      count++;
      setState(() {});
      if (count == 1) {
        final uri = Uri.parse("https://aeonlyf.com/chat");
        chatList.clear();
        final chatResponse = await http.post(
          uri,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "user_id": "22",
            "language": "en",
            "message": message,
          }),
        );

        // setState(() => receivedEvents.add("aeonlyf: ${chatResponse.body}"));
        if (chatResponse.statusCode != 200) {
          debugPrint("Chat API failed: ${chatResponse.body}");
          return;
        }

        final chatJson = jsonDecode(chatResponse.body);
        final botResponse = chatJson["bot_response"];
        debugPrint("🤖 Bot chatJson: $chatJson");
        chatList = chatJson["symptoms"];

        setState(() {
          speakText = botResponse;
        });
        debugPrint("🤖 Bot says: $botResponse");

        tts(botResponse, chatJson["interview_complete"]);
      }
      // Step 2: Send bot response to Sarvam TTS API
    } catch (e) {
      print(e);
    }
  }

  tts(botResponse, isCompleted) async {
    try {
      final ttsUri = Uri.parse("https://api.sarvam.ai/text-to-speech");

      final ttsResponse = await http.post(
        ttsUri,
        headers: {
          'api-subscription-key': 'sk_f0s2ysgb_xKX6YUBAiRVMtEvGuWE2Ywn3',
          'content-type': 'application/json',
        },
        body: jsonEncode({
          "text": botResponse,
          "target_language_code": "en-IN", // or "en-IN"
          "speaker": "anushka",
          "pitch": 0,
          "pace": 1,
          "loudness": 1,
          "speech_sample_rate": 22050,
          "enable_preprocessing": true,
          "model": "bulbul:v2"
        }),
      );
      debugPrint("🤖 ttsResponse says: $ttsResponse");
      if (ttsResponse.statusCode != 200) {
        debugPrint("TTS API failed: ${ttsResponse.body}");
        return;
      }

      // Step 3: Decode audio (Sarvam returns base64 audio)
      final ttsJson = jsonDecode(ttsResponse.body);
      final audioBase64 = ttsJson["audios"][0]; // check actual field name
      final audioBytes = base64Decode(audioBase64);

      // Step 4: Play audio in Flutter Web
      final player = AudioPlayer();
      await player.play(BytesSource(audioBytes));
      timer = Timer.periodic(const Duration(milliseconds: 100), (_) async {
        _amplitude =
            Random().nextDouble(); // Placeholder: use real FFT data here

        //  _amplitude = 0.5 + Random().nextDouble() * 0.5; // random height
        _phase += 0.2; // move wave horizontally
        setState(() {
          imageScale = 1.0 + _amplitude * 0.9; // Expand/shrink
        });
      });

      player.onPlayerStateChanged.listen((state) {
        if (state == PlayerState.completed) {
          count = 0;
          timer?.cancel();
          setState(() {
            imageScale = 1.0;
          });
          if (isCompleted) {
            _vadHandler.dispose();
            Get.to(BookedAppointment());
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Timer? timer;
  double imageScale = 1.0;
  double _amplitude = 0.0;
  double _phase = 0.0; // for wave movement
  @override
  void dispose() {
    _vadHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ElevatedButton.icon(
            //   onPressed: () async {
            //     if (isListening) {
            //       await _vadHandler.stopListening();
            //     } else {
            //       await _vadHandler.startListening(
            //         submitUserSpeechOnPause: true,
            //       );
            //     }
            //     setState(() => isListening = !isListening);
            //   },
            //   icon: Icon(isListening ? Icons.stop : Icons.mic),
            //   label: Text(isListening ? "Stop Listening" : "Start Listening"),
            //   style: ElevatedButton.styleFrom(
            //     minimumSize: const Size(double.infinity, 48),
            //   ),
            // ),
            // const SizedBox(height: 8),
            // TextButton.icon(
            //   onPressed: () async {
            //     final status = await Permission.microphone.request();
            //     debugPrint("Microphone permission status: $status");
            //   },
            //   icon: const Icon(Icons.settings_voice),
            //   label: const Text("Request Microphone Permission"),
            //   style: TextButton.styleFrom(
            //     minimumSize: const Size(double.infinity, 48),
            //   ),
            // ),
            SizedBox(height: 100),
            Center(
              child: AnimatedScale(
                scale: imageScale,
                duration: const Duration(milliseconds: 800),
                child: Image.asset(
                  "assets/images/aicon.png",
                  width: 200,
                ),
              ),
            ),
            SizedBox(height: 50),
            Container(
              width: double.infinity,
              child: Text(
                speakText.toString(),
                style: GoogleFonts.quicksand(
                  color: Color.fromRGBO(
                    75,
                    75,
                    75,
                    1,
                  ),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            ...List.generate(
              chatList.length,
              (index) {
                String optionText = chatList[index];

                return Container(
                  margin: EdgeInsets.only(
                    bottom: 16,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(49, 211, 12, 1), width: 0.7),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(optionText,
                          style: GoogleFonts.quicksand(
                              color: AppTheme.blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                );
              },
            ),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: receivedEvents.length,
            //     itemBuilder: (context, index) {
            //       return Text(receivedEvents[index]);
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
