import 'package:shared_preferences/shared_preferences.dart';

String wifiKey = "isWifiCredsSaved";
String showCaseKey = "isShowCaseDone";

///This class is used to store different data in the local storage . Different methods are used to store/retrieve different data type.
class PreferenceController {
  /// Initializing Sharedpreferences instance
  static late SharedPreferences _prefs;

  /// checking if the user is first time user or not
  static saveboolData(String key, bool value) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool(key, value);
  }

  /// getting the value if user has opened the app first time or not
  static Future<bool> getboolData(String key) async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool(key) ?? false;
  }

  /// Saving device name
  static saveStringData(String key, String value) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(key, value);
  }

  /// getting device name
  static Future<String> getstringData(String key) async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(key) ?? "";
  }

  /// Saving device Mac address
  static saveDeviceMAC(String key, String value) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(key, value);
  }

  /// Gettting device Mac address
  static Future<String> getDeviceMAC(String key) async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(key) ?? "";
  }

  /// Saving device info
  static saveDevice(String key, String value) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(key, value);
  }

  /// Gettting device info
  static Future<String> getDevice(String key) async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(key) ?? "";
  }
}
