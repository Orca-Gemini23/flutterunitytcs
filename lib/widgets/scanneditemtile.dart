// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walk/constants.dart';
import 'package:walk/controllers/devicecontroller.dart';
import 'package:walk/controllers/wificontroller.dart';
import 'package:walk/views/commandpage.dart';

import 'package:walk/views/showcase/showcaseview.dart';
import 'package:walk/views/wifipage.dart';
import 'package:walk/widgets/buttons.dart';
import 'package:walk/widgets/dialog.dart';
import 'package:walk/widgets/loadingdialog.dart';

class ScannedDevicesList extends StatefulWidget {
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
      itemCount: widget.controller.getScannedDevices.length,
      itemBuilder: (context, index) {
        return index == 0
            ? showCaseItem(widget.gkey1, widget.gkey2)
            : scannedItem(index);
      },
    );
  }

  Widget showCaseItem(GlobalKey key1, GlobalKey key2) {
    return Consumer2<DeviceController, WifiController>(
      builder: (context, deviceController, wifiController, child) {
        return InkWell(
          onTap: () async {
            loadingDialog(
              context,
            );
            await deviceController.notifyRead(WRITECHARACTERISTICS, context);
            Navigator.of(context, rootNavigator: true).pop();
            deviceController.wifiProvisionStatus
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

Widget scannedItem(
  int index,
) {
  return Consumer2<DeviceController, WifiController>(
    builder: (context, controller, wifiController, child) {
      return InkWell(
        onTap: () async {
          //check if the _info is already filled if it is then directly proceed else notify
          //but if _info has to update then what but its older details is already filled ???
          loadingDialog(
            context,
          );
          await controller.notifyRead(WRITECHARACTERISTICS, context);
          Navigator.of(context, rootNavigator: true).pop();
          controller.wifiProvisionStatus
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
