import 'package:chatbot/controller/signupController.dart';
import 'package:chatbot/view/onboard/components/upload_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../components/input_field.dart' show MyTextField;
import '../../../theme/apptheme.dart';
import '../../../utils/constant.dart';
import 'label_common.dart';

class ProfessionalForm extends StatelessWidget {
  const ProfessionalForm({
    super.key,
    required this.controller,
  });

  final SignUpController controller;

  @override
  Widget build(BuildContext context) {
    // Wrap the form with GetBuilder to make it reactive to file selections
    return GetBuilder<SignUpController>(
      builder: (ctrl) {
        // Use 'ctrl' to refer to the controller inside the builder
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align labels to the left
            children: [
              // --- Medical Registration Fields ---
              buildLable(context, "Medical Registration Number"),
              SizedBox(height: 8),
              MyTextField(
                  textEditingController: ctrl.medicalRegNoController,
                  validation: (v) => v!.isEmpty ? 'Required' : null,
                  hintText: "Enter your number",
                  color: const Color(0xff585A60)),

              SizedBox(height: 20),

              buildLable(context,
                  "Medical Council Name (e.g., MCI / NMC / State Council)"),
              SizedBox(height: 8),
              MyTextField(
                textEditingController: ctrl.medicalCouncilController,
                validation: (v) => v!.isEmpty ? 'Required' : null,
                hintText:
                    'Medical Council Name (e.g., MCI / NMC / State Council)',
                color: const Color(0xff585A60),
              ),
              SizedBox(height: 20),

              buildLable(context, "State of Registration"),
              SizedBox(height: 8),
              MyTextField(
                textEditingController: ctrl.stateOfRegController,
                validation: (v) => v!.isEmpty ? 'Required' : null,
                hintText: 'Choose your state',
                color: const Color(0xff585A60),
              ),
              SizedBox(height: 20),

              buildLable(context, "Year of Registration"),
              SizedBox(height: 8),
              MyTextField(
                textEditingController: ctrl.yearOfRegController,
                validation: (v) => v!.isEmpty ? 'Required' : null,
                hintText: 'YYYY',
                color: const Color(0xff585A60),
              ),
              SizedBox(height: 20),

              // --- Dynamic File Upload Fields ---

              buildLable(context, "Degree Certificates (MBBS, MD, etc.)"),
              SizedBox(height: 8),
              UploadInputFeild(
                selectedFileName: ctrl.degreeCertificate?.name,
                onUploadPressed: () =>
                    ctrl.pickFile((file) => ctrl.degreeCertificate = file),
                showError: ctrl.formSubmitted && ctrl.degreeCertificate == null,
              ),
              SizedBox(height: 8),
              _buildHelperText(context),
              SizedBox(height: 20),

              buildLable(context, "Medical Council Registration Certificate"),
              SizedBox(height: 8),
              UploadInputFeild(
                selectedFileName: ctrl.medicalCouncilCertificate?.name,
                onUploadPressed: () => ctrl
                    .pickFile((file) => ctrl.medicalCouncilCertificate = file),
                showError: ctrl.formSubmitted &&
                    ctrl.medicalCouncilCertificate == null,
              ),
              SizedBox(height: 8),
              _buildHelperText(context),
              SizedBox(height: 20),

              buildLable(context, "Govt ID Proof (Aadhaar, PAN, Passport)"),
              SizedBox(height: 8),
              UploadInputFeild(
                selectedFileName: ctrl.govtIdProof?.name,
                onUploadPressed: () =>
                    ctrl.pickFile((file) => ctrl.govtIdProof = file),
                showError: ctrl.formSubmitted && ctrl.govtIdProof == null,
              ),
              SizedBox(height: 8),
              _buildHelperText(context),
              SizedBox(height: 20),

              buildLable(context, "Photo (passport-size, professional)"),
              SizedBox(height: 8),
              UploadInputFeild(
                selectedFileName: ctrl.photo?.name,
                onUploadPressed: () =>
                    ctrl.pickFile((file) => ctrl.photo = file),
                showError: ctrl.formSubmitted && ctrl.photo == null,
              ),
              SizedBox(height: 8),
              _buildHelperText(context),
              SizedBox(height: 20),

              buildLable(context, "Signature Scan"),
              SizedBox(height: 8),
              UploadInputFeild(
                selectedFileName: ctrl.signatureScan?.name,
                onUploadPressed: () =>
                    ctrl.pickFile((file) => ctrl.signatureScan = file),
                showError: ctrl.formSubmitted && ctrl.signatureScan == null,
              ),
              SizedBox(height: 8),
              _buildHelperText(context),
            ],
          ),
        );
      },
    );
  }

  // Helper widget to avoid code repetition
  Widget _buildHelperText(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Text("Only in pdf format,Max. of 10 MB",
          style: GoogleFonts.rubik(
            color: AppTheme.lightHintTextColor,
            fontSize: Constant.verysmallbody(context),
            fontWeight: FontWeight.w300,
          )),
    );
  }
}
