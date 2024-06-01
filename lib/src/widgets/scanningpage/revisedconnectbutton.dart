import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/views/reviseddevicecontrol/newdevicecontrol.dart';
import 'package:walk/src/widgets/scanningpage/notfounddialog.dart';

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
        visible: !deviceController.scanStatus,
        replacement: const Text(
          "Searching for device",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColor.greenDarkColor,
            fontSize: 19,
          ),
        ),
        child: SizedBox(
          width: double.maxFinite,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.greenDarkColor,
            ),
            onPressed: () {
              onPressed(deviceController);
            },
            child: const Text(
              "Connect Device",
              style: TextStyle(
                fontSize: 19,
              ),
            ),
          ),
        ),
      );
    });
  }

  void onPressed(DeviceController deviceController) async {
    numberOfScans++;

    if (numberOfScans == 3) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => deviceNotFoundDialog(),
      );
      //  numberOfScans = 0;
    } else {
      //// Any time the connect button is pressed , checking the status of the bluetooth adapter(if its on or not), if not then turn on the bluetooth
      // deviceController.checkLocationPremission();
      await deviceController.checkBluetoothAdapterState(context);
      await deviceController.startDiscovery(
        () {
          Go.pushReplacement(
            context: context,
            pushReplacement: const DeviceControlPage(),
          );
        },
      );
    }
  }
}
