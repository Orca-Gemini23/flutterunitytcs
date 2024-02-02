// ignore_for_file: unused_import

import 'dart:async';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameController extends ChangeNotifier {
  int _score = 0;
  bool _isGameRunning = false;
  late Timer _gameTimer;
  int _secondsPlayed = 0;
  bool _valueIncremented = false;
  double _positionToVibrateAt = 25;

  void incrementScore() {
    _score++;

    notifyListeners();
  }

  void changeVibrationPostion(double newPostion) {
    _positionToVibrateAt = newPostion;
    notifyListeners();
  }

  double getVibrationPosition() {
    return _positionToVibrateAt;
  }

  void changeGameStatus(bool status) {
    _isGameRunning = status;
    notifyListeners();
  }

  void startTimer() {
    if (!_isGameRunning) {
      _isGameRunning = true;
      _gameTimer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          _secondsPlayed++;
          notifyListeners();
        },
      );
    }
  }

  void stopTimer() {
    if (_isGameRunning) {
      _isGameRunning = false;
      _gameTimer.cancel();
    }
    notifyListeners();
  }

  void resetTimer() {
    _secondsPlayed = 0;
    notifyListeners();
  }

  void changeIncremented(bool value) {
    _valueIncremented = value;
    notifyListeners();
  }

  void resetGameScore() {
    _score = 0;
    notifyListeners();
  }

  get scores => _score;
  get gameStatus => _isGameRunning;
  get secondsPlayed => _secondsPlayed;
  get isIncremented => _valueIncremented;
}
