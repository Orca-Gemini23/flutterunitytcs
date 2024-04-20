// ignore_for_file: must_be_immutable

import "dart:async";
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
import "package:walk/src/views/artherapy/animation_fish.dart";
import "package:walk/src/server/api.dart";
// import "package:walk/src/utils/firebasehelper.dart/firebasedb.dart";
import "package:walk/src/widgets/dialog.dart";

class SwingAnimationControlButton extends StatefulWidget {
  SwingAnimationControlButton({
    super.key,
    required this.animationStateController,
    required this.fish1flag1,
    required this.fish1flag2,
    required this.fish2flag1,
    required this.fish2flag2,
    required this.rightAngleInput,
    required this.leftAngleInput,
    required this.timer1,
    required this.timer2,
  });

  StateMachineController? animationStateController;
  SMIInput<double>? rightAngleInput;
  double? leftAngleInput;
  SMIInput<bool>? fish1flag1;
  SMIInput<bool>? fish1flag2;
  SMIInput<bool>? fish2flag1;
  SMIInput<bool>? fish2flag2;
  SMIInput<bool>? timer2;
  SMIInput<bool>? timer1;

  @override
  State<SwingAnimationControlButton> createState() =>
      _SwingAnimationControlButtonState();
}

class _SwingAnimationControlButtonState
    extends State<SwingAnimationControlButton> {
  StreamSubscription<List<int>>? animationValues;
  Timer? swingTimer;
  Timer? buzzerTimer;
  Timer logTimer = Timer(Duration.zero, () {});
  List<dynamic> data = [1];

  Future<void> disposeEssentials() async {
    swingTimer == null ? null : swingTimer!.cancel();
    buzzerTimer == null ? null : buzzerTimer!.cancel();
    animationValues == null ? null : await animationValues!.cancel();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
      return Expanded(
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
                    style:
                        TextStyle(color: AppColor.whiteColor, fontSize: 18.sp),
                  ) ////Display a timer if the device
                : Text(
                    "Start Game",
                    style:
                        TextStyle(color: AppColor.whiteColor, fontSize: 18.sp),
                  ),
          ),
        ),
      );
    });
  }

  void handleGame(
    DeviceController deviceController,
    AnimationValuesController animationValuesController,
    GameController gameController,
  ) {
    gameController.resetGameScore();
    animationValues = deviceController.startStream();
    bool fish1 = false;
    bool fish2 = false;
    bool fish3 = false;
    bool fish4 = false;
    bool fish5 = false;
    double ft1 = 0;
    double ft2 = 0;
    double ft3 = 0;
    double ft4 = 0;
    double ft5 = 0;
    swingTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (20 <= deviceController.rightAngleValue &&
          deviceController.rightAngleValue <= 30) {
        widget.animationStateController!
            .setInputValue(widget.fish1flag1!.id, true);
        widget.animationStateController!.setInputValue(widget.timer1!.id, true);
        widget.animationStateController!
            .setInputValue(widget.fish2flag1!.id, false);
        fish1 = true;
        fish2 = false;
      } else if (35 <= deviceController.rightAngleValue &&
          deviceController.rightAngleValue <= 45) {
        widget.animationStateController!
            .setInputValue(widget.fish1flag1!.id, false);
        widget.animationStateController!.setInputValue(widget.timer1!.id, true);
        widget.animationStateController!
            .setInputValue(widget.fish2flag1!.id, true);
        fish2 = true;
        fish1 = false;
      } else {
        fish1 = false;
        fish2 = false;
        widget.animationStateController!
            .setInputValue(widget.timer1!.id, false);
        widget.animationStateController!
            .setInputValue(widget.fish2flag1!.id, false);
        widget.animationStateController!
            .setInputValue(widget.fish1flag1!.id, false);
      }
      if (fish1) {
        ft1 += 0.1;
      } else {
        ft1 = 0;
      }
      if (fish2) {
        ft2 += 0.1;
      } else {
        ft2 = 0;
      }
      if (ft1 >= 2) {
        widget.animationStateController!
            .setInputValue(widget.fish1flag1!.id, false);
        widget.animationStateController!
            .setInputValue(widget.fish1flag2!.id, true);
        ft1 = 0;
        widget.animationStateController!
            .setInputValue(widget.timer1!.id, false);
        widget.animationStateController!.setInputValue(widget.timer2!.id, true);
        widget.animationStateController!
            .setInputValue(widget.rightAngleInput!.id, 0.0);
      } else if (ft2 >= 2) {
        widget.animationStateController!
            .setInputValue(widget.fish2flag1!.id, false);
        widget.animationStateController!
            .setInputValue(widget.fish2flag2!.id, true);
        ft2 = 0;
        widget.animationStateController!
            .setInputValue(widget.timer1!.id, false);
        widget.animationStateController!.setInputValue(widget.timer2!.id, true);
        widget.animationStateController!
            .setInputValue(widget.rightAngleInput!.id, 0.0);
      }
      if (state.contains("reappear")) {
        widget.animationStateController!
            .setInputValue(widget.fish1flag2!.id, false);
        widget.animationStateController!
            .setInputValue(widget.fish2flag2!.id, false);
        widget.animationStateController!
            .setInputValue(widget.timer2!.id, false);
        widget.animationStateController!
            .setInputValue(widget.rightAngleInput!.id, 0.0);
        fish1 = false;
        fish2 = false;
        ft1 = 0;
        ft2 = 0;
      }
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
      // API.addData(data);
      data = [1];
      // if (gameController.secondsPlayed > 10) {
      CustomDialogs.showScoreUplodingDialog(context);
      Navigator.of(context, rootNavigator: true).pop();
      gameController.resetTimer();
      gameController.resetGameScore();
      // }
    } else {
      gameController.startTimer();
      print(data.length);
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


/*
void handleGame(
    DeviceController deviceController,
    AnimationValuesController animationValuesController,
    GameController gameController,
  ) {
    gameController.resetGameScore();
    animationValues = deviceController.startStream();
    bool fish1 = false;
    bool fish2 = false;
    bool fish3 = false;
    bool fish4 = false;
    bool fish5 = false;
    double ft1 = 0;
    double ft2 = 0;
    double ft3 = 0;
    double ft4 = 0;
    double ft5 = 0;
    swingTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (20 <= deviceController.rightAngleValue &&
          deviceController.rightAngleValue <= 30) {
        widget.animationStateController!
            .setInputValue(widget.fish1flag1!.id, true);
        widget.animationStateController!.setInputValue(widget.timer1!.id, true);
        widget.animationStateController!
            .setInputValue(widget.fish2flag1!.id, false);
        fish1 = true;
        fish2 = false;
      } else if (35 <= deviceController.rightAngleValue &&
          deviceController.rightAngleValue <= 45) {
        widget.animationStateController!
            .setInputValue(widget.fish1flag1!.id, false);
        widget.animationStateController!.setInputValue(widget.timer1!.id, true);
        widget.animationStateController!
            .setInputValue(widget.fish2flag1!.id, true);
        fish2 = true;
        fish1 = false;
      } else {
        fish1 = false;
        fish2 = false;
        widget.animationStateController!
            .setInputValue(widget.timer1!.id, false);
        widget.animationStateController!
            .setInputValue(widget.fish2flag1!.id, false);
        widget.animationStateController!
            .setInputValue(widget.fish1flag1!.id, false);
      }
      if (fish1) {
        ft1 += 0.1;
      } else {
        ft1 = 0;
      }
      if (fish2) {
        ft2 += 0.1;
      } else {
        ft2 = 0;
      }
      if (ft1 >= 2) {
        widget.animationStateController!
            .setInputValue(widget.fish1flag1!.id, false);
        widget.animationStateController!
            .setInputValue(widget.fish1flag2!.id, true);
        ft1 = 0;
        widget.animationStateController!
            .setInputValue(widget.timer1!.id, false);
        widget.animationStateController!.setInputValue(widget.timer2!.id, true);
        widget.animationStateController!
            .setInputValue(widget.rightAngleInput!.id, 0.0);
      } else if (ft2 >= 2) {
        widget.animationStateController!
            .setInputValue(widget.fish2flag1!.id, false);
        widget.animationStateController!
            .setInputValue(widget.fish2flag2!.id, true);
        ft2 = 0;
        widget.animationStateController!
            .setInputValue(widget.timer1!.id, false);
        widget.animationStateController!.setInputValue(widget.timer2!.id, true);
        widget.animationStateController!
            .setInputValue(widget.rightAngleInput!.id, 0.0);
      }
      if (state.contains("reappear")) {
        widget.animationStateController!
            .setInputValue(widget.fish1flag2!.id, false);
        widget.animationStateController!
            .setInputValue(widget.fish2flag2!.id, false);
        widget.animationStateController!
            .setInputValue(widget.timer2!.id, false);
        widget.animationStateController!
            .setInputValue(widget.rightAngleInput!.id, 0.0);
        fish1 = false;
        fish2 = false;
        ft1 = 0;
        ft2 = 0;
      }
    });
  }
 */