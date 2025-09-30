import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothJsonViewer extends StatefulWidget {
  @override
  _BluetoothJsonViewerState createState() => _BluetoothJsonViewerState();
}

class _BluetoothJsonViewerState extends State<BluetoothJsonViewer> {
  List<ScanResult> scanResults = [];
  bool isScanning = false;
  BluetoothDevice? connectedDevice;
  List<BluetoothService> services = [];
  Map<String, List<String>> receivedData = {}; // uuid -> list of decoded strings

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();
  }

  void startScan() {
    scanResults.clear();
    FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        scanResults = results;
      });
    });
    setState(() {
      isScanning = true;
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await FlutterBluePlus.stopScan();
    setState(() {
      isScanning = false;
    });

    try {
      await device.connect();
    } catch (_) {
      print("Device might already be connected.");
    }

    setState(() {
      connectedDevice = device;
    });

    services = await device.discoverServices();
    receivedData.clear();

    for (var service in services) {
      for (var characteristic in service.characteristics) {
        final uuid = characteristic.uuid.toString();
        receivedData[uuid] = [];

        if (characteristic.properties.read) {
          var value = await characteristic.read();
          _handleIncomingValue(uuid, value);
        }

        if (characteristic.properties.notify) {
          await characteristic.setNotifyValue(true);
          characteristic.lastValueStream.listen((value) {
            _handleIncomingValue(uuid, value);
          });
        }
      }
    }
  }

  void _handleIncomingValue(String uuid, List<int> value) {
    try {
      String decoded = String.fromCharCodes(value);
      String display = decoded;

      // Try JSON decode
      if (decoded.trim().startsWith("{")) {
        final jsonMap = jsonDecode(decoded);
        display = jsonMap.entries
            .map((e) => "${e.key}: ${e.value}")
            .join(" | ");
      }

      setState(() {
        receivedData[uuid]?.add(display);
      });
    } catch (e) {
      setState(() {
        receivedData[uuid]?.add("Invalid UTF-8 or JSON: $value");
      });
    }
  }

  Widget buildDeviceList() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: isScanning ? null : startScan,
          child: Text(isScanning ? "Scanning..." : "Scan Devices"),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: scanResults.length,
            itemBuilder: (context, index) {
              final device = scanResults[index].device;
              return ListTile(
                title: Text(device.name.isNotEmpty ? device.name : "Unknown"),
                subtitle: Text(device.id.toString()),
                onTap: () => connectToDevice(device),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildDataViewer() {
    return Column(
      children: [
        ListTile(
          title: Text("Connected to: ${connectedDevice?.name}"),
          subtitle: Text(connectedDevice?.id.toString() ?? ""),
        ),
        Expanded(
          child: ListView(
            children: receivedData.entries.map((entry) {
              final uuid = entry.key;
              final values = entry.value;

              return ExpansionTile(
                title: Text('Characteristic: $uuid'),
                children: values.reversed
                    .take(5)
                    .map((v) => ListTile(
                          dense: true,
                          title: Text(v),
                        ))
                    .toList(),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bluetooth JSON Viewer')),
      body: connectedDevice == null ? buildDeviceList() : buildDataViewer(),
    );
  }
}
