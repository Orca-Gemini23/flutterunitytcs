import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class Animationloader {
  static Future<RiveFile> loadAnimation() async {
    log("Loading Rive Animation .....");
    String animationAsset =
        "assets/images/animations/swing_animation_updated_5.riv";
    // "assets/images/animations/marching_ball_animation_latest.riv";
    // "assets/images/animations/marching_ball_animation_with_reverse.riv";
    // String testAnimation =
    //     "assets/images/animations/marching_ball_animation_test.riv";
    final ByteData byteData = await rootBundle.load(animationAsset);
    final RiveFile riveFile = RiveFile.import(byteData);

    return riveFile;
  }
}

//"assets/images/animations/swing_animation.riv";
// "assets/images/animations/swing_animation_without_white_leg.riv";
// "assets/images/animations/swing_animation_with_white_leg.riv";