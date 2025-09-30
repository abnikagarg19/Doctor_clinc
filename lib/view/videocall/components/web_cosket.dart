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

  bool _manuallyClosed = false; // flag to avoid reconnect if user calls close()
  int _reconnectAttempt = 0;
  final int _maxReconnectAttempts = 10;

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
      print("ReadyState: ${_socket.readyState}");
      _reconnectAttempt = 0; // reset counter on successful connection
    });

    _socket.onClose.listen((event) {
      print("WebSocket closed ❌");
      if (!_manuallyClosed) {
        _reconnect();
      }
    });

    _socket.onError.listen((event) {
      print("WebSocket error ⚠️");
      if (!_manuallyClosed) {
        _reconnect();
      }
    });

    _socket.onMessage.listen((MessageEvent event) {
      print("Received message: ${event.data}");
      try {
        final data = jsonDecode(event.data);
        _messageStreamController.add(data);
      } catch (e) {
        // If not JSON, wrap as a simple text message
        _messageStreamController.add({"text": event.data});
      }
    });
  }

  void _reconnect() {
    if (_reconnectAttempt >= _maxReconnectAttempts) {
      print("Max reconnect attempts reached. Giving up.");
      return;
    }
    _reconnectAttempt++;
    print("Attempting reconnect #$_reconnectAttempt in 3 seconds...");
    Future.delayed(const Duration(seconds: 3), () {
      print("Reconnecting...");
      _connect();
    });
  }

  void sendPatientMessage(String message) {
    print("Sending patient message: $message");
    _socket.sendString("[patient]: $message");
  }

  void sendDoctorMessage(String message) {
    print("Sending doctor message: $message");
    _socket.sendString("[doctor]: $message");
  }

  void close() {
    _manuallyClosed = true; // prevent auto-reconnect
    _socket.close();
  }
}
