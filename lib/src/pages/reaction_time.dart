import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/bt_constants.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/pages/frs/frs_result.dart';
import 'package:walk/src/utils/firebase/firebase_db.dart';
import 'package:walk/src/utils/global_variables.dart';

class ReactionTime extends StatefulWidget {
  const ReactionTime({super.key});

  @override
  State<ReactionTime> createState() => _ReactionTimeState();
}

class _ReactionTimeState extends State<ReactionTime> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Center(
          child: FractionallySizedBox(
            widthFactor: 0.7, // Set the width to 80% of the total width
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  width: 500, // Set the desired width
                  height: 500, // Set the desired height
                  child: Image.asset('assets/images/shin_image.png'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Sit on a sturdy chair & attach the device securely to your shin.',
                  style: TextStyle(fontSize: 16),
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ReactionTimeVibration()),
                      );
                    },
                    child: const Text(
                      "Next",
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReactionTimeVibration extends StatefulWidget {
  const ReactionTimeVibration({super.key});

  @override
  State<ReactionTimeVibration> createState() => _ReactionTimeVibrationState();
}

class _ReactionTimeVibrationState extends State<ReactionTimeVibration> {
  late StreamSubscription<List<int>> stream;
  double right_magnitude = 0.0;
  double left_magnitude = 0.0;
  bool isButtonDisabled = false;

  List<int> left = [];
  List<int> right = [];

  String beepsTime = '';
  String beepcTime = '';

  @override
  void initState() {
    super.initState();
    context
        .read<DeviceController>()
        .sendToDevice("mode 9;", WRITECHARACTERISTICS);
    BluetoothCharacteristic? targetCharacteristic = context
        .read<DeviceController>()
        .characteristicMap[WRITECHARACTERISTICS];
    targetCharacteristic?.setNotifyValue(true);
    stream = targetCharacteristic!.onValueReceived.listen((value) {
      String data = String.fromCharCodes(value);
      var dataArr = data.split(" ");
      var gx = double.parse(dataArr[5]);
      var gy = double.parse(dataArr[6]);
      var gz = double.parse(dataArr[7]);
      if (dataArr[0] == "R") {
        right_magnitude = sqrt(gx * gx + gy * gy + gz * gz);
      } else if (dataArr[0] == "L") {
        left_magnitude = sqrt(gx * gx + gy * gy + gz * gz);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Center(
          child: FractionallySizedBox(
            widthFactor: 0.7, // Set the width to 80% of the total width
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 500, // Set the desired width
                  height: 500, // Set the desired height
                  child: Image.asset('assets/images/vibration_image.png'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'After pressing START, you will feel a vibration on your right or left shin.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text('Left reaction time: $beepsTime ms'),
                Text('Right reaction time: $beepcTime ms'),
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
                    onPressed: isButtonDisabled
                        ? null
                        : () async {
                            setState(() {
                              isButtonDisabled = true;
                            });
                            double initialRightMagnitude = 0;
                            double initialLeftMagnitude = 0;

                            while (left.length < 3 || right.length < 3) {
                              // Wait for a random 1 or 2 seconds
                              int randomDelay = Random().nextInt(2) + 3;
                              print("Waiting for $randomDelay seconds");
                              await Future.delayed(
                                  Duration(seconds: randomDelay));
                              DateTime startTime = DateTime.now();
                              if (left.length < 3) {
                                context.read<DeviceController>().sendToDevice(
                                    "beeps 5;", WRITECHARACTERISTICS);
                                await Future.delayed(
                                    const Duration(milliseconds: 20));
                                while (left_magnitude <=
                                    initialLeftMagnitude + 50) {
                                  await Future.delayed(
                                      const Duration(milliseconds: 10));
                                }
                                DateTime endTime = DateTime.now();
                                setState(() {
                                  beepsTime = (endTime.difference(startTime))
                                      .inMilliseconds
                                      .toString();
                                  left.add(int.parse(beepsTime));
                                });
                              } else {
                                context.read<DeviceController>().sendToDevice(
                                    "beepc 5;", WRITECHARACTERISTICS);
                                await Future.delayed(
                                    const Duration(milliseconds: 20));
                                while (right_magnitude <=
                                    initialRightMagnitude + 50) {
                                  await Future.delayed(
                                      const Duration(milliseconds: 10));
                                }
                                DateTime endTime = DateTime.now();
                                setState(() {
                                  beepcTime = (endTime.difference(startTime))
                                      .inMilliseconds
                                      .toString();
                                  right.add(int.parse(beepcTime));
                                });
                              }
                            }
                            FirebaseDB.currentDb
                                .collection("frs")
                                .doc(testId)
                                .update({"left_reaction_time": left});
                            FirebaseDB.currentDb
                                .collection("frs")
                                .doc(testId)
                                .update({"right_reaction_time": right});

                            setState(() {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FrsResult(),
                                ),
                                ModalRoute.withName('/home'),
                              );
                            });
                          },
                    child: const Text(
                      "Start",
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
