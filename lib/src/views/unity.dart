import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/controllers/device_controller.dart';



class UnityScreen extends StatefulWidget {
  const UnityScreen({Key? key}) : super(key: key);

  @override
  State<UnityScreen> createState() => _UnityDemoScreenState();
}

class _UnityDemoScreenState extends State<UnityScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();
  UnityWidgetController? _unityWidgetController;

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
            color: Colors.yellow,
            child: UnityWidget(
              onUnityCreated: onUnityCreated,
              onUnityMessage: (message) {
                // if(message.toString() == "start"){
                  print(message.toString());
                  startBall();
                // }
              },

              onUnitySceneLoaded: onUnitySceneLoaded,

            ),
          ),
        ),
      ),
    );
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    print("unityCreated");
    _unityWidgetController = controller;
    _unityWidgetController?.postMessage(
      'Square',
      'FlutterToUnityMessage',
      "test message from flutter"
    );
    // startBall();
  }
  void onUnitySceneLoaded(SceneLoaded? sceneInfo) {
    print('Received scene loaded from unity: ${sceneInfo?.name}');
    print('Received scene loaded from unity buildIndex: ${sceneInfo?.buildIndex}');
  }
  void flutterToUnityMessage( value) {
    print("FlutterToUnityMessage");
    if (_unityWidgetController != null) {
      _unityWidgetController!.postMessage(
        'Square',
        'FlutterToUnityMessage',
        value,
      );
    }
  }

  void startBall() {
    // print("startBall");
    
    Consumer<DeviceController>(
      builder: (context, deviceController, child) {

        return Container();
      },
    );
  }
}