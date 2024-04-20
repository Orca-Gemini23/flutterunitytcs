import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class Animationloader {
  static Future<RiveFile> loadBallAnimation() async {
    log("Loading Rive Ball Animation .....");
    String animationAsset =
        "assets/images/animations/marching_ball_animation_latest.riv";
    // "assets/images/animations/marching_ball_animation_with_reverse.riv";
    // String testAnimation =
    //     "assets/images/animations/marching_ball_animation_test.riv";
    final ByteData byteData = await rootBundle.load(animationAsset);
    final RiveFile riveFile = RiveFile.import(byteData);

    return riveFile;
  }

  static Future<RiveFile> loadSwingAnimation() async {
    log("Loading Rive Swing Animation .....");
    String animationAsset =
        "assets/images/animations/swing_animation_updated_6.riv";
    final ByteData byteData = await rootBundle.load(animationAsset);
    final RiveFile riveFile = RiveFile.import(byteData);

    return riveFile;
  }

  static Future<RiveFile> loadFishAnimation() async {
    log("Loading Rive Swing Animation .....");
    String animationAsset = 
    "assets/images/animations/fish_game_resized.riv";
    // "assets/images/animations/fish_game.riv";
    final ByteData byteData = await rootBundle.load(animationAsset);
    final RiveFile riveFile = RiveFile.import(byteData);

    return riveFile;
  }
}

//"assets/images/animations/swing_animation.riv";
// "assets/images/animations/swing_animation_without_white_leg.riv";
// "assets/images/animations/swing_animation_with_white_leg.riv";