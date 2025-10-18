import 'dart:async';
import 'dart:typed_data';

import 'package:chatbot/utils/custom_print.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class VoiceAgentService {
  final String url;
  final String? token;
  WebSocketChannel? webSocketChannel;
  final _responseController = StreamController<String>.broadcast();
  Stream<String> get messageStream => _responseController.stream;
  final _connectionCompleter = Completer<void>();
  VoiceAgentService({required this.url, this.token});
  Future<void> get onReady => _connectionCompleter.future;

  Future<void> connect() async {
    try {
      final uri = Uri.parse(url).replace(queryParameters: {'token': token});

      webSocketChannel = WebSocketChannel.connect(uri);
      alertPrint('VoiceAgentService: Connecting to Websocket');
      webSocketChannel!.stream.listen(
        (message) {
          /// Add incoming text messages to our stream for the controller to hear
          if (!_connectionCompleter.isCompleted) {
            successPrint(
                "VoiceAgentService: WebSocket Connected and receiving data.");
            _connectionCompleter.complete();
          }
          alertPrint('VoiceAgentService RCV: $message');

          /// STEP 3: The service takes the message and adds it to its own stream controller.
          /// This is like a megaphone, broadcasting the message to anyone in the app who is listening.

          _responseController.add(message);
        },
        onDone: () {
          alertPrint(
              'VoiceAgentService: WebSocket connection closed by server.');
          if (!_connectionCompleter.isCompleted) {
            _connectionCompleter.completeError(
                "Connection closed before it could be established.");
          }
          if (!_responseController.isClosed) _responseController.close();
        },
        onError: (error) {
          errorPrint('VoiceAgentService Connection Error: $error');
          if (!_connectionCompleter.isCompleted) {
            _connectionCompleter.completeError(error);
          }
          if (!_responseController.isClosed) {
            _responseController.addError(error);
          }
        },
        cancelOnError: true,
      );
      // A simple handshake check. If the server doesn't respond in a few seconds, assume failure.
      Future.delayed(Duration(seconds: 7), () {
        if (!_connectionCompleter.isCompleted) {
          errorPrint(
              "VoiceAgentService: Connection timed out after 7 seconds.");
          _connectionCompleter.completeError("Connection timed out.");
        }
      });
    } catch (e) {
      errorPrint('VoiceAgentService: Failed to connect - $e');
      if (!_connectionCompleter.isCompleted) {
        _connectionCompleter.completeError(e);
      }
    }
    return onReady;
  }

  void sendAudio(Uint8List audioData) {
    alertPrint("Sending Audio through socket");
    if (webSocketChannel != null && webSocketChannel!.sink != null) {
      alertPrint(
          'VoiceAgentService SEND: Sending audio chunk (${audioData.lengthInBytes} bytes)');

      try {
        webSocketChannel!.sink.add(audioData);
        successPrint('VoiceAgentService: Audio chunk sent successfully.');
      } catch (e) {
        errorPrint('VoiceAgentService Error on sending audio: $e');
      }
    } else {
      alertPrint(
          'VoiceAgentService Error: Cannot send audio, channel is not connected or sink is null.');
    }
  }

  void close() {
    webSocketChannel?.sink.close();
    _responseController.close();
  }
}
