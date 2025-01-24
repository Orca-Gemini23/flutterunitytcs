import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/bt_constants.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/pages/reaction_time.dart';
import 'package:walk/src/utils/firebase/firebase_db.dart';
import 'package:walk/src/utils/global_variables.dart';

class LeftLegUp extends StatefulWidget {
  const LeftLegUp({super.key});

  @override
  _LeftLegUpState createState() => _LeftLegUpState();
}

class _LeftLegUpState extends State<LeftLegUp> with TickerProviderStateMixin {
  late StreamSubscription<List<int>> stream;
  double angle = 0.0;
  bool isButtonEnabled = false;
  late AnimationController _controller;
  late AnimationController _lottieController;
  late Animation<double> _animation;

  List<double> angles = [];

  @override
  void initState() {
    context
        .read<DeviceController>()
        .sendToDevice("beeps 5;", WRITECHARACTERISTICS);
    super.initState();
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
          if (dataArr[0] == "L") {
            var ax = double.parse(dataArr[2]);
            var ay = double.parse(dataArr[3]);
            var az = double.parse(dataArr[4]);
            setState(() {
              angle =
                  (((180 / 3.14) * atan(ax / sqrt(ay * ay + az * az)) / 90) -
                          1) *
                      -1;
              print(angle / 2);
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
                    width: 385 / 2,
                    height: 835 / 2,
                    child: LottieBuilder.network(
                      "https://cdn.lottielab.com/l/3KB22tnbUXoN9f.json",
                      controller: _lottieController,
                      backgroundLoading: true,
                    ),
                  ),
                  Column(
                    children: [
                      Transform.translate(
                        offset: const Offset(0, -150),
                        child: Column(
                          children: [
                            const Text(
                              'Left',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset(
                                  'assets/images/left_leg_indicator.png'),
                            ),
                            const SizedBox(height: 10),
                            if (_controller.isAnimating)
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
                        angle: pi / 2,
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
                      text: 'left leg',
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
                width: 300,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: isButtonEnabled
                      ? () {
                          FirebaseDB.currentDb
                              .collection("frs")
                              .doc(testId)
                              .update({"left_angles": angles});
                          stream.cancel();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ReactionTime()),
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
