import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart' as aa;
import '../utils/app_urls.dart';
import 'shared_pref.dart';

class HomeService {
  final String noInternetMessage =
      'Connection to API server failed due to internet connection';
  Future<Response> apiCreateJournal(String? title, String? des, id) async {
    var ur = id == ""
        ? Uri.parse(AppUrls.BASE_URL + AppUrls.addJournal)
        : Uri.parse(AppUrls.BASE_URL + AppUrls.addJournal + "?journal_id=$id");
    try {
      final response = await http.post(ur,
          body: jsonEncode({"title": title, "journal_note": des}),
          headers: {
            // "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI4IiwiZXhwIjoxNzc0NDQ5NTQ5fQ.sWmgWS351Sj2eGwE8JtT5bRa2zLjKWpgSMMk_XG0qLg',
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

  Future<Response> apiGetJournal() async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.getJournal);
    try {
      final response = await http.get(ur, headers: {
        // "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI4IiwiZXhwIjoxNzc0NDQ5NTQ5fQ.sWmgWS351Sj2eGwE8JtT5bRa2zLjKWpgSMMk_XG0qLg',
      });
      if (kDebugMode) {
        print(response.body);
      }
      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> apiGetDashboardJournal() async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.journalDashboard);
    try {
      final response = await http.get(ur, headers: {
        // "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI4IiwiZXhwIjoxNzc0NDQ5NTQ5fQ.sWmgWS351Sj2eGwE8JtT5bRa2zLjKWpgSMMk_XG0qLg',
      });
      if (kDebugMode) {
        print(response.body);
      }
      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> apiDeleteJournal(id) async {
    var ur =
        Uri.parse(AppUrls.BASE_URL + AppUrls.deleteJournal + "?journal_id=$id");
    try {
      final response = await http.delete(ur, headers: {
        // "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI4IiwiZXhwIjoxNzc0NDQ5NTQ5fQ.sWmgWS351Sj2eGwE8JtT5bRa2zLjKWpgSMMk_XG0qLg',
      });
      if (kDebugMode) {
        print(response.body);
      }
      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> apiChat(String? usertext, file) async {
    var ur =
        Uri.parse(AppUrls.BASE_URL + AppUrls.aichat + "?usertext=$usertext");

    // final response = await http.post(ur, headers: {
    //   // "Access-Control-Allow-Origin": "*",
    //   'Content-Type': 'application/json',
    //   'Authorization':
    //       'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI4IiwiZXhwIjoxNzc0NDQ5NTQ5fQ.sWmgWS351Sj2eGwE8JtT5bRa2zLjKWpgSMMk_XG0qLg',
    // });
    // var response = http.MultipartRequest('POST', ur);
    // // ✅ Add headers
    // response.headers.addAll({
    //   // 'Content-Type': 'application/json',
    //   'Authorization':
    //       'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI4IiwiZXhwIjoxNzc0NDQ5NTQ5fQ.sWmgWS351Sj2eGwE8JtT5bRa2zLjKWpgSMMk_XG0qLg',
    // });
    // if (file != null) {
    //   var multipartFile = http.MultipartFile.fromBytes(
    //     'filedata', // This should match the parameter name in your FastAPI endpoint
    //     file,
    //     filename: "aa.png",
    //     contentType: MediaType('application', 'octet-stream'),
    //   );

    //   response.files.add(multipartFile);
    // }

    // // Send the request
    // var response2 = await response.send();
    // // return Response(
    // //   statusCode: response2.statusCode,
    // //   // body:response2.stream.bytesToString(),
    // // );
    // if (kDebugMode) {
    //   print(response2.stream.bytesToString());
    // }
    // return Response(
    //     statusCode: response2.statusCode,
    //     body: response2.stream.bytesToString());
    var dio = aa.Dio();
    var formData;
    if (file != null) {
      formData = aa.FormData.fromMap({
        'file': kIsWeb
            ? await aa.MultipartFile.fromBytes(
                file!,
                filename: "aa.png",
                contentType: MediaType('application', 'octet-stream'),
              )
            : await aa.MultipartFile.fromFile(
                file!,
                filename: "aa.png",
              ),
      });
    }

    var token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI4IiwiZXhwIjoxNzc0NDQ5NTQ5fQ.sWmgWS351Sj2eGwE8JtT5bRa2zLjKWpgSMMk_XG0qLg";

    final response = await dio.post(
        AppUrls.BASE_URL + AppUrls.aichat + "?usertext=$usertext",
        options: aa.Options(
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer $token',
          },
        ),
        data: file != null ? formData : null);
    return Response(
      statusCode: response.statusCode,
      body: response.data,
    );
  }

  Future<Response> apiRageChat(String? usertext) async {
    var ur =
        Uri.parse(AppUrls.BASE_URL + AppUrls.chatRage + "?usertext=$usertext");
    try {
      final response = await http.post(ur, headers: {
        // "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI4IiwiZXhwIjoxNzc0NDQ5NTQ5fQ.sWmgWS351Sj2eGwE8JtT5bRa2zLjKWpgSMMk_XG0qLg',
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

  Future<Response> apiArrangeTask(arrnageType, taskid) async {
    var ur = Uri.parse(AppUrls.BASE_URL +
        AppUrls.updateArrange +
        "?taskid=$taskid&arrange=$arrnageType");
    try {
      final response = await http.put(ur, headers: {
        // "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI4IiwiZXhwIjoxNzc0NDQ5NTQ5fQ.sWmgWS351Sj2eGwE8JtT5bRa2zLjKWpgSMMk_XG0qLg',
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

  Future<Response> apiGetTasks() async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.taskGet);
    try {
      final response = await http.get(ur, headers: {
        // "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI4IiwiZXhwIjoxNzc0NDQ5NTQ5fQ.sWmgWS351Sj2eGwE8JtT5bRa2zLjKWpgSMMk_XG0qLg',
      });
      if (kDebugMode) {
        print(response.body);
      }
      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> apiCreateTask(
      title, subTask, category, dueDate, priority) async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.createTask);
    try {
      final response = await http.post(ur,
          body: jsonEncode({
            "task_title": title,
            "sub_task": subTask,
            "task_category": category,
            "due_date": dueDate,
            "priority_level": priority
          }),
          headers: {
            // "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI4IiwiZXhwIjoxNzc0NDQ5NTQ5fQ.sWmgWS351Sj2eGwE8JtT5bRa2zLjKWpgSMMk_XG0qLg',
          });
      if (kDebugMode) {
        print(response.body);
      }
      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> apiStartPromo(title, taskid, subtaskid, focus, duration,
      rounds, status, end, break_time) async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.startPromo);
    try {
      final response = await http.post(ur,
          body: jsonEncode({
            "subtaskdetails": [
              {
                "subtaskid": subtaskid,
                "taskid": taskid,
                "focuse_time": focus,
                "task_name": "$title",
                "duration": duration,
                "rounds": rounds,
                "break_time": break_time,
                "status": status,
                "end_duration": end
              }
            ]
          }),
          headers: {
            // "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI4IiwiZXhwIjoxNzc0NDQ5NTQ5fQ.sWmgWS351Sj2eGwE8JtT5bRa2zLjKWpgSMMk_XG0qLg',
          });
      if (kDebugMode) {
        print(response.body);
      }
      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> apiOnBoarding(onboard) async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.onboard);
    try {
      final response = await http.put(ur, body: jsonEncode(onboard), headers: {
        // "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI4IiwiZXhwIjoxNzc0NDQ5NTQ5fQ.sWmgWS351Sj2eGwE8JtT5bRa2zLjKWpgSMMk_XG0qLg',
      });
      if (kDebugMode) {
        print(response.body);
      }
      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> apiUpdateProfile(
      firstname, lastname, phone, email, profilepic) async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.profile);
    try {
      final response = await http.put(ur,
          body: jsonEncode({
            "first_name": "$firstname",
            "last_name": "$lastname",
            "phone_number": "$phone",
            "email": "$email",
            "notification": true,
            "notification_sound": true,
            "profile_pic": "",
            "mobile_token": ""
          }),
          headers: {
            // "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI4IiwiZXhwIjoxNzc0NDQ5NTQ5fQ.sWmgWS351Sj2eGwE8JtT5bRa2zLjKWpgSMMk_XG0qLg',
          });
      if (kDebugMode) {
        print(response.body);
      }
      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> getBreathInAudio(duration, area) async {
    var ur = Uri.parse(AppUrls.BASE_URL +
        AppUrls.aaudioFile +
        "?duration=$duration&focus_area=$area");
    try {
      final response = await http.post(ur, headers: {
        // "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI4IiwiZXhwIjoxNzc0NDQ5NTQ5fQ.sWmgWS351Sj2eGwE8JtT5bRa2zLjKWpgSMMk_XG0qLg',
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

  Future<Response> apiCreateNeeting(meedtingid) async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.create_meeting);
    try {
      final response = await http.post(ur,
          body: jsonEncode({
            "meeting_id_front": "$meedtingid",
            "title": "Doctor Consultant",
            "description": "Check with Doctor for general checkup.",
            "url": "string",
            "status": 0,
            "from_datetime": "2025-04-19T04:49:48.411Z",
            "to_datetime": "2025-04-19T04:49:48.411Z",
            "category": 2,
            "is_emergency": true
          }),
          headers: {
            // "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI4IiwiZXhwIjoxNzc0NDQ5NTQ5fQ.sWmgWS351Sj2eGwE8JtT5bRa2zLjKWpgSMMk_XG0qLg',
          });
      if (kDebugMode) {
        print(response.body);
      }
      return Response(statusCode: response.statusCode, body: response.body);
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> apiGetMeeting(date) async {
    var ur = Uri.parse(AppUrls.BASE_URL + AppUrls.get_meeting+"?date=$date");
    var token = PreferenceUtils.getUserToken();
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
  }
}
