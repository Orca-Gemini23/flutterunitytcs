import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:walk/src/controllers/devicecontroller.dart';

import 'package:walk/src/views/showcase/showcaseview.dart';

///Button to connect to a device , usually this button is used inside the scanned item tile or showcase scanned item tile
class ConnectButton extends StatefulWidget {
  const ConnectButton({
    super.key,
    required this.controller,
    required this.index,
  });
  final DeviceController controller;

  final int index;

  @override
  State<ConnectButton> createState() => _ConnectButtonState();
}

class _ConnectButtonState extends State<ConnectButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: const BorderSide(color: Colors.black))),
        child: Text(widget.controller.getConnectedDevices.any((element) =>
                element.id ==
                widget.controller.getScannedDevices.elementAt(widget.index).id)
            ? "Disconnect"
            : "Connect"),
        onPressed: () async {
          if (widget.controller.getConnectedDevices.any((element) =>
              element.id ==
              widget.controller.getScannedDevices.elementAt(widget.index).id)) {
            log("disconnecting ");
            await widget.controller.disconnectDevice(
                widget.controller.getScannedDevices.elementAt(widget.index));
          } else {
            log("connecting ");
            await widget.controller.connectToDevice(
                widget.controller.getScannedDevices.elementAt(widget.index));
          }
        },
      ),
    );
  }
}

///This button does the same as the above one , but this one will be included in a showcase ,the above button will not
Widget showCaseConnectButton(GlobalKey key, DeviceController controller) {
  return SizedBox(
    child: ShowCaseView(
      globalKey: key,
      title: "Connect Button",
      description: "Press this button to connect to the device",
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: const BorderSide(color: Colors.black))),
        child: Text(controller.getConnectedDevices.any((element) =>
                element.id == controller.getScannedDevices.elementAt(0).id)
            ? "Disconnect"
            : "Connect"),
        onPressed: () async {
          if (controller.getConnectedDevices.any((element) =>
              element.id == controller.getScannedDevices.elementAt(0).id)) {
            log("disconnecting ");
            await controller
                .disconnectDevice(controller.getScannedDevices.elementAt(0));
          } else {
            log("connecting ");
            await controller
                .connectToDevice(controller.getScannedDevices.elementAt(0));
          }
        },
      ),
    ),
  );
}
