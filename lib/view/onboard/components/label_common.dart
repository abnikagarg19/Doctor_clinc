import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/apptheme.dart';
import '../../../utils/constant.dart';

buildLable(context,title ) {
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
      Text("$title",
          style: GoogleFonts.rubik(
            color: AppTheme.blackColor,
            fontSize: Constant.mediumbody(context),
            fontWeight: FontWeight.w500,
          )),
    ],
  );
}
