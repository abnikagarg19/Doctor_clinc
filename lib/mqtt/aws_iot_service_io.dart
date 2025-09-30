import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../utils/app_urls.dart';

class AWSIoTService {
  late MqttServerClient client;
  Function(String message)? onMessageReceived;

  Future<void> connect(String topic, {String? presignedUrl}) async {
    const String endpoint =
        'a1t8p573k2ghg7-ats.iot.ap-south-1.amazonaws.com';

    client = MqttServerClient.withPort(endpoint, AppUrls.AWS_IOT_CLIENT_ID, 8883);
    client.secure = true;
    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.setProtocolV311();

    final ByteData rootCa =
        await rootBundle.load('assets/aws_jul_25/AmazonRootCA1.pem');
    final ByteData deviceCrt = await rootBundle.load(
        'assets/aws_jul_25/2538f8d29c441136f25f93c4026690bad9c5ed6b6e1224565f78f1ca6aa70c2b-certificate.pem.crt');
    final ByteData privateKey = await rootBundle.load(
        'assets/aws_jul_25/2538f8d29c441136f25f93c4026690bad9c5ed6b6e1224565f78f1ca6aa70c2b-private.pem.key');

    final SecurityContext context = SecurityContext(withTrustedRoots: false);
    context.useCertificateChainBytes(deviceCrt.buffer.asUint8List());
    context.usePrivateKeyBytes(privateKey.buffer.asUint8List());
    context.setClientAuthoritiesBytes(rootCa.buffer.asUint8List());
    client.securityContext = context;

    client.onConnected = () {
      print("connected");
    };
    client.onDisconnected = () {};
    client.onSubscribed = (_) {};

    client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(AppUrls.AWS_IOT_CLIENT_ID)
        .startClean()
        .keepAliveFor(20)
        .withWillQos(MqttQos.atMostOnce);

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

