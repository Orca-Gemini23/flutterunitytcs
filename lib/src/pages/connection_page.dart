import 'dart:io';

import 'package:awesome_ripple_animation/awesome_ripple_animation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/utils/global_variables.dart';
import 'package:walk/src/widgets/scanningpage/bluetoothconnectionicon.dart';
import 'package:walk/src/widgets/scanningpage/revisedconnectbutton.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  static const route = "/connection-screen";

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  @override
  void initState() {
    FirebaseAnalytics.instance
        .logScreenView(screenName: 'Connection Page')
        .then((value) => debugPrint("Analytics stated in Connection Page"));
    super.initState();
  }

  Future<bool> _onWillPop() async {
    bool warn = false;
    String message = "Are you sure you want to go back?"; // Default message
    final deviceController =
        Provider.of<DeviceController>(context, listen: false);

    if (deviceController.scanStatus == true) {
      warn = true;
      message = "Are you sure you want to stop the scanning?";
    }
    if (deviceController.isConnecting == true) {
      warn = true;
      message = "Are you sure you want to stop the Connecting?";
    }
    if (warn) {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              contentPadding: DeviceSize.isTablet
                  ? const EdgeInsets.fromLTRB(48, 40, 48, 48)
                  : null,
              title: Text(
                'Device Control',
                style: TextStyle(
                    fontSize: DeviceSize.isTablet ? 32 : 16,
                    fontWeight: FontWeight.bold),
              ),
              content: Text(
                message,
                style: TextStyle(fontSize: DeviceSize.isTablet ? 24 : null),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'No',
                    style: TextStyle(
                        fontSize: DeviceSize.isTablet ? 24 : null,
                        color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (deviceController.scanStatus == true ||
                        deviceController.isConnecting == true) {
                      await FlutterBluePlus.stopScan();
                      deviceController.isScanning = false;
                      deviceController.isConnecting = false;
                    }
                    if (context.mounted) Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(
                        fontSize: DeviceSize.isTablet ? 24 : null,
                        color: AppColor.greenDarkColor),
                  ),
                ),
              ],
            ),
          ) ??
          false;
    } else {
      return true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final navigator = Navigator.of(context);
        bool value = await _onWillPop();
        if (value) {
          navigator.pop(result);
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          // automaticallyImplyLeading: !Provider.of<DeviceController>(context,
          //         listen: true)
          //     .isScanning, ////Remove the default back button when scan is running
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: AppColor.blackColor,
            size: DeviceSize.isTablet ? 36 : 24,
          ),
          // leading: IconButton(
          //   icon: const Icon(
          //     Icons.arrow_back_ios,
          //   ),
          //   onPressed: (() {
          //     Navigator.pop(context);
          //   }),
          // ),
          title: Text(
            "Device Control",
            style: TextStyle(
              color: AppColor.blackColor,
              fontSize: DeviceSize.isTablet ? 32 : 16,
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
                  top: DeviceSize.isTablet ? 300 : 250,
                  left: 0,
                  right: 0,
                  child: (deviceController.scanStatus ||
                          deviceController.isConnecting)
                      ? RippleAnimation(
                          ripplesCount: 2,
                          repeat: true,
                          color: AppColor.greyLight,
                          size: DeviceSize.isTablet
                              ? const Size.fromRadius(80)
                              : const Size.fromRadius(40),
                          minRadius: DeviceSize.isTablet ? 270 : 180,
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
