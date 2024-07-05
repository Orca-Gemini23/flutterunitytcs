import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/controllers/device_controller.dart';

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
                    onUnityMessage: (message) {
                      switch (message) {
                        case "VL":
                          vibrateLeft();
                          break;
                        case "VR":
                          vibrateRight();
                          break;
                      }
                    },
                    fullscreen: true,
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
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
  static void sendUploadRequest()
  {
    print("upload request send");
    unityWidgetController?.postMessage(
        // "SceneController", "UploadRequest", "${LocalDB.user!.phone}");
        "SceneController", "UploadRequest", "${LocalDB.user!.phone}");
  }
}
