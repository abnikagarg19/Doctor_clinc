import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/apptheme.dart';
import '../../../utils/constant.dart';

class UploadInputFeild extends StatelessWidget {
  final String hintText;
  final String? selectedFileName;
  final VoidCallback onUploadPressed;
  final bool showError;

  const UploadInputFeild({
    Key? key,
    this.hintText = "Doc name",
    this.selectedFileName,
    required this.onUploadPressed,
    this.showError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isInvalid = showError && selectedFileName == null;

    return Column(
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: isInvalid
                  ? Colors.red
                  : const Color.fromRGBO(117, 117, 117, 1),
              width: isInvalid ? 2.0 : 1.0,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 30),
              Expanded(
                // 3. Update the Text widget to be dynamic
                child: Text(
                  selectedFileName ?? hintText, // Show file name or hint text
                  overflow: TextOverflow
                      .ellipsis, // Prevent long names from overflowing
                  style: GoogleFonts.rubik(
                    fontSize: Constant.mediumbody(context),
                    // Change color based on whether a file is selected
                    color: selectedFileName != null
                        ? AppTheme
                            .blackColor // Or whatever your main text color is
                        : AppTheme.lightHintTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // 4. Wrap the button in a GestureDetector to make it tappable
              GestureDetector(
                onTap: onUploadPressed, // Call the function when tapped
                child: Container(
                  width: 150,
                  height: 60,
                  decoration: BoxDecoration(
                      color: AppTheme.lightPrimaryColor,
                      borderRadius: const BorderRadius.only(
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
                ),
              )
            ],
          ),
        ),
        if (isInvalid)
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 8.0),
            child: Text(
              'Required',
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
