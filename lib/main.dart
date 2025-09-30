import 'package:chatbot/mqtt.dart' show IoTDashboard;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'bindings.dart/init.dart';
import 'example.dart';
import 'service/shared_pref.dart';
import 'theme/apptheme.dart';
import 'utils/app_routes.dart';
import 'view/ai.dart';
import 'view/chat/chat.dart';
import 'view/chat/doctor_page.dart';
import 'view/start_ai.dart';
import 'view/websocket_page.dart';

void main() async {
  //calling DependencyInjection init method
  WidgetsFlutterBinding.ensureInitialized();

  await PreferenceUtils.init();
  requestPermission();
  runApp(const MyApp());
}

Future<void> requestPermission() async {
  //if (GetPlatform.isAndroid) {
    final status = await Permission.microphone.request();
    final status2 = await Permission.camera.request();
 // } else {
    //   final permissionss = await window.navigator
    //       .getUserMedia(
    //         audio: true,
    //       )
    //       .then((value) => true);
    //  print('permissionss $permissionss');
 // }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Chat Bot",
      debugShowCheckedModeBanner: false,
      // theme: AppTheme.darktheme,
      builder: FToastBuilder(),
      //  theme: ThemeService().theme,
      theme: AppTheme.lightTheme,

      themeMode: ThemeMode.light,

         initialRoute: AppPages.INITIAL,
       getPages: AppPages.routes,
     // home: VoiceChat(),
    );
  }
}
