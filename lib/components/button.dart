import 'package:chatbot/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/apptheme.dart';

class Button extends StatelessWidget {
  Button({super.key, required this.tittle, this.tap});
  final String tittle;
  var tap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme.lightPrimaryColor,
              // gradient: LinearGradient(
              //   colors: [
              //     Color(0XFF77CCFF),
              //     Color(0XFF55AAFF),
              //     Color(0XFF3388FF),
              //     Color(0XFF0066FF),
              //     Color(0XFF0044FF),
              //     // const Colo
              //   ],

                //       begin: Alignment(-1.0, -1.0),
                // end: Alignment(2.0, 4.0),)
             /// ),
              borderRadius: BorderRadius.circular(100)),
          child: Center(
            child: Text(
                      tittle,
                      style: GoogleFonts.inter(
                          fontSize: Constant.mediumbody(context),
                          color: AppTheme.whiteBackgroundColor,
                          fontWeight: FontWeight.w500),
                    
            ),
          )),
    );
  }
}
