import 'dart:async' show Future;
import 'package:shared_preferences/shared_preferences.dart';


 class PreferenceUtils {

  //    final _prefsInstance = await SharedPreferences.getInstance();
  //
  //
  //
  // static String getDesignation(String key, [String? defValue]) {
  //   return _prefsInstance?.getString(key) ?? defValue ?? "";
  // }
  //
  // static Future<bool> setDesignation(String key, String value) async {
  //   var prefs = await _instance;
  //   return prefs?.setString(key, value) ?? Future.value(false);
  // }
  //
  // static String getToken(String key, [String? defValue]) {
  //   return _prefsInstance?.getString(key) ?? defValue ?? "";
  // }
  //
  // static Future<bool> setToken(String key, String value) async {
  //   var prefs = await _instance;
  //   return prefs?.setString(key, value) ?? Future.value(false);
  // }
  //
  // static String getName(String key, [String? defValue]) {
  //   return _prefsInstance?.getString(key) ?? defValue ?? "";
  // }
  //
  // static Future<bool> setName(String key, String value) async {
  //   var prefs = await _instance;
  //   return prefs?.setString(key, value) ?? Future.value(false);
  // }
  //
  //
  // static String getEvents(String key, [String? defValue]) {
  //   return _prefsInstance?.getString(key) ?? defValue ?? "";
  // }
  //
  // static Future<bool> setEvents(String key, String value) async {
  //   var prefs = await _instance;
  //   return prefs?.setString(key, value) ?? Future.value(false);
  // }
  //
  //
  //
  // static String getNetworks(String key, [String? defValue]) {
  //   return _prefsInstance?.getString(key) ?? defValue ?? "";
  // }
  //
  // static Future<bool> setNetworks(String key, String value) async {
  //   var prefs = await _instance;
  //   return prefs?.setString(key, value) ?? Future.value(false);
  // }
  //
  // static bool getisLogin(String key, [bool? defValue]) {
  //   return _prefsInstance?.getBool(key) ?? defValue ?? true;
  // }
  //
  // static Future<bool> setisLogin(String key, bool value) async {
  //   var prefs = await _instance;
  //   return prefs?.setBool(key, value) ?? Future.value(false);
  // }


}

class PrefrenceConst{
  static String userName = 'name';
  static String acessToken = 'token';
  static String userDesignation = 'designation';
  static String networks = 'networks';
  static String events = 'events';
  static String isLogin = 'islogin';
  static String image = 'image';


  static String executionList = 'executionList';

  static String feedback = 'feedback';

  static String replaceEventPlusFeedback = 'replaceEventPlusFeedback';


}