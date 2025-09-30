import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import '../utils/app_urls.dart';

class AWSIoTService {
  late MqttBrowserClient client;
  Function(String message)? onMessageReceived;

  Future<void> connect(String topic, {String? presignedUrl}) async {
    const String defaultEndpoint =
        'wss://a1t8p573k2ghg7-ats.iot.ap-south-1.amazonaws.com/mqtt';
    final String endpoint = presignedUrl ?? defaultEndpoint;

    client = MqttBrowserClient(endpoint, AppUrls.AWS_IOT_CLIENT_ID);
    client.port = 443;
    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.setProtocolV311();

    client.websocketProtocols = const ['mqtt'];
    client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(AppUrls.AWS_IOT_CLIENT_ID)
        .startClean()
        .keepAliveFor(20)
        .withWillQos(MqttQos.atMostOnce);

    // AWS IoT over WebSockets on web requires SigV4 auth; client certs are not
    // supported in browsers. Ensure your AWS IoT policy allows SigV4 and you
    // provide presigned URL or custom headers via connectionMessage if needed.

    client.onConnected = () {
      print("connected");
    };
    client.onDisconnected = () { print("disconnected");};
    client.onSubscribed = (_) {};

    try {
      await client.connect();
    } catch (_) {
      client.disconnect();
      return;
    }

    _subscribeDefaults();
  }

  void _subscribeDefaults() {
    client.subscribe('ecg_data/stethoscope', MqttQos.atMostOnce);
    client.subscribe('ecg_data/SPO2', MqttQos.atLeastOnce);
    client.subscribe('ecg_data/temperature', MqttQos.atLeastOnce);
    client.subscribe('ecg_data/ecg', MqttQos.atLeastOnce);
    client.subscribe('audio/raw-data', MqttQos.atLeastOnce);

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> events) {
      if (events.isEmpty) return;
      final MqttPublishMessage pub = events.first.payload as MqttPublishMessage;
      final String msg =
          MqttPublishPayload.bytesToStringAsString(pub.payload.message);
      onMessageReceived?.call(msg);
    });
  }
}

