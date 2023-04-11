// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:walk/src/controllers/devicecontroller.dart';
import 'package:walk/src/controllers/wificontroller.dart';
import 'package:walk/src/views/device/commandpage.dart';

import 'package:walk/src/views/showcase/showcaseview.dart';
import 'package:walk/src/views/device/wifipage.dart';
import 'package:walk/src/widgets/buttons.dart';

class ScannedDevicesList extends StatefulWidget {
  ///Represents the devices that have been scanned
  const ScannedDevicesList(
      {super.key,
      required this.controller,
      required this.gkey1,
      required this.gkey2});
  final DeviceController controller;
  final GlobalKey gkey1;
  final GlobalKey gkey2;

  @override
  State<ScannedDevicesList> createState() => _ScannedDevicesListState();
}

class _ScannedDevicesListState extends State<ScannedDevicesList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //Stream it
      itemCount: widget.controller.getScannedDevices.length,
      itemBuilder: (context, index) {
        return index == 0
            ? showCaseItem(widget.gkey1, widget.gkey2)
            : scannedItem(index);
      },
    );
  }

//serviceUuids: [0000acf0-0000-1000-8000-00805f9b34fb]}
//uuid: 0000abf1-0000-1000-8000-00805f9b34f
  ///This widget is only used for showcase. And it is going to be the first tile to appear on the scanned devices page.
  Widget showCaseItem(GlobalKey key1, GlobalKey key2) {
    return Consumer2<DeviceController, WifiController>(
      builder: (context, deviceController, wifiController, child) {
        return InkWell(
          onTap: () async {
            var wifiStatus = await deviceController.getProvisionedStatus();
            log(deviceController.wifiProvisionStatus.toString());

            Future.delayed(const Duration(milliseconds: 400), () async {
              await deviceController.getBatteryVoltageValues();
            });

            wifiStatus
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const CommandPage();
                      },
                    ),
                  )
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const WifiPage();
                      },
                    ),
                  );
          },
          child: ShowCaseView(
            globalKey: key1,
            title: "Device Details",
            description: "These are the device details",
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                  color: const Color(0XFF184D47),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: deviceController.getConnectedDevices.contains(
                    deviceController.getScannedDevices.elementAt(0),
                  )
                      ? const [
                          BoxShadow(
                              color: Colors.greenAccent,
                              blurRadius: 3,
                              spreadRadius: 5)
                        ]
                      : null),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        deviceController.getScannedDevices.elementAt(0).name,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 20,
                            color: Colors.white,
                            letterSpacing: 3,
                            fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      showCaseConnectButton(key2, deviceController)
                    ],
                  ),
                  Text(
                    deviceController.getScannedDevices
                        .elementAt(0)
                        .id
                        .toString(),
                    style: const TextStyle(
                      color: Colors.white38,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

///This is a normal scanned item tile which will not be highlighted in the showcase . It has the same functionality as the above one but this one will not be included a showcase
Widget scannedItem(
  int index,
) {
  return Consumer2<DeviceController, WifiController>(
    builder: (context, controller, wifiController, child) {
      return InkWell(
        onTap: () async {
          var wifiStatus = await controller.getProvisionedStatus();

          Future.delayed(const Duration(milliseconds: 400), () async {
            await controller.getBatteryVoltageValues();
          });
          wifiStatus
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const CommandPage();
                    },
                  ),
                )
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const WifiPage();
                    },
                  ),
                );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
              color: const Color(0XFF184D47),
              borderRadius: BorderRadius.circular(10),
              boxShadow: controller.getConnectedDevices.contains(
                controller.getScannedDevices.elementAt(index),
              )
                  ? const [
                      BoxShadow(
                          color: Colors.greenAccent,
                          blurRadius: 3,
                          spreadRadius: 5)
                    ]
                  : null),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    controller.getScannedDevices.elementAt(index).name,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 20,
                        color: Colors.white,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  ConnectButton(
                    controller: controller,
                    index: index,
                  )
                ],
              ),
              Text(
                controller.getScannedDevices.elementAt(index).id.toString(),
                style: const TextStyle(
                  color: Colors.white38,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
