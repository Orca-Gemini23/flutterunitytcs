// ignore_for_file: must_be_immutable

import "dart:async";
import "dart:math";
import "dart:developer" as dev;
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:provider/provider.dart";
import "package:rive/rive.dart";
import "package:walk/src/constants/app_color.dart";
import "package:walk/src/constants/bt_constants.dart";
import "package:walk/src/controllers/animation_controller.dart";
import "package:walk/src/controllers/device_controller.dart";
import "package:walk/src/controllers/game_controller.dart";
import "package:walk/src/server/api.dart";
import "package:walk/src/utils/firebasehelper.dart/firebasedb.dart";
import "package:walk/src/widgets/dialog.dart";

class AnimationControlButton extends StatefulWidget {
  AnimationControlButton({
    super.key,
    required this.animationStateController,
    required this.leftballInput,
    required this.rightballInput,
    required this.sendLeftBall,
    required this.sendRightBall,
    required this.leftAngleInput,
    required this.rightAngleInput,
  });

  StateMachineController? animationStateController;
  SMIInput<double>? leftballInput;
  SMIInput<double>? rightballInput;
  SMIInput<bool>? sendRightBall;
  SMIInput<bool>? sendLeftBall;
  SMIInput<double>? leftAngleInput;
  SMIInput<double>? rightAngleInput;

  @override
  State<AnimationControlButton> createState() => _AnimationControlButtonState();
}

class _AnimationControlButtonState extends State<AnimationControlButton> {
  StreamSubscription<List<int>>? animationValues;
  Timer? ballPeriodicTimer;
  late Timer timer;
  int isBuzzer = 0;
  int ball = -1; // 0 => right and 1=> left
  int ballValue = -1;
  List<dynamic> data = [];

  Future<void> disposeEssentials() async {
    ballPeriodicTimer == null ? null : ballPeriodicTimer!.cancel();
    animationValues == null ? null : await animationValues!.cancel();
  }

  @override
  void dispose() {
    ballPeriodicTimer?.cancel();
    animationValues?.cancel();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<DeviceController, GameController,
            AnimationValuesController>(
        builder: (context, deviceController, gameController,
            animationValuesController, child) {
      return ElevatedButton(
        onPressed: () async {
          onPressed(
            gameController,
            deviceController,
            animationValuesController,
          );
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.maxFinite, 70.h),
          backgroundColor: gameController.gameStatus == true
              ? AppColor.batteryindicatorred
              : AppColor.batteryindicatorgreen,
          shadowColor: gameController.gameStatus == true
              ? AppColor.batteryindicatorred.withOpacity(.4)
              : AppColor.batteryindicatorgreen.withOpacity(.4),
        ),
        child: gameController.gameStatus == true
            ? Text(
                "${gameController.secondsPlayed} seconds",
                style: TextStyle(color: AppColor.whiteColor, fontSize: 18.sp),
              ) ////Display a timer if the device
            : Text(
                "Start Game",
                style: TextStyle(color: AppColor.whiteColor, fontSize: 18.sp),
              ),
      );
    });
  }

  void handleGame(
      DeviceController deviceController,
      AnimationValuesController animationValuesController,
      GameController gameController) {
    gameController.resetGameScore();
    animationValues = deviceController.startStream();

    ballPeriodicTimer = Timer.periodic(
      const Duration(seconds: 6),
      (timer) async {
        if (deviceController.rightAngleValue == -10 ||
            deviceController.leftAngleValue == -10) {
          Fluttertoast.showToast(msg: "Please stand up");
        } else {
          ball = selectRandomBall();
          dev.log("Selected ball is $ball");
          gameController.changeIncremented(false);
          if (ball == 0) {
            Fluttertoast.showToast(msg: "Get ready Right Ball is coming !!!!");
            widget.animationStateController!
                .setInputValue(widget.sendRightBall!.id, true);
            int rightBallValue = 0;
            ballValue = rightBallValue;

            while (true) {
              if (deviceController.rightAngleValue > 30 &&
                  rightBallValue >= 35 &&
                  rightBallValue <= 45) {
                if (!gameController.isIncremented) {
                  gameController.incrementScore();
                  gameController.changeIncremented(true);
                }
              }
              if (rightBallValue > 100) {
                widget.animationStateController!
                    .setInputValue(widget.rightballInput!.id, 0);
                widget.animationStateController!
                    .setInputValue(widget.sendRightBall!.id, false);
                break;
              } else {
                widget.animationStateController!.setInputValue(
                  widget.rightballInput!.id,
                  rightBallValue.toDouble(),
                );
                rightBallValue == gameController.getVibrationPosition().toInt()
                    ? await deviceController.sendToDevice(
                        "beepc 4;", WRITECHARACTERISTICS)
                    : null;
                if (rightBallValue ==
                    gameController.getVibrationPosition().toInt()) {
                  isBuzzer = 1;
                } else {
                  isBuzzer = 0;
                }

                await Future.delayed(
                  const Duration(milliseconds: 30),
                );
                rightBallValue++;
                ballValue++;
              }
            }
          } else {
            Fluttertoast.showToast(msg: "Get ready Left Ball is coming !!!!");
            widget.animationStateController!
                .setInputValue(widget.sendLeftBall!.id, true);
            int leftBallValue = 0;
            ballValue = leftBallValue;

            while (true) {
              if (deviceController.leftAngleValue > 30 &&
                  leftBallValue >= 35 &&
                  leftBallValue <= 45) {
                if (!gameController.isIncremented) {
                  gameController.incrementScore();
                  gameController.changeIncremented(true);
                }
              }
              if (leftBallValue > 100) {
                widget.animationStateController!
                    .setInputValue(widget.leftballInput!.id, 0);
                widget.animationStateController!
                    .setInputValue(widget.sendLeftBall!.id, false);
                break;
              } else {
                widget.animationStateController!.setInputValue(
                  widget.leftballInput!.id,
                  leftBallValue.toDouble(),
                );
                leftBallValue == gameController.getVibrationPosition().toInt()
                    ? await deviceController.sendToDevice(
                        "beeps 4;", WRITECHARACTERISTICS)
                    : null;
                if (leftBallValue ==
                    gameController.getVibrationPosition().toInt()) {
                  isBuzzer = 1;
                } else {
                  isBuzzer = 0;
                }

                await Future.delayed(const Duration(milliseconds: 30));
                leftBallValue++;
                ballValue++;
              }
            }
          }
        }
      },
    );
  }

  void onPressed(
      GameController gameController,
      DeviceController deviceController,
      AnimationValuesController animationValuesController) async {
    // testBallFalling();

    //check if the game is running or not
    if (gameController.gameStatus == true) {
      //// stop the game and handle upload to cloud
      gameController.stopTimer();
      if (animationValues != null) {
        await animationValues!.cancel();
      }
      gameController.changeGameStatus(false);
      ballPeriodicTimer == null ? null : ballPeriodicTimer!.cancel();
      timer.cancel();
      FirebaseDB.storeGameData(data);
      API.addData(data);
      data = [];
      if (gameController.secondsPlayed > 10) {
        CustomDialogs.showScoreUplodingDialog(context);
        bool result = await FirebaseDB.uploadUserScore(
          score: gameController.scores,
          playedOn: DateTime.now(),
          secondsPlayedFor: gameController.secondsPlayed,
        );
        if (result) {
          Fluttertoast.showToast(msg: "Data uploaded");
          Navigator.of(context, rootNavigator: true).pop();
          gameController.resetTimer();
          gameController.resetGameScore();
        } else {
          Navigator.of(context, rootNavigator: true).pop();
        }
      }
    } else {
      gameController.startTimer();
      handleGame(deviceController, animationValuesController, gameController);
      gameController.changeGameStatus(true);

      timer = Timer.periodic(const Duration(milliseconds: 10), (timer) async {
        String score =
            "$ball, $ballValue, busser beeped : $isBuzzer, RLA: ${widget.leftAngleInput?.value}, LLA: ${widget.rightAngleInput?.value}, ${DateTime.now().millisecondsSinceEpoch}";

        data.add(score);

        // if (kDebugMode) {
        //   // ignore: prefer_interpolation_to_compose_strings
        //   print("--------->  $ball, $ballValue, " +
        //       "busser beeped : $isBuzzer, " +
        //       "RLA: ${widget.leftAngleInput?.value}, " +
        //       "LLA: ${widget.rightAngleInput?.value}, " +
        //       "${DateTime.now().millisecondsSinceEpoch}");
        // }
      });
    }
  }

  int selectRandomBall() {
    return Random().nextInt(2);
  }
}
