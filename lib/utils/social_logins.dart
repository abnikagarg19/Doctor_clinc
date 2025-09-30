import 'package:chatbot/utils/constant.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/apptheme.dart';

class SocialLogin extends StatelessWidget {
  final String assets;

  final String webview;
  const SocialLogin({
    super.key,
    required this.assets,
    required this.webview,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            shape: BoxShape.circle,color: AppTheme.whiteTextColor,
           ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              assets,
            height: 30,
              color: webview == "apple" ? Colors.white : null,
            ),
          ],
        ),
      ),
    );
  }
}
