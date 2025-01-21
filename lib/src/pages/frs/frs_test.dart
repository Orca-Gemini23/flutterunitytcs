import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/pages/right_leg_up.dart';
import 'package:walk/src/utils/firebase/firebase_db.dart';
import 'package:walk/src/utils/global_variables.dart';

import '../../constants/bt_constants.dart';
import '../../controllers/device_controller.dart';

class FrsTest extends StatelessWidget {
  const FrsTest({super.key});

  @override
  StatelessElement createElement() {
    testId = DateTime.now().toIso8601String();

    FirebaseDB.currentDb
        .collection("frs")
        .doc(testId)
        .set({"user_id": FirebaseAuth.instance.currentUser?.uid});
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          //add a button to top right to exit the test
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
            widthFactor: 0.8, // Set the width to 80% of the total width
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Hi!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Image.asset('assets/images/doctor.png'),
                const SizedBox(height: 20),
                const Text(
                  'We will be guiding you through a couple of simple test to calculate your fall risk score',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Please follow the instructions carefully to ensure accurate results',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    onPressed: () {
                      context
                          .read<DeviceController>()
                          .sendToDevice("mode 9;", WRITECHARACTERISTICS);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EnsureDevice()),
                      );
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

class EnsureDevice extends StatelessWidget {
  const EnsureDevice({super.key});

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
            widthFactor: 0.8, // Set th
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 343 / 2, // Set the desired width
                  height: 737 / 2, // Set the desired height
                  child: Image.asset('assets/images/seated_wearing.png'),
                ),
                const Text(
                  'Securely attach the device to your thigh. Make sure it’s snug but comfortable.',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StandingWithDevice()),
                      );
                    },
                    child: const Text(
                      "Next",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class StandingWithDevice extends StatefulWidget {
  const StandingWithDevice({super.key});

  @override
  _StandingWithDeviceState createState() => _StandingWithDeviceState();
}

class _StandingWithDeviceState extends State<StandingWithDevice> {
  late StreamSubscription<List<int>> stream;
  bool isButtonEnabled = false;
  double rightAngle = 0.0;
  double leftAngle = 0.0;

  @override
  void initState() {
    super.initState();
    BluetoothCharacteristic? targetCharacteristic = context
        .read<DeviceController>()
        .characteristicMap[WRITECHARACTERISTICS];
    if (targetCharacteristic != null) {
      targetCharacteristic.setNotifyValue(true);
      stream = targetCharacteristic.onValueReceived.listen(
        (value) {
          String data = String.fromCharCodes(value);
          var dataArr = data.split(" ");
          var ax = double.parse(dataArr[2]);
          var ay = double.parse(dataArr[3]);
          var az = double.parse(dataArr[4]);
          if (dataArr[0] == "R") {
            setState(() {
              rightAngle =
                  1 - (atan(ax / sqrt(ay * ay + az * az)) * (180 / pi) / -90);
            });
          } else {
            setState(() {
              leftAngle =
                  (((180 / 3.14) * atan(ax / sqrt(ay * ay + az * az)) / 90) -
                          1) *
                      -1;
            });
          }

          setState(() {
            leftAngle = double.parse(dataArr[3]);
            if (rightAngle > 0.75 && leftAngle > 0.75) {
              isButtonEnabled = true;
            }
          });
        },
      );
    }
  }

  @override
  void dispose() {
    stream.cancel();
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
            widthFactor: 0.8, // Set the width to 80% of the total width
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 385 / 2, // Set the desired width
                  height: 835 / 2, // Set the desired height
                  child: Image.asset('assets/images/standing_with_device.png'),
                ),
                const Text(
                  'Stand straight with feet shoulder-width apart.',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RightLegUp()),
                            );
                          }
                        : null,
                    child: const Text(
                      "Next",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
