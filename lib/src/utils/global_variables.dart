import 'package:flutter/material.dart';

class VersionNumber {
  static String versionNumber = "";
}

class AdvancedMode {
  static bool modevisiable = false;
  static bool modeSettingVisible = false;
}

class UserDetails {
  static bool unavailable = false;
  static bool iosUnavailable = false;
}

class DetailsPage {
  static String height = "";
  static String weight = "";
}

class ImagePath {
  static String path = "";
}

class DeviceSize {
  static bool isTablet = false;
  static bool checkTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.shortestSide >= 600;
  }
}

class CollectAnalytics {
  static bool start = false;
  static List<dynamic> initialData = [];
}

class Device {
  static String name = "";
}

String testId = "";
