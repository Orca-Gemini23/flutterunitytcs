import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/utils/firebasehelper/firebasedb.dart';
import 'package:walk/src/utils/global_variables.dart';

class RevisedConnectButton extends StatefulWidget {
  const RevisedConnectButton({super.key});

  @override
  State<RevisedConnectButton> createState() => _RevisedConnectButtonState();
}

class _RevisedConnectButtonState extends State<RevisedConnectButton> {
  int numberOfScans = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceController>(
        builder: (context, deviceController, child) {
      return Visibility(
        visible: !deviceController.scanStatus && !deviceController.isConnecting,
        replacement: Text(
          deviceController.isConnecting
              ? "Connecting to device"
              : "Searching for device",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColor.greenDarkColor,
            fontSize: 19,
          ),
        ),
        child: SizedBox(
          width: double.maxFinite,
          height: DeviceSize.isTablet ? 75 : 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.greenDarkColor,
            ),
            onPressed: () {
              onPressed(deviceController);
            },
            child: Text(
              "Connect to my walk device",
              style: TextStyle(
                  fontSize: DeviceSize.isTablet ? 38 : 19, color: Colors.white),
            ),
          ),
        ),
      );
    });
  }

  void onPressed(DeviceController deviceController) async {
    Analytics.addClicks("ConnectButton", DateTime.now());

    //// Any time the connect button is pressed , checking the status of the bluetooth adapter(if its on or not), if not then turn on the bluetooth
    // deviceController.checkLocationPremission();
    await deviceController.checkBluetoothAdapterState(context);
    await deviceController.startDiscovery(() {
      Navigator.pushReplacementNamed(context, '/devicecontrol');
    }, context);
  }
}
