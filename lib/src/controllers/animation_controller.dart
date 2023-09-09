// ignore_for_file: unused_import

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:walk/src/widgets/therapypage/startstoptherapybutton.dart';

class AnimationValuesController extends ChangeNotifier {
  double leftAngleValue = 0;

  double rightAngleValue = 0;
  AnimationValuesController(
      {required this.leftAngleValue, required this.rightAngleValue});
}
