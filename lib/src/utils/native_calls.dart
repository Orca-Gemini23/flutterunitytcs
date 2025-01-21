import 'dart:developer';

import 'package:flutter/services.dart';

class NativeCallHandler {
  static const lstMethodChannelName = MethodChannel("com.lifesparktech.walk");

  static String addShortCutMethodName = "putShortCut";

  static void callAddShortcutMethod() async {
    try {
      var value =
          await lstMethodChannelName.invokeMethod(addShortCutMethodName);
      log(value);
    } catch (e) {
      log("Error occurred in adding the shortcut app icon the home screen");
    }
  }
}
