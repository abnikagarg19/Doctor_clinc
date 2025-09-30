import 'dart:async';
import 'dart:convert';
import 'dart:html'; // Only for Flutter Web
import 'package:flutter/material.dart';

class WebSocketPage extends StatefulWidget {
  const WebSocketPage({super.key});

  @override
  State<WebSocketPage> createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  WebSocket? _socket;
  final _messages = <String>[];
  final _controller = TextEditingController();
  late StreamSubscription _onMessageSub, _onOpenSub, _onCloseSub, _onErrorSub;

  String _status = "Disconnected";

  // Parsed sensor values
  double? tempObj;
  int? bpm;
  int? spo2;

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  void _connectWebSocket() {
    _socket = WebSocket("ws://127.0.0.1:8000/ws/iot");

    _onOpenSub = _socket!.onOpen.listen((_) {
      setState(() {
        _status = "Connected ✅";
      });
    });

    _onMessageSub = _socket!.onMessage.listen((event) {
      final data = event.data;
      if (data is String) {
        try {
          final jsonData = jsonDecode(data);
          final topic = jsonData["topic"];
          final payload = jsonData["payload"];

          // Pick fields depending on topic
          if (topic == "ecg_data/temperature") {
            tempObj = payload["temp_obj_C"]?.toDouble();
          } else if (topic == "ecg_data/SPO2") {
            dynamic latest;

            if (payload is List && payload.isNotEmpty) {
              // take last element of array
              latest = payload.last;
            } else if (payload is Map) {
              // single object
              latest = payload;
            }

            if (latest != null) {
              spo2 = latest["SpO2"]?.toInt();
              bpm = latest["bpm"]?.toInt();
            }
          }

          setState(() {
            _messages.add("📩 $topic → $payload");
          });
        } catch (e) {
          setState(() {
            _messages.add("⚠️ Invalid JSON: $data");
          });
        }
      }
    });

    _onCloseSub = _socket!.onClose.listen((_) {
      setState(() {
        _status = "Disconnected ❌";
      });
    });

    _onErrorSub = _socket!.onError.listen((_) {
      setState(() {
        _status = "Error ⚠️";
      });
    });
  }

  void _sendMessage() {
    if (_socket != null && _socket!.readyState == WebSocket.OPEN) {
      _socket!.send(_controller.text);
      setState(() {
        _messages.add("➡️ ${_controller.text}");
      });
      _controller.clear();
    } else {
      setState(() {
        _messages.add("⚠️ Not connected");
      });
    }
  }

  @override
  void dispose() {
    _onMessageSub.cancel();
    _onOpenSub.cancel();
    _onCloseSub.cancel();
    _onErrorSub.cancel();
    _socket?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("WebSocket Demo ($_status)")),
      body: Column(
        children: [
          // 🔹 Show extracted values
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                    "🌡️ Temperature: ${tempObj?.toStringAsFixed(2) ?? "--"} °C"),
                Text("💓 BPM: ${bpm ?? "--"}"),
                Text("🩸 SpO₂: ${spo2 ?? "--"} %"),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(_messages[index]));
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Enter message",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
              )
            ],
          ),
        ],
      ),
    );
  }
}
