import 'dart:convert';
import 'dart:io';

import 'package:chatbot/utils/custom_print.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../utils/app_urls.dart';

class AuthService {
  final String noInternetMessage =
      'Connection to API server failed due to internet connection';
  Future<Response> apiLoginService(String? username, String? password) async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.login);
    var map = Map<String, dynamic>();

    map['username'] = username;
    map['password'] = password;
    map['grant_type'] = "password";

    try {
      final response = await http.post(
        ur,
        body: map,
      );

      alertPrint("login Service Api ${response.body}");
      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    } catch (e) {
      errorPrint("Error $e");
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> apiSignUpService(String? username, String? password) async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.signUp);
    try {
      final response = await http.post(ur,
          body: jsonEncode({"email": username, "password": password}),
          headers: {
            "content-type": "application/json",
          });

      alertPrint("Sign Up Service ${response.body}");
      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      errorPrint("Error SignUp Service $e");
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  ///send otp
  Future<Response> apiSendOtpService(String? emailId) async {
    var ur = Uri.parse("${AppUrls.BASE_URL}${AppUrls.sendOtp}?email=$emailId");
    try {
      final response = await http.patch(ur, headers: {
        "content-type": "application/json",
      });
      alertPrint('Send OTP Service ${response.body}');
      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      errorPrint("Error SendOtp Service $e");
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  /// verify otp
  Future<Response> apiVerifyOtpService(String? otp, emailid) async {
    var ur = Uri.parse(
        "${AppUrls.BASE_URL}${AppUrls.otpVerify}/?otp=$otp&email=$emailid");
    try {
      final response = await http.get(ur, headers: {
        "content-type": "application/json",
      });

      alertPrint("Verify Otp Service ${response.body}");

      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      errorPrint("Error VerifyOtp Service $e");
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> apiForgetPassword(String? email) async {
    var ur =
        Uri.parse("${AppUrls.BASE_URL}${AppUrls.forgetPassword}?email=$email");
    try {
      final response = await http.patch(ur, headers: {
        "content-type": "application/json",
      });

      alertPrint("Forget Password Service ${response.body}");

      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      errorPrint("Error Forget Password $e");
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> apiVerifyOtpForgetService(String? otp, emailid) async {
    var ur =
        Uri.parse("${AppUrls.BASE_URL}${AppUrls.otpVerifyForgot}/$emailid");
    try {
      final response =
          await http.post(ur, body: jsonEncode({"otp": otp}), headers: {
        "content-type": "application/json",
      });

      alertPrint("Verify Otp Forget Service ${response.body}");

      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      errorPrint("Error Verify Otp Forget Service $e");
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> apiChangePasword(String? password, id) async {
    var ur = Uri.parse("${AppUrls.BASE_URL}${AppUrls.changePassword}/$id");
    try {
      final response = await http
          .post(ur, body: json.encode({"password": password}), headers: {
        "content-type": "application/json",
      });

      alertPrint("Change Password Service ${response.body}");

      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> apiResendOtp(email) async {
    var ur = Uri.parse("${AppUrls.BASE_URL}${AppUrls.resendOtp}?email=$email");
    try {
      final response = await http.post(ur, headers: {
        "content-type": "application/json",
      });
      alertPrint("Resend Otp Service ${response.body}");

      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      errorPrint("Error Resend Otp $e");
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  ///Onboarding
  Future<http.Response> apiOnboardDoctor({
    required String dataJson,
    PlatformFile? degreeCert,
    PlatformFile? medCouncilCert,
    PlatformFile? govtId,
    PlatformFile? photoFile,
    PlatformFile? signatureFile,
  }) async {
    var uri = Uri.parse(AppUrls.BASE_URL + AppUrls.onboard);
    var request = http.MultipartRequest('POST', uri);
    String authToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJWekVTWW5mc0tyVHMiLCJleHAiOjE3OTIxNzA1NjR9.zTD9N3YpOPwYIaNrMCvsMj5CblDTEKBUadz4fQTkVOk";
    request.fields['data_json'] = dataJson;
    request.headers['Authorization'] = 'Bearer $authToken';
    request.fields['data_json'] = dataJson;
    Future<void> addFileToRequest(String fieldName, PlatformFile? file) async {
      if (file != null) {
        request.files.add(
          await http.MultipartFile.fromBytes(
            fieldName,
            file.bytes!,
            filename: file.name,
          ),
        );
      }
    }

    // Add all the files to the request
    await addFileToRequest('degree_cert', degreeCert);
    await addFileToRequest('med_council_reg_cert', medCouncilCert);
    await addFileToRequest('govt_id_proof', govtId);
    await addFileToRequest('photo', photoFile);
    await addFileToRequest('signature_scan', signatureFile);

    successPrint("Images added Successfully");

    try {
      // Send the request
      var streamedResponse = await request.send();

      // Get the response
      var response = await http.Response.fromStream(streamedResponse);

      alertPrint("Onboarding Response Status: ${response.statusCode}");
      successPrint("Onboarding Response Body: ${response.body}");

      return response;
    } catch (e) {
      errorPrint("Error sending onboarding data: $e");
      return http.Response(jsonEncode({'detail': 'Connection error: $e'}), 500);
    }
  }
}
