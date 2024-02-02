// ignore_for_file: unused_field, unused_import

import 'dart:async';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/animation_controller.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/controllers/game_controller.dart';
import 'package:walk/src/utils/animationloader_isolate.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/widgets/dialog.dart';
import 'dart:developer' as dev;

import 'package:walk/src/widgets/therapypage/startstoptherapybutton.dart';

class RiveAnimationPage extends StatefulWidget {
  const RiveAnimationPage({super.key});

  @override
  State<RiveAnimationPage> createState() => _RiveAnimationPageState();
}

class _RiveAnimationPageState extends State<RiveAnimationPage>
    with WidgetsBindingObserver {
  StateMachineController? _stateMachineController;
  SMIInput<double>? _leftAngleInput;
  SMIInput<double>? _rightAngleInput;
  SMIInput<double>? _leftballInput;
  SMIInput<double>? _rightballInput;
  SMIInput<bool>? _sendRightBall;
  SMIInput<bool>? _sendLeftBall;
  bool isDialogup = true;
  late Future<RiveFile> _riveFileFuture;
  StreamSubscription<List<int>>? animationAngleValueStream;
  Future<RiveFile>? _riveFile;
  bool gameStatus = false;
  int randomNumber = 0;
  Timer? ballGenTimer;
  DeviceController? deviceController;
  AnimationValuesController? animationValuesController;
  double sliderValue = 25;

  void _onRiveInit(Artboard artboard) {
    var controller =
        StateMachineController.fromArtboard(artboard, 'LegsManipulator');
    artboard.addController(controller!);
    _leftAngleInput = controller.findInput<double>('leftMove');
    _rightAngleInput = controller.findInput<double>('rightMove');
    _rightballInput = controller.findInput<double>('rightballvalue');
    _leftballInput = controller.findInput<double>('leftballvalue');
    _sendLeftBall = controller.findInput<bool>('leftBall');
    _sendRightBall = controller.findInput<bool>('rightBall');

    setState(() {
      _stateMachineController = controller;
    });
  }

  @override
  void initState() {
    super.initState();
    _riveFile = Animationloader.loadAnimation();
  }

  @override
  Future<void> dispose() async {
    Future.delayed(Duration.zero, () async {
      ballGenTimer == null ? null : ballGenTimer!.cancel();
      animationAngleValueStream == null
          ? null
          : await animationAngleValueStream!.cancel();

      _stateMachineController!.dispose();
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.whiteColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: AppColor.blackColor,
        ),
        title: const Text(
          "Therapy Mode",
          style: TextStyle(
            color: AppColor.blackColor,
            fontSize: 16,
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer2<DeviceController, AnimationValuesController>(
          builder:
              (context, deviceController, animationValuesController, child) {
            _leftAngleInput?.value = animationValuesController.leftAngleValue;
            _rightAngleInput?.value = animationValuesController.rightAngleValue;

            return StreamBuilder<BluetoothConnectionState>(
              stream: deviceController.connectedDevice?.connectionState ??
                  const Stream.empty(),
              builder: (context, snapshot) {
                if (snapshot.data == BluetoothConnectionState.disconnected) {
                  // deviceController.clearConnectedDevice();
                  if (isDialogup) {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (timeStamp) {
                        setState(() {
                          isDialogup = false;
                        });
                        deviceController.clearConnectedDevice();

                        CustomDialogs.showBleDisconnectedDialog(context);
                      },
                    );
                  }
                }
                return Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Score",
                          style: TextStyle(
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Container(
                          width: 100.w,
                          height: 50.h,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: AppColor.lightgreen,
                              borderRadius: BorderRadius.circular(10),
                              shape: BoxShape.rectangle),
                          child: Center(
                            child: Consumer<GameController>(
                                builder: (context, gameController, widget) {
                              return Text(
                                gameController.scores.toString(),
                                style: TextStyle(fontSize: 16.sp),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 450.w,
                      height: 450.h,
                      child: FutureBuilder<RiveFile>(
                        future: _riveFile,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              return RiveAnimation.direct(
                                snapshot.data!,
                                stateMachines: const ["LegsManipulator"],
                                onInit: _onRiveInit,
                              );
                            }
                          }
                          return Container(
                            width: 500.w,
                            height: 500.h,
                            decoration: const BoxDecoration(
                              color: AppColor.lightbluegrey,
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColor.greenDarkColor,
                                strokeWidth: 7,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          width: 100.w,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColor.lightgreen),
                          child: Center(
                            child: Text(
                              "${animationValuesController.leftAngleValue}",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColor.greenDarkColor,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          width: 100.w,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColor.lightgreen),
                          child: Center(
                            child: Text(
                              "${animationValuesController.rightAngleValue}",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColor.greenDarkColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      child: Consumer<GameController>(
                          builder: (context, gameController, child) {
                        return SliderTheme(
                          data: const SliderThemeData(
                            trackHeight: 8,
                            activeTrackColor: AppColor.greenDarkColor,
                            thumbColor: AppColor.greenDarkColor,
                          ),
                          child: Slider(
                              value: gameController.getVibrationPosition(),
                              onChanged: (value) {},
                              min: 0,
                              max: 40,
                              label: gameController
                                  .getVibrationPosition()
                                  .toString(),
                              onChangeEnd: (value) {
                                gameController.changeVibrationPostion(value);
                              }),
                        );
                      }),
                    ),
                    AnimationControlButton(
                      animationStateController: _stateMachineController,
                      leftballInput: _leftballInput,
                      rightballInput: _rightballInput,
                      sendLeftBall: _sendLeftBall,
                      sendRightBall: _sendRightBall,
                      rightAngleInput: _rightAngleInput,
                      leftAngleInput: _leftAngleInput,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
