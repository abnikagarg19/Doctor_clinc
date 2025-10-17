import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../utils/app_urls.dart';
import 'shared_pref.dart';

class ChatService {
  final String noInternetMessage =
      'Connection to API server failed due to internet connection';
  Future<Response> apiSendMessage(String? userid, String? message) async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.sendMessage);
    var token = PreferenceUtils.getUserToken();
    var doctorid = PreferenceUtils.getString("id");
    try {
      final response = await http.post(ur,
          body: jsonEncode(
              {"from_": "$doctorid", "to": "$userid", "message": "$message"}),
          headers: {
            // "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
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

  Future<Response> apiChatHistory(String? patientId) async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.chatHistory + "/$patientId");
    var token = PreferenceUtils.getUserToken();
    var doctorid = PreferenceUtils.getString("id");
    try {
      final response = await http.get(ur, headers: {
        // "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
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

  Future<Response> apiGetPatient() async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.contactList);
    var token = PreferenceUtils.getUserToken();
    var doctorid = PreferenceUtils.getString("id");
    try {
      final response = await http.get(ur, headers: {
        // "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
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
}
