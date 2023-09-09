import 'package:flutter/material.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/views/reviseddevicecontrol/newdevicecontrol.dart';
import 'package:walk/src/widgets/scanningpage/notfounddialog.dart';

int numberOfScans = 0;
Widget revisedConnectButton(
  DeviceController deviceController,
  BuildContext context,
) {
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
        onPressed: () async {
          numberOfScans++;

          print(numberOfScans);
          if (numberOfScans == 3) {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => deviceNotFoundDialog(),
            );
            //  numberOfScans = 0;
          } else {
            await deviceController.startDiscovery(() {
              Go.pushReplacement(
                context: context,
                pushReplacement: const DeviceControlPage(),
              );
            });
          }
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
}
