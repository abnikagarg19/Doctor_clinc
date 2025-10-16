import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/apptheme.dart';
import '../../../utils/constant.dart';

buildLable(context, title, {bool isRequired = true}) {
  return Row(
    children: [
      SizedBox(
        width: 6,
      ),
      Container(
        height: 4,
        width: 4,
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: AppTheme.blackColor),
      ),
      SizedBox(
        width: 12,
      ),
      // Text("$title",
      //     style: GoogleFonts.rubik(
      //       color: AppTheme.blackColor,
      //       fontSize: Constant.mediumbody(context),
      //       fontWeight: FontWeight.w500,
      //     )),
      RichText(
        text: TextSpan(
          style: GoogleFonts.rubik(
            color: AppTheme.blackColor,
            fontSize: Constant.smallbody(context),
            fontWeight: FontWeight.w400,
          ),
          children: <TextSpan>[
            TextSpan(text: title),
            if (isRequired)
              const TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      )
    ],
  );
}
