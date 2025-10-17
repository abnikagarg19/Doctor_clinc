import 'dart:convert';

import 'package:chatbot/service/auth_service.dart';
import 'package:chatbot/utils/custom_print.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../components/commons.dart';
import '../service/shared_pref.dart';
import '../utils/app_routes.dart';
import '../view/onboard/onboard.dart';
import '../view/otp_page.dart';

class SignUpController extends GetxController {
  final password = TextEditingController();
  final confirmpassword = TextEditingController();
  final otpController = TextEditingController();
  List onBoard = [
    "1. Personal & Contact Information",
    "2. Professional Credentials",
    "3. Experience & Specialization",
    "4. Consultation Preferences",
    "5. Banking & Payments (for payouts)",
    "6. Other (Optional but Useful) "
  ];
  // Personal Info
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  List<String> genderOptions = ["Male", "Female", "Other"];
  String gender = '';
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final emergencyContactController = TextEditingController();
  DateTime? selectedDOB;

  // Registration
  final medicalRegNoController = TextEditingController();
  final medicalCouncilController = TextEditingController();
  final stateOfRegController = TextEditingController();
  final yearOfRegController = TextEditingController();

  // Experience
  final yearOfPracticeController = TextEditingController();
  final specializationController = TextEditingController();
  final subspecialtiesController = TextEditingController();
  final previousCompanyController = TextEditingController();
  final shortBioController = TextEditingController();
  final languageSpoken = TextEditingController();

  // Availability
  List<String> selectedDays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  final availableFromController = TextEditingController();
  final availableToController = TextEditingController();
  final consultationDurationController = TextEditingController();
  final consultationFeeController = TextEditingController();
  List selectedModes = [];
  final List modeOptions = ["Online", "Chat", "Offline"];
  bool emergencyAvailable = false;

  // Bank Details
  final accHolderController = TextEditingController();
  final bankNameController = TextEditingController();
  final accNumberController = TextEditingController();
  final ifscController = TextEditingController();
  final panCardController = TextEditingController();
  final gstinController = TextEditingController();
  final upiIdController = TextEditingController();

  /// images
  PlatformFile? degreeCertificate;
  PlatformFile? medicalCouncilCertificate;
  PlatformFile? govtIdProof;
  PlatformFile? photo;
  PlatformFile? signatureScan;

  // Consent
  bool telemedGuidelines = false;
  bool termsCondition = false;
  final publicationsController = TextEditingController();
  final linkedinController = TextEditingController();
  bool consentTelconsult = false;
  final refDocController = TextEditingController();
  final digitalSignatureController = TextEditingController();
  final profWebsiteController = TextEditingController();
  bool malpracticeInsurance = false;
  final awardController = TextEditingController();
  bool isRemember = false;
  var passwordLoginVisibility = false;
  void showPassword() {
    passwordLoginVisibility = !passwordLoginVisibility;
    update();
  }

  var passwordLoginVisibility2 = false;
  void showPassword2() {
    passwordLoginVisibility2 = !passwordLoginVisibility2;
    update();
  }

  final service = AuthService();
  int currentStep = 0;
  bool formSubmitted = false;

  void goToNextStep(GlobalKey<FormState> formKey) {
    formSubmitted = true;
    update();
    const int professionalFormStepIndex = 1;
    bool isProfessionalFormStep = (currentStep == professionalFormStepIndex);
    bool filesAreValid = !isProfessionalFormStep || _areAllFilesPicked();

    bool isFormValid = formKey.currentState!.validate() && filesAreValid;

    if (isFormValid) {
      if (currentStep < onBoard.length - 1) {
        currentStep++;
        formSubmitted = false;
        update();
      } else {
        onboardDoctor();
      }
    } else {
      DialogHelper.showErroDialog(
        description: "Please fill all required fields.",
      );
    }
  }

  void goToPreviousStep() {
    if (currentStep > 0) {
      currentStep--;
      update();
    }
  }

  bool _areAllFilesPicked() {
    return degreeCertificate != null &&
        medicalCouncilCertificate != null &&
        govtIdProof != null &&
        photo != null &&
        signatureScan != null;
  }

  Future<void> pickFile(Function(PlatformFile) onFilePicked) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null) {
      onFilePicked(result.files.single);
      update();
    } else {
      alertPrint("Failed to pick file");
    }
  }

  void onboardDoctor() async {
    ///formated date
    String formattedDob = "";
    if (selectedDOB != null) {
      formattedDob = DateFormat('yyyy-MM-dd').format(selectedDOB!);
    }

    ///formated url
    String formatUrl(String url) {
      if (url.trim().isEmpty) return "";
      if (url.startsWith('http://') || url.startsWith('https://')) return url;
      return 'https://$url';
    }

    ///selected language
    List<String> languages = languageSpoken.text
        .split(',')
        .map((lang) => lang.trim())
        .where((lang) => lang.isNotEmpty)
        .toList();

    final Map<String, dynamic> jsonData = {
      "personal_info": {
        "name": nameController.text,
        "date_of_birth": formattedDob,
        "gender": gender,
        "mobile_number": mobileController.text,
        "email": emailController.text,
        "address": addressController.text,
        "emergency_contact": emergencyContactController.text,
      },
      "registration": {
        "medical_reg_no": medicalRegNoController.text,
        "medical_council": medicalCouncilController.text,
        "state_of_reg": stateOfRegController.text,
        "year_of_reg": int.tryParse(yearOfRegController.text) ?? 0,
      },
      "experience": {
        "year_of_practice": int.tryParse(yearOfPracticeController.text) ?? 0,
        "specialization": specializationController.text,
        "subspecialties": subspecialtiesController.text,
        "previous_company_name": previousCompanyController.text,
        "language_spoken": languages,
        "short_bio": shortBioController.text,
      },
      "availability": {
        "available_days": selectedDays,
        "available_from_time": availableFromController.text,
        "available_to_time": availableToController.text,
        "consultation_duration": consultationDurationController.text,
        "consultation_mode": selectedModes,
        "consultation_fee": int.tryParse(consultationFeeController.text) ?? 0,
        "emergency_consultation_available": emergencyAvailable,
      },
      "bank_details": {
        "account_holder_name": accHolderController.text,
        "bank_name_branch": bankNameController.text,
        "account_number": accNumberController.text,
        "IFSC_code": ifscController.text,
        "pan_card_number": panCardController.text,
        "GSTIN": gstinController.text,
        "upi_id": upiIdController.text,
      },
      "consent": {
        "telemed_guidelines": telemedGuidelines,
        "terms_condition": termsCondition,
        "publications": formatUrl(publicationsController.text),
        "linkedin_profile": formatUrl(linkedinController.text),
        "consent_for_telconsult": consentTelconsult,
        "ref_from_doc": formatUrl(refDocController.text),
        "digital_signature": digitalSignatureController.text,
        "prof_website": formatUrl(profWebsiteController.text),
        "malpratice_insurance": malpracticeInsurance,
        "awards_recog":
            awardController.text.isNotEmpty ? [awardController.text] : [],
      }
    };

    alertPrint("JSON DATA SENT: ${jsonEncode(jsonData)}");
    successPrint("JSON DATA : $jsonData");
    final String dataJsonString = jsonEncode(jsonData);
    DialogHelper.showLoading("Submitting your profile...");

    try {
      final response = await service.apiOnboardDoctor(
        dataJson: dataJsonString,
        degreeCert: degreeCertificate,
        medCouncilCert: medicalCouncilCertificate,
        govtId: govtIdProof,
        photoFile: photo,
        signatureFile: signatureScan,
      );
      DialogHelper.hideLoading();

      if (response.statusCode == 200 || response.statusCode == 201) {
        successPrint("Onboarding successful! $response");
        DialogHelper.showErroDialog(
            title: "Profile Complete!",
            description: "Your profile has been submitted successfully.");
        Get.toNamed(Routes.HOME);
      } else {
        final responseData = jsonDecode(response.body);
        DialogHelper.showErroDialog(
            description: responseData['detail'] ?? 'An error occurred.');
      }
    } catch (e) {
      DialogHelper.hideLoading();
      errorPrint("Onboarding failed: $e");
      DialogHelper.showErroDialog(description: "An unexpected error occurred.");
    }
  }

  // Future<void> signUp() async {
  //   DialogHelper.showLoading();
  //
  //   service.apiSignUpService(emailController.text, password.text).then((value) {
  //     DialogHelper.hideLoading();
  //
  //     try {
  //       var data2 = jsonDecode(value.body);
  //
  //       switch (value.statusCode) {
  //         case 200:
  //           final bool status = data2["status"] ?? false;
  //           final bool isNewUser = data2["is_newuser"] ?? false;
  //
  //           if (status == true && isNewUser == true) {
  //             successPrint("Signup successful for ${emailController.text}.");
  //             alertPrint(
  //                 "Sending otp to the registered email ${emailController.text}");
  //             sendOtp(emailController.text);
  //             DialogHelper.showErroDialog(
  //                 title: "Success",
  //                 description:
  //                     "Registration successful! Please complete your profile.");
  //           } else if (status == true && isNewUser == false) {
  //             DialogHelper.showErroDialog(
  //                 description:
  //                     "This email is already registered. Please login.");
  //             alertPrint("Already registered");
  //           } else {
  //             DialogHelper.showErroDialog(
  //                 description:
  //                     "An unexpected response was received from the server.");
  //           }
  //
  //           break;
  //
  //         case 400:
  //           final errorMessage =
  //               data2["detail"]?.toString() ?? "Invalid input provided.";
  //           DialogHelper.showErroDialog(description: errorMessage);
  //           errorPrint("Error 400: $errorMessage");
  //           break;
  //
  //         case 1:
  //           DialogHelper.showErroDialog(
  //               description: "Please check your internet connection.");
  //           break;
  //
  //         case 401:
  //           DialogHelper.showErroDialog(
  //               description:
  //                   "User is already registered. Please log in to continue.");
  //         default:
  //           DialogHelper.showErroDialog(
  //               description: "Server error, Please try again later.");
  //           errorPrint(
  //               "Server error: ${value.statusCode}. Please try again later.");
  //           break;
  //       }
  //     } on FormatException catch (e) {
  //       DialogHelper.hideLoading();
  //       errorPrint(
  //           "Error parsing server response: $e \nResponse Body: ${value.body}");
  //       DialogHelper.showErroDialog(
  //           description: "Received an invalid response from the server.");
  //     } catch (e) {
  //       DialogHelper.hideLoading();
  //       errorPrint("An unknown error occurred during signup: $e");
  //       DialogHelper.showErroDialog(
  //           description: "An unexpected error occurred.");
  //     }
  //   }).catchError((error) {
  //     DialogHelper.hideLoading();
  //     errorPrint("Future failed: $error");
  //     DialogHelper.showErroDialog(
  //         description: "An error occurred. Please check your connection.");
  //   });
  // }
  Future<void> signUp() async {
    DialogHelper.showLoading("Creating account...");

    try {
      final response =
          await service.apiSignUpService(emailController.text, password.text);
      DialogHelper.hideLoading();

      var data2 = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final bool status = data2["status"] ?? false;
        final bool isNewUser = data2["is_newuser"] ?? false;

        if (status == true && isNewUser == true) {
          successPrint(
              "Signup successful for ${emailController.text}. Now sending OTP.");
          await sendOtp(emailController.text);
        } else if (status == true && isNewUser == false) {
          DialogHelper.showErroDialog(
              description: "This email is already registered. Please login.");
        } else {
          DialogHelper.showErroDialog(
              description: data2["message"] ?? "An unexpected error occurred.");
        }
      } else {
        final errorMessage =
            data2["detail"]?.toString() ?? "An error occurred.";
        DialogHelper.showErroDialog(description: errorMessage);
      }
    } catch (e) {
      DialogHelper.hideLoading();
      errorPrint("An error occurred during signup: $e");
      DialogHelper.showErroDialog(description: "An unexpected error occurred.");
    }
  }

  ///send otp
  // Future<void> sendOtp(String emailAddress) async {
  //   DialogHelper.showLoading();
  //
  //   try {
  //     final response = await service.apiSendOtpService(emailAddress);
  //     DialogHelper.hideLoading();
  //
  //     switch (response.statusCode) {
  //       case 200:
  //         final data = jsonDecode(response.body);
  //         successPrint(
  //             "Send OTP successfully to $emailAddress - Email Id:- ${data["id"].toString()}");
  //         successPrint("Response body send Otp ${response.body}");
  //         final String emailId = data["id"]?.toString() ?? '';
  //
  //         if (emailId.isNotEmpty) {
  //           successPrint(
  //               "Send OTP successful. Navigating to OTP page with ID: $emailId");
  //
  //           Get.to(() => OtpPage(emailId: emailId));
  //         } else {
  //           DialogHelper.showErroDialog(
  //               description: "Failed to get required data from server.");
  //         }
  //
  //         break;
  //
  //       case 400:
  //       case 404:
  //         final data = jsonDecode(response.body);
  //         final errorMessage = data["detail"] ?? "An unknown error occurred.";
  //         DialogHelper.showErroDialog(description: errorMessage);
  //         errorPrint("Error 400/404: $errorMessage");
  //         break;
  //
  //       default:
  //         DialogHelper.showErroDialog(
  //             description: "A server error occurred. Please try again later.");
  //         break;
  //     }
  //   } catch (e) {
  //     DialogHelper.hideLoading();
  //     errorPrint("Error sending OTP: $e");
  //     DialogHelper.showErroDialog(
  //         description:
  //             "Failed to connect. Please check your internet connection.");
  //   }
  // }
  Future<void> sendOtp(String emailAddress) async {
    DialogHelper.showLoading("Sending OTP...");

    try {
      final response = await service.apiSendOtpService(emailAddress);
      DialogHelper.hideLoading();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String emailId = data["id"]?.toString() ?? '';

        if (emailId.isNotEmpty) {
          successPrint(
              "Send OTP successful. Navigating to OTP page with ID: $emailId");

          /// We have the ID, so we can proceed.
          Get.to(() => OtpPage(emailId: emailId));
        } else {
          errorPrint(
              "Failed to retrieve 'id' from sendOtp response for email: $emailAddress");
          DialogHelper.showErroDialog(
              title: "Verification Error",
              description:
                  "Could not start the verification process for this account. Please try signing up again or contact support if the problem persists.");
        }
      } else {
        final data = jsonDecode(response.body);
        final errorMessage = data["detail"] ?? "Failed to send OTP.";
        DialogHelper.showErroDialog(description: errorMessage);
      }
    } catch (e) {
      DialogHelper.hideLoading();
      errorPrint("Error sending OTP: $e");
      DialogHelper.showErroDialog(
          description:
              "Failed to connect. Please check your internet connection.");
    }
  }

  Future<void> verifyOtp(String otp, String emailid) async {
    DialogHelper.showLoading();

    try {
      final response = await service.apiVerifyOtpService(otp, emailid);
      DialogHelper.hideLoading();

      switch (response.statusCode) {
        case 200:
          try {
            final responseData = jsonDecode(response.body);
            final String email = responseData['email']?.toString() ?? '';
            final String id = responseData['id']?.toString() ?? '';
            final String name = responseData['name']?.toString() ?? '';
            final String token = responseData['token']?.toString() ?? '';
            if (token.isNotEmpty) {
              await PreferenceUtils.setString("email", email);
              await PreferenceUtils.setString("id", id);
              await PreferenceUtils.setString("name", name);
              await PreferenceUtils.saveUserToken(token);

              successPrint(
                  "OTP Verified. User data saved successfully. $responseData");
              Get.to(() => OnboardPage());
            } else {
              DialogHelper.showErroDialog(
                  description:
                      "Verification successful, but failed to retrieve user data.");
            }
          } on FormatException catch (e) {
            errorPrint("Error parsing success response: $e");
            DialogHelper.showErroDialog(
                description: "Received an invalid response from the server.");
          }
          break;

        case 400:
          try {
            final responseData = jsonDecode(response.body);
            final errorMessage = responseData['detail']?.toString() ??
                'Invalid OTP. Please try again.';
            DialogHelper.showErroDialog(description: errorMessage);
          } on FormatException catch (e) {
            DialogHelper.showErroDialog(
                description: "Invalid OTP. Please try again.");
          }
          break;

        case 1:
          DialogHelper.showErroDialog(
              description: "Please check your internet connection.");
          break;

        default:
          DialogHelper.showErroDialog(
              description:
                  "An unknown server error occurred. Please try again later.");
          break;
      }
    } catch (e) {
      // 6. This is the final safety net for any other unexpected errors
      DialogHelper.hideLoading();
      errorPrint("An unexpected error occurred in verifyOtp: $e");
      DialogHelper.showErroDialog(description: "An unexpected error occurred.");
    }
  }

  void otpResendValidSubmit(String email) async {
    DialogHelper.showLoading();
    service.apiResendOtp(email).then((value) {
      print(value.statusCode);
      DialogHelper.hideLoading();
      switch (value.statusCode) {
        case 200:
          otpController.text = "";
          DialogHelper.showErroDialog(description: "Resend Successfully");
          break;
        case 400:
          var data2 = jsonDecode(value.body);
          DialogHelper.showErroDialog(description: data2["detail"].toString());

          break;
        case 1:
          break;
        default:
          DialogHelper.showErroDialog(description: "Try again later");
          break;
      }
    });
  }
}
