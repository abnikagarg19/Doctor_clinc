import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/apptheme.dart';
import '../utils/constant.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton(
      {super.key,
      required this.title,
      required this.backgroundColor,      required this.textColor,
      this.borderRadius = 50});

  final String title;
  Color backgroundColor;
  Color textColor;
  double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(132, 149, 147, 147),
            spreadRadius: 1,
            offset: const Offset(0, 6),
            blurRadius: 10,
          )
        ],
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        title,
        style: GoogleFonts.rubik(
          color:textColor,
          fontSize: Constant.smallbody(context),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
