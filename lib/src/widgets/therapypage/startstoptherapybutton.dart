// ignore_for_file: use_build_context_synchronously, unused_import, must_be_immutable

import "dart:async";
import "dart:math";
import "dart:developer" as dev;
import "package:awesome_dialog/awesome_dialog.dart";
import "package:cloud_firestore/cloud_firestore.dart";
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
import "package:walk/src/utils/firebasehelper.dart/firebasedb.dart";

class AnimationControlButton extends StatefulWidget {
  AnimationControlButton({
    super.key,
    required this.animationStateController,
    required this.leftballInput,
    required this.rightballInput,
    required this.sendLeftBall,
    required this.sendRightBall,
  });

  StateMachineController? animationStateController;
  SMIInput<double>? leftballInput;
  SMIInput<double>? rightballInput;
  SMIInput<bool>? sendRightBall;
  SMIInput<bool>? sendLeftBall;

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
          ////check if the game is running or not
          if (gameController.gameStatus == true) {
            //// stop the game and handle upload to cloud
            gameController.stopTimer();
            await animationValues!.cancel();
            gameController.changeGameStatus(false);
            ballPeriodicTimer == null ? null : ballPeriodicTimer!.cancel();
            timer.cancel();

            if (gameController.secondsPlayed > 10) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.info,
                title: "Uploading you scores",
                desc: "Please wait while we upload your data to cloud .",
                customHeader: const CircularProgressIndicator(
                  color: AppColor.greenDarkColor,
                  backgroundColor: Colors.white,
                ),
                borderSide:
                    const BorderSide(color: AppColor.greenDarkColor, width: 4),
                dismissOnBackKeyPress: false,
                dismissOnTouchOutside: false,
              ).show();

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
            // for logging the
            timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
              if (kDebugMode) {
                print("--------->  $ball, $ballValue" +
                    "busser beeped : $isBuzzer, " +
                    "RLA: ${animationValuesController.rightAngleValue}, " +
                    "LLA: ${animationValuesController.leftAngleValue}, " +
                    "${DateTime.now().millisecondsSinceEpoch}");
              }
            });
            handleGame(
                deviceController, animationValuesController, gameController);
            gameController.changeGameStatus(true);
          }
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.maxFinite, 80.h),
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
        ball = selectRandomBall();
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
              rightBallValue == 25
                  ? await deviceController.sendToDevice(
                      "beepc 4;", WRITECHARACTERISTICS)
                  : null;
              if (rightBallValue == 25) {
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
              leftBallValue == 25
                  ? await deviceController.sendToDevice(
                      "beeps 4;", WRITECHARACTERISTICS)
                  : null;
              if (leftBallValue == 25) {
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
      },
    );
  }

  int selectRandomBall() {
    return Random().nextInt(2);
  }
}
