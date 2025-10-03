import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data'; // only for Flutter Web

class OfflineService {
  final String url;
  final String token;

  late WebSocket _socket;

  final StreamController<Map<String, dynamic>> _messageStreamController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get messageStream =>
      _messageStreamController.stream;

  OfflineService({
    required this.url,
    required this.token,
  }) {
    _connect();
  }

  void _connect() {
    final uri = Uri.parse(url).replace(queryParameters: {
      "token": token,
    });

    _socket = WebSocket(uri.toString());

    _socket.onOpen.listen((event) {
      print("✅ WebSocket connected");

      // send init once connectedRR
      send({
        "event": "init",
        "user_id": "22",
        "doctor_language": "en",
        "patient_language": "en",
      });
    });

    _socket.onClose.listen((event) {
      print("❌ WebSocket closed, retrying...");
      _reconnect();
    });

    _socket.onError.listen((event) {
      print("⚠️ WebSocket error");
    });

    _socket.onMessage.listen((MessageEvent event) {
      print("📩 Received: ${event.data}");
      try {
        final data = jsonDecode(event.data);
        _messageStreamController.add(data);
      } catch (e) {
        _messageStreamController.add({"text": event.data});
      }
    });
  }

  /// Reconnect on close/error
  void _reconnect() {
    Future.delayed(const Duration(seconds: 3), () {
      _connect();
    });
  }

  /// Generic send helper
  void send(Map<String, dynamic> data) {
    final msg = jsonEncode(data);
    print("➡️ Sending: $msg");
    _socket.send(msg);
  }

  /// Send wav file as audio chunks (100ms each)
  Future<void> sendAudio(File file) async {
    final reader = FileReader();

    reader.readAsArrayBuffer(file);
    await reader.onLoad.first;

    final bytes = reader.result as ByteBuffer;
    final data = Uint8List.view(bytes);

    // Assumptions: 16kHz, mono, 16-bit PCM
    final chunkMs = 100;
    final sampleRate = 16000;
    final channels = 1;
    final bytesPerSample = 2;
    final framesPerChunk = (sampleRate * (chunkMs / 1000)).toInt();
    final chunkSize = framesPerChunk * channels * bytesPerSample;

    for (var i = 0; i < data.length; i += chunkSize) {
      final chunk = data.sublist(i, i + chunkSize > data.length ? data.length : i + chunkSize);
      final payload = base64Encode(chunk);

      send({
        "event": "audio_chunk",
        "payload": payload,
      });

      await Future.delayed(Duration(milliseconds: chunkMs));
    }

    // Stop after done
    send({"event": "stop"});
    print("🛑 Sent stop");
  }

  void close() {
    _socket.close();
  }
}
