
import 'package:vibelit/config/application.dart';

class PreferenceHelper {

  static Future<bool> clear() {
    return Application.preferences.clear();
  }

  static Future<bool> remove(String key) {
    return Application.preferences.remove(key);
  }

  static dynamic get(String key) {
    return Application.preferences.get(key);
  }

  static Set<String> getKeys() {
    return Application.preferences.getKeys();
  }

  static Future<bool> setBool(String key, bool value) {
    return Application.preferences.setBool(key, value);
  }

  static bool getBool(String key) {
    bool result = Application.preferences.getBool(key);
    return result ?? false;
  }

  static Future<bool> setDouble(String key, double value) {
    return Application.preferences.setDouble(key, value);
  }

  static double getDouble(String key) {
    return Application.preferences.getDouble(key);
  }

  static Future<bool> setInt(String key, int value) {
    return Application.preferences.setInt(key, value);
  }

  static int getInt(String key) {
    return Application.preferences.getInt(key) ?? 0;
  }

  static Future<bool> setDate(String key, DateTime value) {
    int timestamp = value.millisecondsSinceEpoch;
    return Application.preferences.setInt(key, timestamp);
  }

  static DateTime getDate(String key) {
    int timestamp = Application.preferences.getInt(key);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : DateTime.now();
  }

  static Future<bool> setString(String key, String value) {
    return Application.preferences.setString(key, value);
  }

  static String getString(String key) {
    String result = Application.preferences.getString(key);
    return result ?? "";
  }

  static Future<bool> setStringList(String key, List<String> value) {
    return Application.preferences.setStringList(key, value);
  }

  static List<String> getStringList(String key) {
    return Application.preferences.getStringList(key);
  }
  ///Singleton factory
  static final PreferenceHelper _instance = PreferenceHelper._internal();
  factory PreferenceHelper() {
    return _instance;
  }
  PreferenceHelper._internal();
}