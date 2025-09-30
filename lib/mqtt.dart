// ignore_for_file: unused_import
import 'package:chatbot/theme/apptheme.dart' show AppTheme;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:just_audio/just_audio.dart';
import 'mqtt/aws_iot_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'utils/app_urls.dart';

// Platform-specific AWS IoT MQTT service is provided via conditional export
// from mqtt/aws_iot_service.dart. See implementations in:
// - mqtt/aws_iot_service_io.dart (mobile/desktop)
// - mqtt/aws_iot_service_web.dart (web)

class IoTDashboard extends StatefulWidget {
  const IoTDashboard({Key? key}) : super(key: key);

  @override
  State<IoTDashboard> createState() => _IoTDashboardState();
}

class _IoTDashboardState extends State<IoTDashboard> {
  final AWSIoTService _awsIoTService = AWSIoTService();
  String message = 'Waiting for message...';

  final String topic =
      'ecg_data/stethoscope'; // 🔁 Replace with your topic name

  @override
  void initState() {
    super.initState();

    _awsIoTService.onMessageReceived = (msg) {
      setState(() {
        message = msg;
      });
    };

    if (kIsWeb && AppUrls.AWS_IOT_PRESIGNED_URL.isNotEmpty) {
      _awsIoTService.connect(topic, presignedUrl: AppUrls.AWS_IOT_PRESIGNED_URL);
    } else {
      _awsIoTService.connect(topic);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              GestureDetector(onTap: () {}, child: const Text('Patient Data'))),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
                Text("EHRid",
                    style: GoogleFonts.quicksand(
                        color: Color.fromRGBO(89, 89, 89, 0.8),
                        fontSize: 18,
                        height: 0,
                        fontWeight: FontWeight.w500)),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(bottom: 2),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Color.fromRGBO(195, 195, 195, 1)))),
                  child: Text("027",
                      style: GoogleFonts.quicksand(
                          color: AppTheme.blackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text("Name",
                    style: GoogleFonts.quicksand(
                        color: Color.fromRGBO(89, 89, 89, 0.8),
                        fontSize: 18,
                        height: 0,
                        fontWeight: FontWeight.w500)),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(bottom: 2),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Color.fromRGBO(195, 195, 195, 1)))),
                  child: Text("Climent",
                      style: GoogleFonts.quicksand(
                          color: AppTheme.blackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text("Age",
                    style: GoogleFonts.quicksand(
                        color: Color.fromRGBO(89, 89, 89, 0.8),
                        fontSize: 18,
                        height: 0,
                        fontWeight: FontWeight.w500)),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(bottom: 2),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Color.fromRGBO(195, 195, 195, 1)))),
                  child: Text("29",
                      style: GoogleFonts.quicksand(
                          color: AppTheme.blackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text("Blood\nPressure ",
                    style: GoogleFonts.quicksand(
                        color: Color.fromRGBO(89, 89, 89, 0.8),
                        fontSize: 18,
                        height: 0,
                        fontWeight: FontWeight.w500)),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(bottom: 2),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Color.fromRGBO(195, 195, 195, 1)))),
                  child: Text("29",
                      style: GoogleFonts.quicksand(
                          color: AppTheme.blackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                )),
                Text("SpO2",
                    style: GoogleFonts.quicksand(
                        color: Color.fromRGBO(89, 89, 89, 0.8),
                        fontSize: 18,
                        height: 0,
                        fontWeight: FontWeight.w500)),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(bottom: 2),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Color.fromRGBO(195, 195, 195, 1)))),
                  child: Text("29",
                      style: GoogleFonts.quicksand(
                          color: AppTheme.blackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text("Blood\nGlucose ",
                    style: GoogleFonts.quicksand(
                        color: Color.fromRGBO(89, 89, 89, 0.8),
                        fontSize: 18,
                        height: 0,
                        fontWeight: FontWeight.w500)),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(bottom: 2),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Color.fromRGBO(195, 195, 195, 1)))),
                  child: Text("29",
                      style: GoogleFonts.quicksand(
                          color: AppTheme.blackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                )),
                Text("Temperature",
                    style: GoogleFonts.quicksand(
                        color: Color.fromRGBO(89, 89, 89, 0.8),
                        fontSize: 18,
                        height: 0,
                        fontWeight: FontWeight.w500)),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(bottom: 2),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Color.fromRGBO(195, 195, 195, 1)))),
                  child: Text("29",
                      style: GoogleFonts.quicksand(
                          color: AppTheme.blackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text("ECG",
                style: GoogleFonts.quicksand(
                    color: AppTheme.blackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
