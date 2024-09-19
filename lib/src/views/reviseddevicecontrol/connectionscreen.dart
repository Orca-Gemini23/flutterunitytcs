import 'dart:io';

import 'package:awesome_ripple_animation/awesome_ripple_animation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/widgets/scanningpage/bluetoothconnectionicon.dart';
import 'package:walk/src/widgets/scanningpage/revisedconnectbutton.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  @override
  void initState() {
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'Connection Page')
        .then(
          (value) => debugPrint("Analytics stated"),
        );
    super.initState();
  }

  Future<bool> _onWillPop() async {
    String message = "Are you sure you want to go back?"; // Default message
    final deviceController =
        Provider.of<DeviceController>(context, listen: false);

    if (deviceController.scanStatus == true) {
      message = "Are you sure you want to stop the scanning?";
    }
    if(deviceController.isConnecting == true){
      message = "Are you sure you want to stop the Connecting?";
    }

    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Device Control', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No', style: TextStyle(color: AppColor.greenDarkColor),),
          ),
          TextButton(
            onPressed: () async {
              if (deviceController.scanStatus == true || deviceController.isConnecting == true) {
                await FlutterBluePlus.stopScan();
                deviceController.isScanning = false;
                deviceController.isConnecting = false;
                deviceController.notifyListeners();
              }
              Navigator.of(context).pop(true);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    ) ??
    false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          // systemOverlayStyle: SystemUiOverlayStyle.dark,
          // automaticallyImplyLeading: !Provider.of<DeviceController>(context,
          //         listen: true)
          //     .isScanning, ////Remove the default back button when scan is running
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: AppColor.blackColor,
          ),
          title: const Text(
            "Device Control",
            style: TextStyle(
              color: AppColor.blackColor,
              fontSize: 16,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            bottom: 15,
          ),
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Consumer<DeviceController>(
                  builder: (context, deviceController, widget) {
                if (Platform.isAndroid) {
                  deviceController.checkLocationPremission();
                }
                return Positioned(
                  top: 250,
                  left: 0,
                  right: 0,
                  child: deviceController.scanStatus
                      ? RippleAnimation(
                          ripplesCount: 2,
                          repeat: true,
                          delay: const Duration(seconds: 2),
                          color: AppColor.greyLight,
                          size: const Size.fromRadius(40),
                          minRadius: 180,
                          child: deviceController.connectedDevice == null
                              ? bluetoothIcon()
                              : bluetoothConnectedIcon(),
                        )
                      : bluetoothIcon(),
                );
              }),
              Positioned(
                top: MediaQuery.of(context).size.height - 320,
                left: 0,
                right: 0,
                child: Consumer<DeviceController>(
                  builder: (context, deviceController, widget) {
                    if (deviceController.scanStatus) {
                      return const SizedBox.shrink();
                    } else {
                      return Visibility(
                        visible: deviceController.isBluetoothOn,
                        child: const Text(
                          "Turn on your Bluetooth \n connection and make sure your \n device is nearby",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.blackColor,
                            fontSize: 19,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              Consumer<DeviceController>(
                //Connect Device Button
                builder: (context, deviceController, widget) {
                  return Positioned(
                    top: MediaQuery.of(context).size.height - 150,
                    left: 0,
                    right: 0,
                    child: const RevisedConnectButton(),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
