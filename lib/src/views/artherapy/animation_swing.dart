// // ignore_for_file: unused_field, unused_import

import 'dart:async';
// import 'dart:math';
// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as r;
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/animation_controller.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/controllers/game_controller.dart';
import 'package:walk/src/utils/animationloader_isolate.dart';
// import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/widgets/dialog.dart';
// import 'package:flutter/widgets.dart';

import 'package:walk/src/widgets/therapypage/swingtherapystartstopbutton.dart';

String state = "hi";
int rhythm = 0;

extension _TextExtension on r.Artboard {
  r.TextValueRun? textRun(String name) => component<r.TextValueRun>(name);
}

class RiveSwingAnimationPage extends StatefulWidget {
  const RiveSwingAnimationPage({super.key});

  @override
  State<RiveSwingAnimationPage> createState() => _RiveSwingAnimationPageState();
}

class _RiveSwingAnimationPageState extends State<RiveSwingAnimationPage>
    with WidgetsBindingObserver {
  r.StateMachineController? _stateMachineController;
  r.SMIInput<double>? _rightAngleInput;
  r.SMIInput<double>? _leftAngleInput;
  r.SMIInput<bool>? _rightlegInput;
  r.SMIInput<bool>? _legRaise;
  r.SMIInput<double>? _bgHeight;
  r.SMIInput<double>? _rhythmNumber;

  bool isDialogup = true;
  StreamSubscription<List<int>>? animationAngleValueStream;
  Future<r.RiveFile>? _riveFile;

  DeviceController? deviceController;
  AnimationValuesController? animationValuesController;
  GameController? gameController;
  dynamic score;

  void _onRiveInit(r.Artboard artboard) {
    var controller = r.StateMachineController.fromArtboard(
      artboard,
      'Swing game',
      onStateChange: _onStateChange,
    );

    score = artboard.textRun("present score");

    artboard.addController(controller!);
    _rightAngleInput = controller.findInput<double>('rightlegMovement');
    _leftAngleInput = controller.findInput<double>('leftlegMovement');
    _rightlegInput = controller.findInput<bool>('rightLeg');
    _legRaise = controller.findInput<bool>('legRaise');
    _bgHeight = controller.findInput<double>('backgroundHeight');
    _rhythmNumber = controller.findInput<double>('rhythmNumber');

    setState(() {
      _stateMachineController = controller;
    });
  }

  void _onStateChange(
    String stateMachineName,
    String stateName,
  ) =>
      setState(
        () {
          state = stateName;
          // print(state);
          // if (stateName == 'SL to middle' || stateName == 'BL to middle') {
          //   Fluttertoast.showToast(msg: "Raise Your leg !!!!");
          // } else if (stateName == 'SR to middle' ||
          //     stateName == 'BR to middle') {
          //   Fluttertoast.showToast(msg: "Drop Your leg !!!!");
          // }
        },
      );

  @override
  void initState() {
    super.initState();
    _riveFile = Animationloader.loadSwingAnimation();
  }

  @override
  Future<void> dispose() async {
    Future.delayed(Duration.zero, () async {
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
        systemOverlayStyle: SystemUiOverlayStyle.dark,
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
        bottom: false,
        maintainBottomViewPadding: true,
        child: Consumer3<DeviceController, AnimationValuesController,
            GameController>(
          builder: (context, deviceController, animationValuesController,
              gameController, child) {
            _leftAngleInput?.value = animationValuesController.leftAngleValue;
            _rightAngleInput?.value = animationValuesController.rightAngleValue;
            _bgHeight?.value = gameController.scores * 5.0;
            _rhythmNumber?.value = 90;
            // print(score);
            score?.text = gameController.scores.toString();
            // print(score);
            print(rhythm);

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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 360.w,
                      height: 640.h,
                      child: Stack(
                        children: [
                          FutureBuilder<r.RiveFile>(
                            future: _riveFile,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  return r.RiveAnimation.direct(
                                    snapshot.data!,
                                    stateMachines: const [
                                      "Swing game",
                                    ],
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
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: 68,
                                width: 148,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xFFFFF6E4),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Rhythm Meter",
                                      style: TextStyle(
                                        color: Color(0xFF352F2B),
                                        fontFamily: 'poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            Icon(
                                              Icons.assessment,
                                              color: rhythm < 2
                                                  ? const Color(0xFFCA0A2C)
                                                  : const Color(0xFF4BB830),
                                            ),
                                            const Icon(
                                              Icons.assessment_outlined,
                                              color: Color(0xFF352F2B),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 100,
                                          height: 12.5,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment
                                                  .centerLeft, //Starting point
                                              end: Alignment.centerRight,
                                              stops: [0.25 * rhythm, 0],
                                              colors: [
                                                rhythm < 2
                                                    ? const Color(0xFFCA0A2C)
                                                    : const Color(0xFF4BB830),
                                                const Color(0xFF352F2B)
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(2.5),
                                          ),
                                          //
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Container(
                    //       padding: const EdgeInsets.symmetric(
                    //           horizontal: 8, vertical: 4),
                    //       width: 100.w,
                    //       decoration: const BoxDecoration(
                    //           shape: BoxShape.circle,
                    //           color: AppColor.lightgreen),
                    //       child: Center(
                    //         child: Text(
                    //           "${animationValuesController.leftAngleValue}",
                    //           style: TextStyle(
                    //             fontSize: 14.sp,
                    //             color: AppColor.greenDarkColor,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     Container(
                    //       padding: const EdgeInsets.symmetric(
                    //           horizontal: 8, vertical: 4),
                    //       width: 100.w,
                    //       decoration: const BoxDecoration(
                    //           shape: BoxShape.circle,
                    //           color: AppColor.lightgreen),
                    //       child: Center(
                    //         child: Text(
                    //           "${animationValuesController.rightAngleValue}",
                    //           style: TextStyle(
                    //             fontSize: 14.sp,
                    //             color: AppColor.greenDarkColor,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    SwingAnimationControlButton(
                      animationStateController: _stateMachineController,
                      rightAngleInput: _rightAngleInput,
                      leftAngleInput: _leftAngleInput,
                      rightLegInput: _rightlegInput,
                      legRaise: _legRaise,
                      bgHeight: _bgHeight,
                      rhythmNumber: _rhythmNumber,
                      artboardScore: "0",
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
