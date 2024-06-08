import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/controllers/device_controller.dart';



class UnityScreen extends StatefulWidget {
  const UnityScreen({Key? key, required this.i}) : super(key: key);
  final int i;

  @override
  State<UnityScreen> createState() => UnityScreenState();
}

class UnityScreenState extends State<UnityScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();
  static UnityWidgetController? unityWidgetController;
  static sendMessage(message)
  {
    unityWidgetController?.postMessage("SceneController", "SetCurrentAngle", message);
  }
  static loadFishGame(message)
  {
    unityWidgetController?.postMessage("SceneController", "FishingGame", message);
  }
  static loadBallGame(message)
  {
    unityWidgetController?.postMessage("SceneController", "BallGame", message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        bottom: false,
        child: WillPopScope(
          onWillPop: () async {
            // Pop the category page if Android back button is pressed.
            return true;
          },
          child: Container(
            color: Colors.white,
            child: UnityWidget(
              // uiLevel: 0,

              onUnityCreated: onUnityCreated,
              onUnityUnloaded: stopStream,
              onUnityMessage: (message) {
                // if(message.toString() == "start"){
                  print(message.toString());

                // }
              },
              fullscreen: true,



            ),
          ),
        ),
      ),
    );
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    unityWidgetController = controller;
    print("Unity Created ${widget.i}");
    switch(widget.i){
      case 0:
        UnityScreenState.loadBallGame("");
        break;
      case 1:
        UnityScreenState.loadFishGame("");
        startReading();
        break;
    }
  }


  void startReading() {
    DeviceController deviceController = Provider.of<DeviceController>(context, listen: false);
    deviceController.startStream();

  }
  void stopStream() {
    DeviceController deviceController = Provider.of<DeviceController>(context, listen: false);
    // deviceController.;

  }





}