import 'package:chatbot/utils/constant.dart' show Constant;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/apptheme.dart';

class ReusableDropdown<T> extends StatelessWidget {
  String selectedItem;
  final Function(String?) onChanged;
  var validation;
  final String? hintText;
  String? mapkey;
  String? mapvalue;
  List<String> listmap;
  ReusableDropdown({
    Key? key,
    required this.selectedItem,
    required this.onChanged,
    this.mapkey = "key",
    this.mapvalue = "value",
    this.hintText,
    required this.listmap,
    this.validation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: selectedItem == "" ? null : selectedItem,
      onChanged: onChanged,
      hint: hintText != null
          ? Text(
              hintText!,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            )
          : null,
      items: listmap
          .map((option) => DropdownMenuItem(
                value: option,
                child: Text(option),
              ))
          .toList(),
      validator: validation,
      decoration: InputDecoration(
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
            borderSide:
                BorderSide(color: Color.fromRGBO(117, 117, 117, 1), width: 1)),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      
      iconEnabledColor: Colors.black,
      dropdownColor: Colors.white,
    );
  }
}
