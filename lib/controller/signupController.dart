import 'dart:convert';

import 'package:chatbot/service/auth_service.dart';
import 'package:chatbot/view/home.dart';
import 'package:chatbot/view/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/commons.dart';
import '../service/shared_pref.dart';
import '../utils/app_routes.dart';

class SignUpController extends GetxController {
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmpassword = TextEditingController();
  final pinController = TextEditingController();
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
  final genderController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final emergencyContactController = TextEditingController();

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
  List selectedLanguages = [];
  final List languageOptions = ["English", "French", "Hindi", "Tamil"];

  // Availability
  List<String> selectedDays = [];
  final List<String> allDays = [
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

  void goToNextStep() {
    if (currentStep < 6) {
      currentStep++;
      update();
    } else {
      DialogHelper.showErroDialog(
        description: "Family Head added Successfully",
      );
    }
  }

  void goToPreviousStep() {
    if (currentStep > 0) {
      currentStep--;
      update();
    } else {
      final Map<String, dynamic> json = {
        "personal_info": {
          "name": nameController.text,
          "date_of_birth": dobController.text,
          "gender": genderController.text,
          "mobile_number": mobileController.text,
          "email": emailController.text,
          "address": addressController.text,
          "emergency_contact": emergencyContactController.text,
        },
        "registration": {
          "medical_reg_no": medicalCouncilController.text,
          "medical_council": medicalCouncilController.text,
          "state_of_reg": stateOfRegController.text,
          "year_of_reg": int.tryParse(yearOfRegController.text) ?? 0,
        },
        "experience": {
          "year_of_practice": int.tryParse(yearOfPracticeController.text) ?? 0,
          "specialization": specializationController.text,
          "subspecialties": subspecialtiesController.text,
          "previous_company_name": previousCompanyController.text,
          "language_spoken": selectedLanguages,
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
          "publications": publicationsController.text,
          "linkedin_profile": linkedinController.text,
          "consent_for_telconsult": consentTelconsult,
          "ref_from_doc": refDocController.text,
          "digital_signature": digitalSignatureController.text,
          "prof_website": profWebsiteController.text,
          "malpratice_insurance": malpracticeInsurance,
          "awards_recog":
              awardController.text.isNotEmpty ? [awardController.text] : [],
        }
      };
      DialogHelper.showErroDialog(
        description: "Submt Successfully",
      );
    }
  }

  signUp() {
    DialogHelper.showLoading();
    service.apiSignUpService(email.text, password.text).then((value) {
      print(value.statusCode);
      DialogHelper.hideLoading();
      switch (value.statusCode) {
        case 200:
          var data2 = jsonDecode(value.body);
          if (data2["status"].toString() == "1") {
            DialogHelper.showErroDialog(
                description: "Please verify your email");
            Get.to(OtpPage(emailid: data2["id"].toString(), email: email.text));
          } else if (data2["status"].toString() == "2") {
            DialogHelper.showErroDialog(
                description: "Already registered please login");
          } else {
            Get.to(OtpPage(
                emailid: data2["email_id"].toString(), email: email.text));
          }

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

  void verifyOtp(String otp, emailid) async {
    DialogHelper.showLoading();
    service.apiVerifyOtpService(otp, emailid).then((value) {
      print(value.body);
      DialogHelper.hideLoading();
      switch (value.statusCode) {
        case 200:
          var data2 = jsonDecode(value.body);

          PreferenceUtils.setString("email", data2["email"].toString());
          PreferenceUtils.setString("id", data2["id"].toString());
          PreferenceUtils.setString("name", data2["name"].toString());
          PreferenceUtils.saveUserToken(data2["token"].toString());
          //  Get.offAll(AiChatBot());
          // // Get.toNamed(Routes.CREATEMENEMID);

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

  void otpResendValidSubmit(String email) async {
    DialogHelper.showLoading();
    service.apiResendOtp(email).then((value) {
      print(value.statusCode);
      DialogHelper.hideLoading();
      switch (value.statusCode) {
        case 200:
          pinController.text = "";
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
