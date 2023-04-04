import 'package:flutter/material.dart';

/// Custom class for screen resolution
class Screen extends MediaQueryData {
  static double width({required BuildContext context}) {
    return MediaQuery.of(context).size.width;
  }

  static double height({required BuildContext context}) {
    return MediaQuery.of(context).size.height;
  }
}
