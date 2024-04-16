// ignore_for_file: must_be_immutable

import "dart:async";
// import "dart:math";
// import "dart:developer" as dev;
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
// import "package:fluttertoast/fluttertoast.dart";
import "package:provider/provider.dart";
import "package:rive/rive.dart";
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
  });

  StateMachineController? animationStateController;
  SMIInput<double>? rhythmNumber;
  SMIInput<double>? bgHeight;
  SMIInput<bool>? legRaise;
  SMIInput<double>? rightAngleInput;
  double? leftAngleInput;

  @override
  State<SwingAnimationControlButton> createState() =>
      _SwingAnimationControlButtonState();
}

class _SwingAnimationControlButtonState
    extends State<SwingAnimationControlButton> {
  StreamSubscription<List<int>>? animationValues;
  // Timer? ballPeriodicTimer;
  Timer? swingTimer;
  Timer? buzzerTimer;
  Timer logTimer = Timer(Duration.zero, () {});
  List<dynamic> data = [1];

  Future<void> disposeEssentials() async {
    // ballPeriodicTimer == null ? null : ballPeriodicTimer!.cancel();
    swingTimer == null ? null : swingTimer!.cancel();
    buzzerTimer == null ? null : buzzerTimer!.cancel();
    animationValues == null ? null : await animationValues!.cancel();
  }

  @override
  void dispose() {
    // ballPeriodicTimer?.cancel();
    swingTimer?.cancel();
    buzzerTimer?.cancel();
    animationValues?.cancel();
    logTimer.cancel();
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
          minimumSize: Size(double.maxFinite, 49.h),
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
    GameController gameController,
  ) {
    bool legDown = true;
    gameController.resetGameScore();
    animationValues = deviceController.startStream();
    double raiseAngle = 0;
    swingTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      // print(state);
      if (state == "middle to SbgL" || state == "middle to BbgL") {
        // print(
        // "${legDown.toString()},"); // ${deviceController.rightAngleValue}");
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
        if (deviceController.rightAngleValue < raiseAngle) {
          legDown = true;
        }
        setState(() {
          widget.animationStateController!
              .setInputValue(widget.legRaise!.id, false);
        });
      }
    });

    buzzerTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (state == 'SbgR to middle' || state == 'BbgR to middle') {
        await deviceController.sendToDevice("beepc 4;", WRITECHARACTERISTICS);
      }
      // else if (state == 'SbgL to middle' || state == 'BbgL to middle') {
      //   await deviceController.sendToDevice("beepc 4;", WRITECHARACTERISTICS);
      // }
    });
  }

  void onPressed(
      GameController gameController,
      DeviceController deviceController,
      AnimationValuesController animationValuesController) async {
    //check if the game is running or not
    if (gameController.gameStatus == true) {
      //// stop the game and handle upload to cloud
      gameController.stopTimer();
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
      if (gameController.secondsPlayed > 10) {
        CustomDialogs.showScoreUplodingDialog(context);
        Navigator.of(context, rootNavigator: true).pop();
        gameController.resetTimer();
        gameController.resetGameScore();
      }
    } else {
      gameController.startTimer();
      handleGame(deviceController, animationValuesController, gameController);
      gameController.changeGameStatus(true);
      logTimer =
          Timer.periodic(const Duration(milliseconds: 10), (timer) async {
        int isBuzzer =
            (state == 'SbgR to middle' || state == 'BbgR to middle') ? 1 : 0;
        String score =
            "busser beeped : $isBuzzer, RLA: ${widget.rightAngleInput?.value}, LLA: ${widget.leftAngleInput}, score: ${gameController.scores}, ${DateTime.now().millisecondsSinceEpoch}";
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