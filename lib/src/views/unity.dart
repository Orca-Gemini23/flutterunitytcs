import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/utils/firebasehelper.dart/firebasedb.dart';
import '../constants/bt_constants.dart';

class UnityScreen extends StatefulWidget {
  const UnityScreen({super.key, required this.i});
  final int i;

  @override
  State<UnityScreen> createState() => UnityScreenState();
}

class UnityScreenState extends State<UnityScreen> {
  static bool back = false;
  @override
  void initState() {
    FirebaseAnalytics.instance
        .logScreenView(screenName: 'Game Page ${widget.i}')
        .then(
          (value) => debugPrint("Analytics stated"),
        );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  static UnityWidgetController? unityWidgetController;

  static sendAngle(message) {
    unityWidgetController?.postMessage(
        "SceneController", "SetCurrentAngle", message);
  }

  static loadFishGame() {
    unityWidgetController?.postMessage("SceneController", "FishingGame", "");
  }

  static loadBallGame() {
    unityWidgetController?.postMessage("SceneController", "BallGame", "");
  }

  static loadTaxiGame() {
    unityWidgetController?.postMessage("SceneController", "TaxiGame", "");
  }

  int finalScore = 0;
  int secondPlayed = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //
      //   backgroundColor: Colors.transparent,
      //   // title: const Text('First Route'),
      // ),
      key: _scaffoldKey,
      body: SafeArea(
        bottom: false,
        child: PopScope(
            onPopInvokedWithResult: (bool didPop, Object? result) async {
              sendUploadRequest();
              FirebaseDB.uploadUserScore(
                score: finalScore,
                playedOn: DateTime.now(),
                secondsPlayedFor: secondPlayed,
              );
            },
            child: Stack(
                // color: Colors.white,
                children: <Widget>[
                  UnityWidget(
                    // uiLevel: 0,
                    onUnityCreated: onUnityCreated,
                    onUnityUnloaded: stopStream,
                    onUnityMessage: (message) async {
                      var msg = message.toString();
                      if (msg.toString().contains("xc")) {
                        var score = msg.toString().split("c");
                        log(score[1]);
                        setState(() {
                          finalScore = int.parse(score[1]);
                          secondPlayed = int.parse(
                              double.parse(score[2]).toStringAsFixed(0));
                        });
                      } else if (msg.toString() == "Exit") {
                        // sendUploadRequest();
                        FirebaseDB.uploadUserScore(
                          score: finalScore,
                          playedOn: DateTime.now(),
                          secondsPlayedFor: secondPlayed,
                        );
                        Navigator.pop(context);
                      } else {
                        switch (msg) {
                          case "VL":
                            vibrateLeft();
                            break;
                          case "VR":
                            vibrateRight();
                            break;
                        }
                      }
                    },
                    fullscreen: true,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () async {
                      sendUploadRequest();
                      FirebaseDB.uploadUserScore(
                        score: finalScore,
                        playedOn: DateTime.now(),
                        secondsPlayedFor: secondPlayed,
                      );

                      Navigator.pop(context);
                    },
                  )
                ])),
      ),
    );
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    unityWidgetController = controller;
    switch (widget.i) {
      case 0:
        UnityScreenState.loadBallGame();
        startReading();

        break;
      case 1:
        UnityScreenState.loadFishGame();
        startReading();
        break;
      case 2:
        UnityScreenState.loadSwingGame();
        startReading();
        break;
      case 3:
        UnityScreenState.loadTaxiGame();
        startReading();
        break;
    }
  }

  void startReading() {
    DeviceController deviceController =
        Provider.of<DeviceController>(context, listen: false);
    deviceController.startStream();
  }

  void stopStream() {
    // DeviceController deviceController = Provider.of<DeviceController>(context, listen: false);
  }

  Future<void> vibrateLeft() async {
    // print("Vibrating Left")

    DeviceController deviceController =
        Provider.of<DeviceController>(context, listen: false);
    await deviceController.sendToDevice(
        "beeps 5;", WRITECHARACTERISTICS); //right
  }

  Future<void> vibrateRight() async {
    DeviceController deviceController =
        Provider.of<DeviceController>(context, listen: false);
    await deviceController.sendToDevice(
        "beepc 5;", WRITECHARACTERISTICS); //right
  }

  static void loadSwingGame() {
    unityWidgetController?.postMessage("SceneController", "SwingGame", "");
  }

  static void sendAccelerometer(String legData) {
    unityWidgetController?.postMessage(
        "SceneController", "SetAccelerometerValue", legData);
  }

  static void sendUploadRequest() {
    // back=true;
  }
}
