import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/utils/firebasehelper.dart/firebasedb.dart';
import 'package:walk/src/views/user/revisedaccountpage.dart';

import '../constants/bt_constants.dart';
import '../db/local_db.dart';

class UnityScreen extends StatefulWidget {
  const UnityScreen({Key? key, required this.i}) : super(key: key);
  final int i;

  @override
  State<UnityScreen> createState() => UnityScreenState();
}

class UnityScreenState extends State<UnityScreen> {
  @override
  void initState() {
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'Game Page ${widget.i} ')
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

  static loadTestScene() {
    unityWidgetController?.postMessage("SceneController", "TestScene", "");
  }

  double _sliderValue = 0.0;
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
        child: WillPopScope(
            onWillPop: () async {
              sendUploadRequest();
              await FirebaseDB.uploadUserScore(
                score: finalScore,
                playedOn: DateTime.now(),
                secondsPlayedFor: secondPlayed,
              );
              // if (result) {
              //   Fluttertoast.showToast(msg: "Data uploaded");
              //   Navigator.of(context, rootNavigator: true).pop();
              // } else {
              //   Navigator.of(context, rootNavigator: true).pop();
              // }
              // Pop the category page if Android back button is pressed.
              return true;
            },
            child: Stack(
                // color: Colors.white,
                children: <Widget>[
                  UnityWidget(
                    // uiLevel: 0,
                    onUnityCreated: onUnityCreated,
                    onUnityUnloaded: stopStream,
                    onUnityMessage: (message) async {
                      if (message.toString().contains("xc")) {
                        var score = message.toString().split("c");
                        log(score[1]);
                        setState(() {
                          finalScore = int.parse(score[1]);
                          secondPlayed = int.parse(
                              double.parse(score[2]).toStringAsFixed(0));
                        });
                      }
                      else if(message.toString().contains("ball"))
                        {
                          await FirebaseDB.uploadBallData(ballData: message.toString().replaceAll("ball", ""));
                        }
                      else if(message.toString().contains("swing"))
                        {
                          await FirebaseDB.uploadSwingData(swingData: message.toString().replaceAll("swing", ""));
                        }
                      else if(message.toString().contains("fish"))
                        {
                          await FirebaseDB.uploadFishData(fishData: message.toString().replaceAll("fish", ""));
                        }
                      else{
                      switch (message) {
                        case "VL":
                          vibrateLeft();
                          break;
                        case "VR":
                          vibrateRight();
                          break;

                      }}
                    },
                    fullscreen: true,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () async {
                      sendUploadRequest();
                      await FirebaseDB.uploadUserScore(
                        score: finalScore,
                        playedOn: DateTime.now(),
                        secondsPlayedFor: secondPlayed,
                      );
                      // if (result) {
                      //   Fluttertoast.showToast(msg: "Data uploaded");
                      //   Navigator.of(context, rootNavigator: true).pop();
                      // } else {
                      //   Navigator.of(context, rootNavigator: true).pop();
                      // }
                      Navigator.pop(context);
                    },
                  )

                  // Slider(
                  //   onChanged: (value) {
                  //     setState(() {
                  //       _sliderValue = value;
                  //     });
                  //   },
                  //   value: _sliderValue,
                  //   min: 0,
                  //   max: 20,
                  // ),
                ])),
      ),
    );
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    unityWidgetController = controller;
    print("Unity Created ${widget.i}");
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
        UnityScreenState.loadTestScene();
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
        "SceneController", "AccelerometerValue", legData);
  }

  static void sendUploadRequest() {
    print("upload request send");
    var baseUrl = (country == "England")
        ? "https://wcdq86190h.execute-api.eu-west-2.amazonaws.com/DevS/flutter-app-s3-eu-west-2-london/"
        : "https://f02966xlb7.execute-api.ap-south-1.amazonaws.com/flutterdata/flutter-app-s3-ap-south-1-mumbai/";

    unityWidgetController?.postMessage(
        // "SceneController", "UploadRequest", "${LocalDB.user!.phone}");
        "SceneController",
        "UploadRequest",
        (("$baseUrl${LocalDB.user!.phone}").replaceAll(" ", ""))
            .replaceAll("+", ""));
  }
}
