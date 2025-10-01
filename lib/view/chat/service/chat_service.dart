import 'dart:async';
import 'dart:convert';
import 'dart:html';

class ChatWebSocketService {
  final String url;
  final String token;

  late WebSocket _socket;

  final StreamController<Map<String, dynamic>> _messageStreamController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get messageStream =>
      _messageStreamController.stream;

  ChatWebSocketService({
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
      print("WebSocket connected ✅");
    });

    _socket.onClose.listen((event) {
      print("WebSocket closed ❌");
      _reconnect();
    });

    _socket.onError.listen((event) {
      print("WebSocket error ⚠️");
    });

    _socket.onMessage.listen((MessageEvent event) {
      print("Received message: ${event.data}");
      try {
        final data = jsonDecode(event.data);
        _messageStreamController.add(data["data"]);
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

  void close() {
    _socket.close();
  }
}
