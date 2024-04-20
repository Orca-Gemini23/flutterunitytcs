// // ignore_for_file: unused_field, unused_import

import 'dart:async';
// import 'dart:math';
// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/animation_controller.dart';
import 'package:walk/src/controllers/device_controller.dart';
// import 'package:walk/src/controllers/game_controller.dart';
import 'package:walk/src/utils/animationloader_isolate.dart';
// import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/widgets/dialog.dart';

import 'package:walk/src/widgets/therapypage/fishtherapystartstopbutton.dart';

String state = "hi";

class RiveFishAnimationPage extends StatefulWidget {
  const RiveFishAnimationPage({super.key});

  @override
  State<RiveFishAnimationPage> createState() => _RiveFishAnimationPageState();
}

class _RiveFishAnimationPageState extends State<RiveFishAnimationPage>
    with WidgetsBindingObserver {
  StateMachineController? _stateMachineController;
  SMIInput<double>? _rightAngleInput;
  SMIInput<double>? _leftAngleInput;
  SMIInput<bool>? _fish1flag1;
  SMIInput<bool>? _fish1flag2;
  SMIInput<bool>? _fish2flag1;
  SMIInput<bool>? _fish2flag2;
  SMIInput<bool>? _fish3flag1;
  SMIInput<bool>? _fish3flag2;
  SMIInput<bool>? _fish4flag1;
  SMIInput<bool>? _fish4flag2;
  SMIInput<bool>? _fish5flag1;
  SMIInput<bool>? _fish5flag2;
  SMIInput<bool>? _timer2;
  SMIInput<bool>? _timer1;

  bool isDialogup = true;
  StreamSubscription<List<int>>? animationAngleValueStream;
  Future<RiveFile>? _riveFile;

  DeviceController? deviceController;
  AnimationValuesController? animationValuesController;

  void _onRiveInit(Artboard artboard) {
    var controller = StateMachineController.fromArtboard(
      artboard,
      'fish game',
      onStateChange: _onStateChange,
    );
    artboard.addController(controller!);
    _rightAngleInput = controller.findInput<double>('fishLineNum');
    _fish1flag1 = controller.findInput<bool>('fish1flag1');
    _fish1flag2 = controller.findInput<bool>('fish1flag2');
    _fish2flag1 = controller.findInput<bool>('fish2flag1');
    _fish2flag2 = controller.findInput<bool>('fish2flag2');
    _fish3flag1 = controller.findInput<bool>('fish3flag1');
    _fish3flag2 = controller.findInput<bool>('fish3flag2');
    _fish4flag1 = controller.findInput<bool>('fish4flag1');
    _fish4flag2 = controller.findInput<bool>('fish4flag2');
    _fish5flag1 = controller.findInput<bool>('fish5flag1');
    _fish5flag2 = controller.findInput<bool>('fish5flag2');
    _timer1 = controller.findInput<bool>('timer 1');
    _timer2 = controller.findInput<bool>('timer 2');

    setState(() {
      _stateMachineController = controller;
    });
  }

  void _onStateChange(
    String stateMachineName,
    String stateName,
  ) =>
      setState(() {
        state = stateName;
      });

  @override
  void initState() {
    super.initState();
    _riveFile = Animationloader.loadFishAnimation();
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
        child: Consumer2<DeviceController, AnimationValuesController>(
          builder:
              (context, deviceController, animationValuesController, child) {
            _leftAngleInput?.value = animationValuesController.leftAngleValue;
            _rightAngleInput?.value = animationValuesController.rightAngleValue;
            print("----> ${_timer1?.value}");
            // _legRaise?.value = true;
            // _bgHeight?.value = 70;
            // print(_bgHeight?.value);
            // print(_rhythmNumber?.value);
            // _rhythmNumber?.value = 90;
            // print(_rhythmNumber?.value);

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
                      child: FutureBuilder<RiveFile>(
                        future: _riveFile,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              return RiveAnimation.direct(
                                snapshot.data!,
                                stateMachines: const [
                                  "Swing game",
                                  "rhythm meter bar"
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
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
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
                    SwingAnimationControlButton(
                      animationStateController: _stateMachineController,
                      rightAngleInput: _rightAngleInput,
                      leftAngleInput: animationValuesController.leftAngleValue,
                      fish1flag1: _fish1flag1,
                      fish1flag2: _fish1flag2,
                      fish2flag1: _fish2flag1,
                      fish2flag2: _fish2flag2,
                      timer1: _timer1,
                      timer2: _timer2,
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
