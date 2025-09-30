import 'package:chatbot/view/ai.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/button.dart';

class AiStart extends StatelessWidget {
  const AiStart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
         width: 200,
          child: Button(
              tittle: "Start AI",
              tap: () {
                Get.to(AiPage());
                // if (loginformKey.currentState!
                //     .validate()) {
                //   //   Get.to(AiChatBot());
                //   _controller.signUp();
                // }
              }),
        ),
      ),
    );
  }
}
