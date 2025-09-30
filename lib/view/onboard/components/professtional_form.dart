import 'package:chatbot/controller/signupController.dart';
import 'package:chatbot/view/onboard/components/upload_input.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../components/input_field.dart' show MyTextField;
import '../../../theme/apptheme.dart';
import '../../../utils/constant.dart';
import 'label_common.dart';

class ProfesstionalForm extends StatelessWidget {
  const ProfesstionalForm({
    super.key,
    required this.controller,
  });
  final SignUpController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          buildLable(context, "Medical Registration Number"),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.medicalRegNoController,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                  // }
                }
                return null;
              },
              hintText: "Enter your number",
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
          buildLable(context,
              "Medical Council Name (e.g., MCI / NMC / State Council)"),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.medicalCouncilController,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              hintText:
                  'Medical Council Name (e.g., MCI / NMC / State Council)',
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "State of Registration"),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.stateOfRegController,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppTheme.lightHintTextColor,
              ),
              hintText: 'Choose your state',
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Year of Registration"),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.yearOfRegController,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              readOnly: true,
              ontap: () {
                // Call this in the select year button.

             },
              hintText: 'YYYY',
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Degree Certificates (MBBS, MD, etc.)"),
          SizedBox(
            height: 8,
          ),
          UploadInputFeild(),
          SizedBox(
            height: 8,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text("Only in pdf format,Max. of 10 MB",
                style: GoogleFonts.rubik(
                  color: AppTheme.lightHintTextColor,
                  fontSize: Constant.verysmallbody(context),
                  fontWeight: FontWeight.w300,
                )),
          ),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Medical Council Registration Certificate"),
          SizedBox(
            height: 8,
          ),
          UploadInputFeild(),
          SizedBox(
            height: 8,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text("Only in pdf format,Max. of 10 MB",
                style: GoogleFonts.rubik(
                  color: AppTheme.lightHintTextColor,
                  fontSize: Constant.verysmallbody(context),
                  fontWeight: FontWeight.w300,
                )),
          ),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Govt ID Proof (Aadhaar, PAN, Passport)"),
          SizedBox(
            height: 8,
          ),
          UploadInputFeild(),
          SizedBox(
            height: 8,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text("Only in pdf format,Max. of 10 MB",
                style: GoogleFonts.rubik(
                  color: AppTheme.lightHintTextColor,
                  fontSize: Constant.verysmallbody(context),
                  fontWeight: FontWeight.w300,
                )),
          ),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Photo (passport-size, professional)"),
          SizedBox(
            height: 8,
          ),
          UploadInputFeild(),
          SizedBox(
            height: 8,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text("Only in pdf format,Max. of 10 MB",
                style: GoogleFonts.rubik(
                  color: AppTheme.lightHintTextColor,
                  fontSize: Constant.verysmallbody(context),
                  fontWeight: FontWeight.w300,
                )),
          ),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Signature Scan"),
          SizedBox(
            height: 8,
          ),
          UploadInputFeild(),
          SizedBox(
            height: 8,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text("Only in pdf format,Max. of 10 MB",
                style: GoogleFonts.rubik(
                  color: AppTheme.lightHintTextColor,
                  fontSize: Constant.verysmallbody(context),
                  fontWeight: FontWeight.w300,
                )),
          )
        ],
      ),
    );
  }
}
