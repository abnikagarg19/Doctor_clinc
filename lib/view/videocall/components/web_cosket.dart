import 'dart:async';
import 'dart:convert';
import 'dart:html';

class ChatWebSocketService {
  final String url;
  final String token;

  late WebSocket _socket;


  // Stream for received messages
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
      print("WebSocket connected ✅"); print("ReadyState: ${_socket.readyState}"); // 1 = OPEN
    });

    _socket.onClose.listen((event) {
      print("WebSocket closed ❌");
    });

    _socket.onError.listen((event) {
      print("WebSocket error ⚠️");
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

  void sendPatientMessage(String message) {
    print("Sending patient message: $message"); // <-- print message
    _socket.sendString("[patient]: $message");
  }

  void sendDoctorMessage(String message) {
    print("Sending doctor message: $message"); // <-- print message
    _socket.sendString("[doctor]: $message");
  }

  void close() {
    _socket.close();
  }
}
