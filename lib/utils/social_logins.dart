import 'package:flutter/material.dart';

import '../../../theme/apptheme.dart';

class SocialLogin extends StatelessWidget {
  final String assets;
  final Function() onTap;
  final String webview;
  const SocialLogin({
    super.key,
    required this.assets,
    required this.onTap,
    required this.webview,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.whiteTextColor,
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
