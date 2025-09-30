import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
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
      if (kDebugMode) {
        print(response.body);
      }
      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
    // catch(e){
    //     return Response(statusCode: 1, statusText: noInternetMessage);
    // }
  }

  Future<Response> apiSignUpService(String? username, String? password) async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.signUp);
    try {
      final response = await http.post(ur,
          body: jsonEncode({"email": username, "password": password}),
          headers: {
            "content-type": "application/json",
          });
      if (kDebugMode) {
        print(response.body);
      }
      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> apiVerifyOtpService(String? otp, emailid) async {
    var ur = Uri.parse(
        AppUrls.BASE_URL + AppUrls.otpVerify + "/?otp=$otp&email=$emailid");
    try {
      final response = await http.get(ur, headers: {
        "content-type": "application/json",
      });
      if (kDebugMode) {
        print(response.body);
      }
      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> apiForgetPassword(String? email) async {
    var ur =
        Uri.parse(AppUrls.BASE_URL + AppUrls.forgetPassword + "?email=$email");
    try {
      final response = await http.patch(ur, headers: {
        "content-type": "application/json",
      });
      if (kDebugMode) {
        print(response.body);
      }
      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> apiVerifyOtpForgetService(String? otp, emailid) async {
    var ur =
        Uri.parse(AppUrls.BASE_URL + AppUrls.otpVerifyForgot + "/$emailid");
    try {
      final response =
          await http.post(ur, body: jsonEncode({"otp": otp}), headers: {
        "content-type": "application/json",
      });
      if (kDebugMode) {
        print(response.body);
      }
      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> apiChangePasword(String? password, id) async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.changePassword + "/$id");
    try {
      final response = await http
          .post(ur, body: json.encode({"password": password}), headers: {
        "content-type": "application/json",
      });
      if (kDebugMode) {
        print(response.body);
      }
      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> apiResendOtp(email) async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.resendOtp + "?email=$email");
    try {
      final response = await http.post(ur, headers: {
        "content-type": "application/json",
      });
      if (kDebugMode) {
        print(response.body);
      }
      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }
}
