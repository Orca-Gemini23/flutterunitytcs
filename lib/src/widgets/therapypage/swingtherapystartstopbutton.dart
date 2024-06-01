// ignore_for_file: must_be_immutable

import "dart:async";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:provider/provider.dart";
import "package:rive/rive.dart";
import "package:wakelock_plus/wakelock_plus.dart";
import "package:walk/src/constants/app_color.dart";
import "package:walk/src/constants/bt_constants.dart";
import "package:walk/src/controllers/animation_controller.dart";
import "package:walk/src/controllers/device_controller.dart";
import "package:walk/src/controllers/game_controller.dart";
import "package:walk/src/views/artherapy/animation_swing.dart";
import "package:walk/src/server/api.dart";
// import "package:walk/src/utils/firebasehelper.dart/firebasedb.dart";
import "package:walk/src/widgets/dialog.dart";

class SwingAnimationControlButton extends StatefulWidget {
  SwingAnimationControlButton({
    super.key,
    required this.animationStateController,
    required this.rhythmNumber,
    required this.bgHeight,
    required this.legRaise,
    required this.rightAngleInput,
    required this.leftAngleInput,
    required this.rightLegInput,
    required this.artboardScore,
  });

  StateMachineController? animationStateController;
  SMIInput<double>? rhythmNumber;
  SMIInput<double>? bgHeight;
  SMIInput<bool>? legRaise;
  SMIInput<double>? rightAngleInput;
  SMIInput<double>? leftAngleInput;
  SMIInput<bool>? rightLegInput;
  String artboardScore;

  @override
  State<SwingAnimationControlButton> createState() =>
      _SwingAnimationControlButtonState();
}

class _SwingAnimationControlButtonState
    extends State<SwingAnimationControlButton> {
  StreamSubscription<List<int>>? animationValues;
  Timer? swingTimer;
  Timer? buzzerTimer;
  Timer? legChangeTimer;
  Timer logTimer = Timer(Duration.zero, () {});
  List<dynamic> data = [1];

  Future<void> disposeEssentials() async {
    swingTimer == null ? null : swingTimer!.cancel();
    buzzerTimer == null ? null : buzzerTimer!.cancel();
    legChangeTimer == null ? null : legChangeTimer!.cancel();
    animationValues == null ? null : await animationValues!.cancel();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    if (data.isNotEmpty) {
      print("testing 1 data uploading");
      print(data);
      // API.addData(data);
    }
  }

  @override
  void dispose() {
    swingTimer?.cancel();
    buzzerTimer?.cancel();
    legChangeTimer?.cancel();
    animationValues?.cancel();
    logTimer.cancel();
    if (data.length > 1) {
      print("testing 2 data uploading");
      print(data.length);
      data = [1];
      // API.addData(data);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<DeviceController, GameController,
            AnimationValuesController>(
        builder: (context, deviceController, gameController,
            animationValuesController, child) {
      return WillPopScope(
        child: Expanded(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: ElevatedButton(
              onPressed: () async {
                onPressed(
                  gameController,
                  deviceController,
                  animationValuesController,
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.maxFinite, 60.h),
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
                      style: TextStyle(
                          color: AppColor.whiteColor, fontSize: 18.sp),
                    ) ////Display a timer if the device
                  : Text(
                      "Start Game",
                      style: TextStyle(
                          color: AppColor.whiteColor, fontSize: 18.sp),
                    ),
            ),
          ),
        ),
        onWillPop: () {
          if (!gameController.gameStatus) {
            return Future.value(true);
          } else {
            return Future.value(false);
          }
        },
      );
    });
  }

  void handleGame(
    DeviceController deviceController,
    AnimationValuesController animationValuesController,
    GameController gameController,
  ) {
    bool legDown = true;
    gameController.resetGameScore();
    animationValues = deviceController.startStream();
    double raiseAngle = 0;
    int count = 0;
    swingTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      // print(state);
      // print("---->${widget.rightLegInput!.value},${count}");
      if (widget.rightLegInput!.value) {
        if (state == "middle to SbgL" || state == "middle to BbgL") {
          if (deviceController.rightAngleValue > 30 && legDown) {
            widget.animationStateController!
                .setInputValue(widget.legRaise!.id, true);
            gameController.incrementScore();

            raiseAngle = deviceController.rightAngleValue;
            legDown = false;
          }
          // legDown = false;
        } else if (state == "middle to BbgR" || state == "middle to SbgR") {
          // print("$raiseAngle, ${deviceController.rightAngleValue}");
          if (deviceController.rightAngleValue < raiseAngle - 15) {
            legDown = true;
          }
          widget.animationStateController!
              .setInputValue(widget.legRaise!.id, false);
        }
      } else {
        if (state == "middle to SbgL" || state == "middle to BbgL") {
          if (deviceController.leftAngleValue > 30 && legDown) {
            widget.animationStateController!
                .setInputValue(widget.legRaise!.id, true);
            gameController.incrementScore();

            raiseAngle = deviceController.leftAngleValue;
            legDown = false;
          }
          // legDown = false;
        } else if (state == "middle to BbgR" || state == "middle to SbgR") {
          if (deviceController.leftAngleValue < raiseAngle - 15) {
            legDown = true;
          }
          widget.animationStateController!
              .setInputValue(widget.legRaise!.id, false);
        }
      }
    });

    /// timer to send buzzer and toast
    buzzerTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (count < 4) {
        if (state == 'SbgR to middle' || state == 'BbgR to middle') {
          Fluttertoast.showToast(msg: "Raise Your leg !!!!");
          await deviceController.sendToDevice("beepc 4;", WRITECHARACTERISTICS);
          // count++;
        } else if (state == 'SbgL to middle' || state == 'BbgL to middle') {
          Fluttertoast.showToast(msg: "Drop Your leg !!!!");
          if (widget.legRaise!.value) {
            if (rhythm < 4) rhythm++;
          } else {
            if (rhythm > 0) rhythm--;
          }
          count++;
          // await deviceController.sendToDevice("beepc 4;", WRITECHARACTERISTICS);
        }
      } else if (count >= 4 && count < 8) {
        widget.rightLegInput!.value = false;
        if (state == 'SbgR to middle' || state == 'BbgR to middle') {
          Fluttertoast.showToast(msg: "Raise Your leg !!!!");
          await deviceController.sendToDevice("beeps 4;", WRITECHARACTERISTICS);
          // count++;
        } else if (state == 'SbgL to middle' || state == 'BbgL to middle') {
          Fluttertoast.showToast(msg: "Drop Your leg !!!!");
          if (widget.legRaise!.value) {
            if (rhythm < 4) rhythm++;
          } else {
            if (rhythm > 0) rhythm--;
          }
          count++;
          // await deviceController.sendToDevice("beepc 4;", WRITECHARACTERISTICS);
        }
      } else if (count == 8) {
        widget.rightLegInput!.value = true;
        count = 0;
      }
    });
  }

  void onPressed(
      GameController gameController,
      DeviceController deviceController,
      AnimationValuesController animationValuesController) async {
    //check if the game is running or not
    rhythm = 0;
    if (gameController.gameStatus == true) {
      //// stop the game and handle upload to cloud
      gameController.stopTimer();
      WakelockPlus.disable();
      if (animationValues != null) {
        await animationValues!.cancel();
      }
      gameController.changeGameStatus(false);
      // ballPeriodicTimer == null ? null : ballPeriodicTimer!.cancel();
      swingTimer == null ? null : swingTimer!.cancel();
      buzzerTimer == null ? null : buzzerTimer!.cancel();
      logTimer.cancel();
      // FirebaseDB.storeGameData(data);
      API.addData(data);
      data = [1];
      // if (gameController.secondsPlayed > 10) {
      CustomDialogs.showScoreUplodingDialog(context);
      Navigator.of(context, rootNavigator: true).pop();
      gameController.resetTimer();
      gameController.resetGameScore();
      // }
    } else {
      gameController.startTimer();
      WakelockPlus.enable();
      print(data.length);
      widget.rightLegInput!.value = true;
      handleGame(deviceController, animationValuesController, gameController);
      gameController.changeGameStatus(true);
      logTimer =
          Timer.periodic(const Duration(milliseconds: 10), (timer) async {
        int isBuzzer =
            (state == 'SbgR to middle' || state == 'BbgR to middle') ? 1 : 0;
        String score =
            "busser beeped : $isBuzzer, RLA: ${widget.rightAngleInput?.value}, LLA: ${widget.leftAngleInput?.value}, score: ${gameController.scores}, ${DateTime.now().millisecondsSinceEpoch}";
        // print(score);
        data.add(score);
      });
    }
  }
}

//working logic for leg raise
// swingTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       print(state);
//       if (state == "middle to SbgL" || state == "middle to BbgL") {
//         if (deviceController.rightAngleValue > 30) {
//           widget.animationStateController!
//               .setInputValue(widget.legRaise!.id, true);
//           if (!gameController.isIncremented) {
//             gameController.incrementScore();
//             gameController.changeIncremented(true);
//           }
//         }
//       } else if (state == "middle to BbgR") {
//         //}""BbgL to middle") {
//         setState(() {
//           widget.animationStateController!
//               .setInputValue(widget.legRaise!.id, false);
//         });
//       }


// swingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
//       sec += 0.5;
//       print(sec);
//       print("----->$sec,${gameController.scores.toString()}");
//       if (sec <= 1) {
//         print("----->$sec,${gameController.scores.toString()}");
//         if (deviceController.rightAngleValue > 30) {
//           if (!gameController.isIncremented) {
//             gameController.incrementScore();
//             gameController.changeIncremented(true);
//           }
//           largeSwing = true;
//           sec = -1;
//         } else {
//           largeSwing = false;
//         }
//         // widget.animationStateController!.setInputValue(
//         //   widget.bgHeight!.id,
//         //   gameController.scores * 10,
//         // );
//       } else {
//         setState(() {
//           widget.animationStateController!
//               .setInputValue(widget.legRaise!.id, largeSwing);
//         });
//         //  if (largeSwing) {
//         //    setState(() {
//         //      widget.animationStateController!
//         //          .setInputValue(widget.legRaise!.id, true);
//         //    });
//         //   largeSwing = false;
//         //  }
//         //  else {
//         //    setState(() {
//         //      widget.animationStateController!
//         //          .setInputValue(widget.legRaise!.id, false);
//         //    });
//         //  }
//     }

//       if (sec % 4 == 0) {
//         Fluttertoast.showToast(msg: "Raise Your leg !!!!");
//       }
//     });

//     ballPeriodicTimer = Timer.periodic(
//       const Duration(seconds: 4),
//       (timer) async {
//         // if (largeSwing) {
//         //   widget.animationStateController!
//         //       .setInputValue(widget.legRaise!.id, true);
//         // } else {
//         //   widget.animationStateController!
//         //       .setInputValue(widget.legRaise!.id, false);
//         // }
//         gameController.changeIncremented(false);
//         sec = 0;
//         // Fluttertoast.showToast(msg: "Get ready Right Ball is coming !!!!");
//       },
//     );