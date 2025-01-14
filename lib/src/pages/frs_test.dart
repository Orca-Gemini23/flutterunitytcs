import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/bt_constants.dart';
import 'package:walk/src/controllers/device_controller.dart';

class FrsTest extends StatelessWidget {
  const FrsTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
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
        // appBar: AppBar(),
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
                  backgroundColor: AppColor.greenDarkColor, // Dark green color
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
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class StandingWithDevice extends StatelessWidget {
  const StandingWithDevice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(),
        body: Center(
      child: FractionallySizedBox(
        widthFactor: 0.8, // Set th
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
                  backgroundColor: AppColor.greenDarkColor, // Dark green color
                  foregroundColor: Colors.white, // White text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // Slight curve
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RightLegUp()),
                  );
                },
                child: const Text(
                  "Next",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class RightLegUp extends StatefulWidget {
  const RightLegUp({super.key});

  @override
  _RightLegUpState createState() => _RightLegUpState();
}

class _RightLegUpState extends State<RightLegUp> {
  late StreamSubscription<List<int>> stream;
  double angle = 0.0;

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
            print(angle);
          });
          print(angle);
        } else {}
      },
    );
  }

  @override
  void dispose() {
    stream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.9, // Set the width to 80% of the total width
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
                        offset: const Offset(
                            0, -150), // Move the text and image up by 20 pixels
                        child: Column(
                          children: [
                            const Text(
                              'Right',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              width:
                                  100, // Set the desired width for the indicator
                              height:
                                  100, // Set the desired height for the indicator
                              child: Image.asset(
                                  'assets/images/right_leg_indicator.png'),
                            ),
                            const SizedBox(height: 10),
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
                  onPressed: () {
                    // stream.cancel();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LeftLegUp()),
                    );
                  },
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

class LeftLegUp extends StatefulWidget {
  const LeftLegUp({super.key});

  @override
  _LeftLegUpState createState() => _LeftLegUpState();
}

class _LeftLegUpState extends State<LeftLegUp> {
  late StreamSubscription<List<int>> stream;
  double angle = 0.0;

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
    stream = targetCharacteristic!.onValueReceived.listen(
      (value) {
        String data = String.fromCharCodes(value);

        // L : 0.35 0.05 -0.91 -1.89 1.46 -0.37
        var dataArr = data.split(" ");
        if (dataArr[0] == "L") {
          var ax = double.parse(dataArr[2]);
          var ay = double.parse(dataArr[3]);
          var az = double.parse(dataArr[4]);

          setState(() {
            angle =
                (((180 / 3.14) * atan(ax / sqrt(ay * ay + az * az)) / 90) - 1) *
                    -1;
          });
          // print("angle=");
          if (kDebugMode) {
            print(angle);
          }
        } else {}

        if (kDebugMode) {
          print(data);
        }
      },
    );
  }

  @override
  void dispose() {
    stream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.9, // Set the width to 80% of the total width
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
                        offset: const Offset(
                            0, -150), // Move the text and image up by 20 pixels
                        child: Column(
                          children: [
                            const Text(
                              'Left',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              width:
                                  100, // Set the desired width for the indicator
                              height:
                                  100, // Set the desired height for the indicator
                              child: Image.asset(
                                  'assets/images/left_leg_indicator.png'),
                            ),
                            const SizedBox(height: 10),
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
                    ],
                  ),
                ],
              ),
              const Text.rich(
                TextSpan(
                  text: 'Lift your ',
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Left leg',
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LeftLegUp()),
                    );
                  },
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
