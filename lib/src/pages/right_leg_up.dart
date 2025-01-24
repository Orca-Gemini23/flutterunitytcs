import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/bt_constants.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/utils/firebase/firebase_db.dart';
import 'package:walk/src/utils/global_variables.dart';

import 'left_leg_up.dart';

class RightLegUp extends StatefulWidget {
  const RightLegUp({super.key});

  @override
  _RightLegUpState createState() => _RightLegUpState();
}

class _RightLegUpState extends State<RightLegUp> with TickerProviderStateMixin {
  late StreamSubscription<List<int>> stream;
  double angle = 0.0;
  bool isButtonEnabled = false;
  late AnimationController _controller;
  late AnimationController _lottieController;

  late Animation<double> _animation;

  List<double> angles = [];

  @override
  void initState() {
    super.initState();
    context
        .read<DeviceController>()
        .sendToDevice("beepc 5;", WRITECHARACTERISTICS);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        setState(() {});
      });
    _lottieController = AnimationController(
      vsync: this,
    );

    _animation = Tween<double>(begin: 3, end: 0).animate(_controller);

    BluetoothCharacteristic? targetCharacteristic = context
        .read<DeviceController>()
        .characteristicMap[WRITECHARACTERISTICS];
    if (targetCharacteristic != null) {
      targetCharacteristic.setNotifyValue(true);
      stream = targetCharacteristic.onValueReceived.listen(
        (value) {
          String data = String.fromCharCodes(value);
          var dataArr = data.split(" ");
          if (dataArr[0] == "R") {
            var ax = double.parse(dataArr[2]);
            var ay = double.parse(dataArr[3]);
            var az = double.parse(dataArr[4]);
            setState(() {
              angle =
                  1 - (atan(ax / sqrt(ay * ay + az * az)) * (180 / pi) / -90);
              _lottieController.value = 1 - angle;
            });
            if (_controller.isAnimating) {
              angles.add(angle);
            }
            if (angle.abs() <= 0.65) {
              if (!_controller.isAnimating && !isButtonEnabled) {
                _controller.forward(from: 0);
              }
            }
          }
        },
      );
    }

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isButtonEnabled = true;
        });
      }
    });
  }

  @override
  void dispose() {
    stream.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              //pop until /home
              Navigator.popUntil(context, ModalRoute.withName('/home'));
            },
          )
        ],
      ),
      body: Center(
        child: FractionallySizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 385 / 2, // Set the desired width
                    height: 835 / 2, // Set the desired height
                    child: LottieBuilder.network(
                      "https://cdn.lottielab.com/l/BJYMdRFKxav1Wr.json",
                      controller: _lottieController,
                      // backgroundLoading: true,
                    ),
                  ),
                  Column(
                    children: [
                      Transform.translate(
                        offset: const Offset(0, -150),
                        child: Column(
                          children: [
                            const Text(
                              'Right',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              width: 100,
                              // Set the desired width for the indicator
                              height: 100,
                              // Set the desired height for the indicator
                              child: Image.asset(
                                  'assets/images/right_leg_indicator.png'),
                            ),
                            const SizedBox(height: 10),
                            if (_controller
                                .isAnimating) // Show only if animating
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                      value: _controller.value,
                                      backgroundColor: AppColor.primary,
                                      valueColor: const AlwaysStoppedAnimation(
                                          AppColor.lightgreen),
                                    ),
                                  ),
                                  Text(
                                    _animation.value.toInt().toString(),
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      Transform.rotate(
                        angle: pi / 2, // Simplified angle calculation
                        child: SizedBox(
                          width: 150,
                          height: 75,
                          child: LinearProgressIndicator(
                            value: angle,
                            backgroundColor: AppColor.primary,
                            valueColor: const AlwaysStoppedAnimation(
                                AppColor.lightgreen),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
              const Text.rich(
                TextSpan(
                  text: 'Lift your ',
                  children: <TextSpan>[
                    TextSpan(
                      text: 'right leg',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' as high as possible.',
                    ),
                  ],
                ),
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 300, // Set the desired width
                height: 50, // Set the desired height
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary, // Dark green color
                    foregroundColor: Colors.white, // White text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // Slight curve
                    ),
                  ),
                  onPressed: isButtonEnabled
                      ? () {
                          FirebaseDB.currentDb
                              .collection("frs")
                              .doc(testId)
                              .update({"right_angles": angles});
                          stream.cancel();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LeftLegUp()),
                          );
                        }
                      : null,
                  child: const Text(
                    "Next",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
