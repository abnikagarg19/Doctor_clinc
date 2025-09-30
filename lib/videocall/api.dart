import 'dart:convert';
import 'package:http/http.dart' as http;

//Auth token we will use to generate a meeting and connect to it
String token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI0YWZlYWYwMC0zZGU4LTRmOWQtOTNkMS02OWMyNWJiYmFhYzciLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTc1ODI4MDQwOSwiZXhwIjoxNzg5ODE2NDA5fQ.2chBwwmM5zraku8fCCXns5GzvP8Lz4ktQg8juHGuFVI";

// API call to create meeting
Future<String> createMeeting() async {
  final http.Response httpResponse = await http.post(
    Uri.parse("https://api.videosdk.live/v2/rooms"),
    headers: {'Authorization': token},
  );

  final responseBody = json.decode(httpResponse.body);
  String meetingId = responseBody['roomId'];

  // Print the Meeting ID for debugging
  print("Generated Meeting ID: $meetingId");

  return meetingId;
}

