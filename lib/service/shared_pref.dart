import 'dart:async' show Future;
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance!;
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = await _instance;
    return prefs.setString(key, value);
  }

  static Future<bool> setBool(String key, bool value) async {
    var prefs = await _instance;
    return prefs.setBool(key, value);
  }

  static Future<bool> setList(String key, List<String> value) async {
    var prefs = await _instance;
    return prefs.setStringList(key, value);
  }

  static String getString(String key) {
    return _prefsInstance?.getString(key) ?? "";
  }

  static bool getBool(String key) {
    return _prefsInstance?.getBool(key) ?? false;
  }

  static Future<bool> saveUserToken(String token) async {
    var prefs = await _instance;
    return await prefs.setString("Token", token);
  }

  // static Future<bool> saveStudentType(String studentType) async {
  //   var prefs = await _instance;
  //   return await prefs.setString("StudentType", studentType);
  // }

  // static Future<bool> saveUserName(String username) async {
  //   var prefs = await _instance;
  //   return await prefs.setString("username", username);
  // }

  // static Future<bool> saveUserMID(String MID) async {
  //   var prefs = await _instance;
  //   return await prefs.setString("MID", MID);
  // }

  static String getUserToken() {
    return _prefsInstance!.getString("Token") ?? "";
  }

  static String getMid() {
    return _prefsInstance!.getString("mid") ?? "";
  }

  static String getCategory() {
    return _prefsInstance!.getString("category") ?? "";
  }

  static bool checkLocation() {
    return _prefsInstance!.containsKey("location");
  }

  static bool checkMid() {
    return _prefsInstance!.containsKey("mid");
  }

  static bool checkCategory() {
    return _prefsInstance!.containsKey("category");
  }

  static bool checkTitle() {
    return _prefsInstance!.containsKey("title");
  }

  static bool checkOtype() {
    return _prefsInstance!.containsKey("otype");
  }

  static bool checkItype() {
    return _prefsInstance!.containsKey("iType");
  }

  static bool checkFirstTimemApp() {
    return _prefsInstance!.containsKey("CheckFirstTime");
    //return _prefsInstance?.getBool("CheckFirstTime") ?? false;
  }

  static bool getShowIntro() {
    return _prefsInstance!.getBool("showIntro") ?? false;
  }

  static bool isLoggedIn() {
    return _prefsInstance!.containsKey("Token");
  }

  Future<bool> clearSharedPref() {
    return _prefsInstance!.clear();
  }

  Future<bool> remove(String key) async {
    return _prefsInstance!.remove(key);
  }
}
