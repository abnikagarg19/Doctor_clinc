import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:html' as html;

class WebSocketPageWeb extends StatefulWidget {
  const WebSocketPageWeb({Key? key}) : super(key: key);

  @override
  State<WebSocketPageWeb> createState() => _WebSocketPageWebState();
}

class _WebSocketPageWebState extends State<WebSocketPageWeb> {
  html.WebSocket? _webSocket;
  bool _isConnected = false;
  List<String> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _useCustomUrl = false;

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
  }

  void _connectToWebSocket() {
    try {
      String wsUrl;
      
      if (_useCustomUrl && _urlController.text.isNotEmpty) {
        // Use custom URL if provided
        wsUrl = _urlController.text;
        _addMessage('Using custom URL: $wsUrl', isSuccess: true);
      } else {
        // For Flutter web, use the current hostname
        final hostname = Uri.base.host;
        final port = '8000';
        wsUrl = 'ws://$hostname:$port/ws/test';
        _addMessage('Web detected. Using hostname: $hostname', isSuccess: true);
      }
      
      _addMessage('Connecting to: $wsUrl', isSuccess: true);
      
      _webSocket = html.WebSocket(wsUrl);
      
      _webSocket!.onMessage.listen((event) {
        _handleMessage(event.data);
      });
      
      _webSocket!.onError.listen((event) {
        _addMessage('Error: WebSocket error', isError: true);
        setState(() {
          _isConnected = false;
        });
      });
      
      _webSocket!.onClose.listen((event) {
        _addMessage('WebSocket connection closed', isError: true);
        setState(() {
          _isConnected = false;
        });
      });
      
      _webSocket!.onOpen.listen((event) {
        setState(() {
          _isConnected = true;
        });
        _addMessage('Connected to WebSocket server', isSuccess: true);
      });
      
    } catch (e) {
      _addMessage('Failed to connect: $e', isError: true);
    }
  }

  void _handleMessage(dynamic data) {
    try {
      if (data is String) {
        final jsonData = json.decode(data);
        if (jsonData['type'] == 'welcome') {
          _addMessage('Welcome! Client count: ${jsonData['client_count']}', isSuccess: true);
        } else if (jsonData['type'] == 'mqtt_simulation') {
          _addMessage('MQTT: ${jsonData['topic']} - ${jsonData['payload']}', isMqtt: true);
        } else if (jsonData['type'] == 'echo') {
          _addMessage('Echo: ${jsonData['message']}', isSuccess: true);
        } else if (jsonData['type'] == 'client_connected') {
          _addMessage('Client connected: ${jsonData['message']}', isSuccess: true);
        } else if (jsonData['type'] == 'client_disconnected') {
          _addMessage('Client disconnected: ${jsonData['message']}', isSuccess: true);
        } else if (jsonData['type'] == 'user_message') {
          _addMessage('User message: ${jsonData['message']}', isSuccess: true);
        } else if (jsonData['type'] == 'manual_test') {
          _addMessage('Manual test: ${jsonData['message']}', isSuccess: true);
        } else {
          _addMessage('Message: ${jsonData['type']} - ${jsonData.get('message', 'No message')}');
        }
      } else {
        _addMessage('Received: $data');
      }
    } catch (e) {
      _addMessage('Raw message: $data');
    }
  }

  void _addMessage(String message, {bool isError = false, bool isSuccess = false, bool isMqtt = false}) {
    setState(() {
      _messages.add('${DateTime.now().toString().substring(11, 19)}: $message');
      if (_messages.length > 100) {
        _messages.removeAt(0);
      }
    });
    
    // Auto-scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty && _webSocket != null) {
      _webSocket!.send(_messageController.text);
      _addMessage('Sent: ${_messageController.text}', isSuccess: true);
      _messageController.clear();
    }
  }

  void _reconnect() {
    if (_webSocket != null) {
      _webSocket!.close();
    }
    _messages.clear();
    _connectToWebSocket();
  }

  @override
  void dispose() {
    _webSocket?.close();
    _messageController.dispose();
    _urlController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebSocket Test (Web)'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isConnected ? Icons.wifi : Icons.wifi_off),
            onPressed: _isConnected ? null : _reconnect,
            tooltip: _isConnected ? 'Connected' : 'Reconnect',
          ),
        ],
      ),
      body: Column(
        children: [
          // Custom URL Configuration
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _useCustomUrl,
                      onChanged: (value) {
                        setState(() {
                          _useCustomUrl = value ?? false;
                        });
                      },
                    ),
                    Text('Use Custom WebSocket URL', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                if (_useCustomUrl) ...[
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _urlController,
                          decoration: InputDecoration(
                            hintText: 'ws://127.0.0.1:8000/ws/test',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _isConnected ? null : _reconnect,
                        child: Text('Connect'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          
          // Connection Status
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: _isConnected ? Colors.green.shade100 : Colors.red.shade100,
            child: Row(
              children: [
                Icon(
                  _isConnected ? Icons.check_circle : Icons.error,
                  color: _isConnected ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  _isConnected ? 'Connected to WebSocket' : 'Disconnected',
                  style: TextStyle(
                    color: _isConnected ? Colors.green.shade800 : Colors.red.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (!_isConnected)
                  ElevatedButton(
                    onPressed: _reconnect,
                    child: const Text('Reconnect'),
                  ),
              ],
            ),
          ),
          
          // Messages Display
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  Color textColor = Colors.black87;
                  FontWeight fontWeight = FontWeight.normal;
                  
                  if (message.contains('Error:')) {
                    textColor = Colors.red;
                    fontWeight = FontWeight.bold;
                  } else if (message.contains('Connected') || message.contains('Welcome') || message.contains('Sent:')) {
                    textColor = Colors.green.shade700;
                    fontWeight = FontWeight.w500;
                  } else if (message.contains('MQTT:')) {
                    textColor = Colors.blue.shade700;
                    fontWeight = FontWeight.w500;
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      message,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: fontWeight,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Message Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isConnected ? _sendMessage : null,
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 