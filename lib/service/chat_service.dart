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
  Future<Response> apiChatservice(String? username, String? password) async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.login);
    try {
      final response = await http.post(ur,
          body: jsonEncode({"email": username, "password": password}),
          headers: {
            // "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            // 'Accept': '*/*'
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