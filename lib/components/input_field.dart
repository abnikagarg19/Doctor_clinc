import 'package:chatbot/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/apptheme.dart';

class MyTextField extends StatelessWidget {
  String hintText;
  String labelText;
  var color;
  var icon;
  var preicon;
  bool readOnly;
  var validation;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  var ontap;
  var ontapSuffix;
  final bool obsecureText;
  final bool isfilled;
  final bool isSuffixIcon;
  final TextEditingController? textEditingController;
  MyTextField(
      {super.key,
      required this.hintText,
      this.labelText = "",
      required this.color,
      this.icon,
      this.ontapSuffix,
      this.obsecureText = false,
      this.isSuffixIcon = false,
      this.readOnly = false,
      this.preicon,
      this.ontap,
      this.isfilled = true,
      this.textInputType,
      this.inputFormatters,
      this.textEditingController,
      this.validation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4, bottom: 8),
      child: TextFormField(
          keyboardType: textInputType,
          onTap: ontap,
          readOnly: readOnly,
          inputFormatters: inputFormatters,
          controller: textEditingController,
          obscureText: obsecureText,
          validator: validation,
          cursorColor: AppTheme.lightPrimaryColor,
          style: GoogleFonts.roboto(fontSize: 14),
          decoration: InputDecoration(
              labelStyle: GoogleFonts.rubik(
                  fontSize: Constant.largeBody(context),
                  color: AppTheme.hintTextColor,
                  fontWeight: FontWeight.w400),
              counterText: '',
              labelText: labelText,
              errorStyle: GoogleFonts.roboto(fontSize: 12),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              floatingLabelAlignment: FloatingLabelAlignment.start,
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromRGBO(225, 30, 61, 1),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(100.0),
              ),
              //  prefixIcon: preicon,
              prefixIcon: preicon,
              // fillColor: Color.fromRGBO(255, 255, 255, 0.6),
              // filled: isfilled, 
              hintStyle: GoogleFonts.rubik(
                  fontSize: Constant.smallbody(context),
                  color: AppTheme.lightHintTextColor,
                  fontWeight: FontWeight.w400),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromRGBO(117, 117, 117, 1),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromRGBO(117, 117, 117, 1),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(
                      color: Color.fromRGBO(117, 117, 117, 1), width: 1)),

              // filled: true,
              //  fillColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              hintText: hintText,
              floatingLabelStyle: GoogleFonts.rubik(
                  fontSize: Constant.largeBody(context),
                  color: AppTheme.blackColor,
                  fontWeight: FontWeight.w500),
              suffixIcon: isSuffixIcon
                  ? GestureDetector(
                      child: !obsecureText
                          ? Icon(
                              Icons.visibility_off,
                              size: 18,
                              color: Colors.grey,
                            )
                          : Icon(
                              Icons.visibility,
                              size: 18,
                              color: Colors.grey,
                            ),
                      onTap: ontapSuffix,
                    )
                  : icon)),
    );
  }
}
