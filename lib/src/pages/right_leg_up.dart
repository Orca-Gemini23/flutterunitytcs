import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
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

class _RightLegUpState extends State<RightLegUp>
    with SingleTickerProviderStateMixin {
  late StreamSubscription<List<int>> stream;
  double angle = 0.0;
  bool isButtonEnabled = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  List<double> angles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        setState(() {});
      });

    _animation = Tween<double>(begin: 3, end: 0).animate(_controller);

    context
        .read<DeviceController>()
        .sendToDevice("mode 9;", WRITECHARACTERISTICS);
    BluetoothCharacteristic? targetCharacteristic = context
        .read<DeviceController>()
        .characteristicMap[WRITECHARACTERISTICS];
    targetCharacteristic?.setNotifyValue(true);
    stream = targetCharacteristic!.onValueReceived.listen(
      (value) {
        String data = String.fromCharCodes(value);
        var dataArr = data.split(" ");
        if (dataArr[0] == "R") {
          var ax = double.parse(dataArr[2]);
          var ay = double.parse(dataArr[3]);
          var az = double.parse(dataArr[4]);
          setState(() {
            angle = 1 -
                (((((180 / 3.14) * atan(ax / sqrt(ay * ay + az * az))) / -90)));
          });
          if (_controller.isAnimating) {
            angles.add(angle);
          }
          if (angle.abs() <= 0.65) {
            if (!_controller.isAnimating && !isButtonEnabled) {
              _controller.forward(from: 0);
              _controller.addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                  setState(() {
                    isButtonEnabled = true;
                  });
                  _controller.stop();
                }
              });
            }
          }
        }
      },
    );
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
      body: Center(
        child: FractionallySizedBox(
          // widthFactor: 0., // Set the width to 80% of the total width
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 385 / 2, // Set the desired width
                    height: 835 / 2, // Set the desired height
                    child: Image.asset('assets/images/leg_up.png'),
                  ),
                  Column(
                    children: [
                      Transform.translate(
                        offset: const Offset(0, -150),
                        // Move the text and image up by 20 pixels
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
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(
                                    value: _controller.value,
                                    backgroundColor: AppColor.greenDarkColor,
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
                            backgroundColor: AppColor.greenDarkColor,
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
                    backgroundColor:
                        AppColor.greenDarkColor, // Dark green color
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
