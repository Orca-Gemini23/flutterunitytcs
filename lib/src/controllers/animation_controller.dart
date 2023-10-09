// ignore_for_file: unused_import

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:walk/src/widgets/therapypage/startstoptherapybutton.dart';

class AnimationValuesController extends ChangeNotifier {
  ////Responsible to provide values for the animation
  ////Takes values from deviceController and passes to the animation
  double leftAngleValue = 0; ////Value of the left knee angle

  double rightAngleValue = 0; ////Value of the right knee angle
  AnimationValuesController(
      {required this.leftAngleValue, required this.rightAngleValue});
}
