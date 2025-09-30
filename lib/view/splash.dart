import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/splashController.dart';

class SplashScreen extends GetView<splashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              controller.image,
              height: 100,
            ),
           
          ],
        ),
      ),
    );
  }
}
