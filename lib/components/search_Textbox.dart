import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;

import '../theme/apptheme.dart';
import '../utils/constant.dart';

class search_textbox extends StatelessWidget {
  final String hintText;

  var iconSuf;
  var iconPref;
  var onTap;
  bool autofocus;
  var focus;
  var onTapText;
  bool readOnly;
  final Function(String) onChanged;
    final Function(String) onsubmit;
  final TextEditingController? textEditingController;

  search_textbox(
      {super.key,
      this.onTap,
      required this.onsubmit,
      this.onTapText,
      this.focus,
      this.readOnly = false,
      this.autofocus = false,
      required this.hintText,
      this.iconPref,
      this.iconSuf,
      this.textEditingController,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      onTap: onTapText, focusNode: focus,
      textInputAction: TextInputAction.search,
      //readOnly: readOnly,
      //   if (_serach.text != "") {
      //     Get.to(
      //       SearchDetail(
      //         searchText: _serach.text,
      //       ),
      //       arguments: [_serach.text],
      //       fullscreenDialog: true,
      //       transition: Transition.fadeIn,
      //       duration: const Duration(milliseconds: 200),
      //       curve: Curves.easeInBack,
      //     );
      //   }
      // },

      autofocus: autofocus,
      cursorColor: AppTheme.blackColor,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(
        fontSize: 14,color: Colors.black
      ),
      onSubmitted: onsubmit,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: iconPref,
        contentPadding: EdgeInsets.all(16),
        isDense: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).hoverColor,
            width: 0,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).hoverColor,
            width: 0,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Theme.of(context).hoverColor,
            width: 0,
          ),
        ),
        hintStyle: GoogleFonts.rubik(
                  fontSize: Constant.smallbody(context),
                  color: AppTheme.lightHintTextColor,
                  fontWeight: FontWeight.w400),
        suffixIcon: InkWell(
          onTap: onTap,
          child: Icon(Icons.search),
        ),
        prefixIconColor: Theme.of(context).textTheme.displaySmall!.color,
        suffixIconColor: Theme.of(context).textTheme.displaySmall!.color,
        filled: true,
        fillColor: Colors.white,
        //  fillColor: Theme.of(context).hoverColor,
        hintText: hintText,
      ),
    );
  }
}
