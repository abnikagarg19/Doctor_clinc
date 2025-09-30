import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/apptheme.dart';
import '../../../utils/constant.dart';

class UploadInputFeild extends StatelessWidget {
  const UploadInputFeild({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      // padding: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
              color: Color.fromRGBO(117, 117, 117, 1), width: 1)),
      child: Row(
        children: [
          SizedBox(
            width: 30,
          ),
          Expanded(
            child: Text(
              "Doc name",
              style: GoogleFonts.rubik(
                  fontSize: Constant.mediumbody(context),
                  color: AppTheme.lightHintTextColor,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Container(
            width: 150,
            height: 60,
            decoration: BoxDecoration(
                color: AppTheme.lightPrimaryColor,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(100),
                    topRight: Radius.circular(100))),
            child: Center(
              child: Text(
                "Upload",
                style: GoogleFonts.rubik(
                    fontSize: Constant.mediumbody(context),
                    color: AppTheme.whiteTextColor,
                    fontWeight: FontWeight.w400),
              ),
            ),
          )
        ],
      ),
    );
  }
}
