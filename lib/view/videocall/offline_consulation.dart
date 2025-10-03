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

class OfflineConsulation extends StatefulWidget {
  const OfflineConsulation({super.key});

  @override
  State<OfflineConsulation> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<OfflineConsulation> {
  final _vadHandler = VadHandler.create(isDebug: true);
  bool isListening = false;
  final List<String> receivedEvents = [];

  @override
  void initState() {
    super.initState();
    final ws = OfflineService(
      url: "wss://api.carepal.in/api/v1/voice_agent/ws",
      token: PreferenceUtils.getUserToken(),
    );

// pick file with <input type="file"> in Flutter web
    // FileUploadInputElement upload = FileUploadInputElement();
    // upload.accept = ".wav";
    // upload.click();

    // upload.onChange.listen((event) async {
    //   final file = upload.files!.first;
    //   await ws.sendAudio(file);
    // });

// listen to responses
    ws.messageStream.listen((msg) {
      print("📥 Stream message: $msg");
    });
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                receivedEvents.length,
                (index) {
                  return Text("$receivedEvents");
                },
              ),
            ),
          ),
        )
      ],
    ));
  }
}
