import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/widgets/showcasewidget.dart';

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
        child: Text(
          widget.controller.connectedDevice?.remoteId ==
                  widget.controller.getScannedDevices
                      .elementAt(widget.index)
                      .remoteId
              ? "Disconnect"
              : "Connect",
        ),
        onPressed: () async {
          if (widget.controller.connectedDevice?.remoteId ==
              widget.controller.getScannedDevices
                  .elementAt(widget.index)
                  .remoteId) {
            log("disconnecting ");
            await widget.controller.disconnectDevice(
              widget.controller.getScannedDevices.elementAt(widget.index),
            );
          } else {
            log("connecting ");
            // await widget.controller.connectToDevice(
            //   widget.controller.getScannedDevices.elementAt(widget.index),
            // );
          }
        },
      ),
    );
  }
}

////This button does the same as the above one , but this one will be included in a showcase ,the above button will not
Widget showCaseConnectButton(GlobalKey key, DeviceController controller) {
  return SizedBox(
    child: CustomShowCaseWidget(
      showCaseKey: key,
      description: "Press this button to connect to the device",
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: const BorderSide(color: Colors.black))),
        child: Text((controller.connectedDevice?.remoteId) ==
                controller.getScannedDevices.elementAt(0).remoteId
            ? "Disconnect"
            : "Connect"),
        onPressed: () async {
          if (controller.connectedDevice?.remoteId ==
              controller.getScannedDevices.elementAt(0).remoteId) {
            await controller
                .disconnectDevice(controller.getScannedDevices.elementAt(0));
          } else {
            // await controller.connectToDevice(
            //   controller.getScannedDevices.elementAt(0),
            // );
          }
        },
      ),
    ),
  );
}
