// ignore_for_file: use_build_context_synchronously, unused_import

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/controllers/wifi_controller.dart';
import 'package:walk/src/views/device/command_page.dart';

import 'package:walk/src/views/showcase/showcaseview.dart';
import 'package:walk/src/views/device/wifi_page.dart';
import 'package:walk/src/widgets/buttons.dart';
import 'package:walk/src/widgets/showcasewidget.dart';
import 'package:walk/src/widgets/unboxingsetup.dart';

// ignore: must_be_immutable
class ScannedDevicesList extends StatefulWidget {
  ///Represents the devices that have been scanned6
  ScannedDevicesList({
    super.key,
    required this.controller,
    required this.isShowCaseDone,
    required this.isUnboxingDone,
  });
  final DeviceController controller;
  bool isShowCaseDone;
  bool isUnboxingDone;

  @override
  State<ScannedDevicesList> createState() => _ScannedDevicesListState();
}

class _ScannedDevicesListState extends State<ScannedDevicesList>
    with WidgetsBindingObserver {
  final GlobalKey deviceTileKey = GlobalKey();
  final GlobalKey connectButtonKey = GlobalKey();
  String temp = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.isUnboxingDone == false) {
        temp = await showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: UnboxingSetupDialog(),
              );
            });
      }

      if (widget.isShowCaseDone == false && temp == "done") {
        ShowCaseWidget.of(context)
            .startShowCase([deviceTileKey, connectButtonKey]);
      } else {
        null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.controller.getScannedDevices.length,
      itemBuilder: (context, index) {
        return index == 0
            ? showCaseItem(deviceTileKey, connectButtonKey)
            : scannedItem(index);
      },
    );
  }

//serviceUuids: [0000acf0-0000-1000-8000-00805f9b34fb]}
//uuid: 0000abf1-0000-1000-8000-00805f9b34f
  ///This widget is only used for showcase. And it is going to be the first tile to appear on the scanned devices page.
  Widget showCaseItem(GlobalKey firstTilekey, GlobalKey connectButtonKey) {
    return CustomShowCaseWidget(
      showCaseKey: firstTilekey,
      description: "This is the device we found near you.",
      child: Consumer2<DeviceController, WifiController>(
        builder: (context, deviceController, wifiController, child) {
          return InkWell(
            onTap: () async {
              if (deviceController.connectedDevice == null) {
                Fluttertoast.showToast(
                    msg: "Please connect to the device first.");
              } else {
                var wifiStatus =
                    await deviceController.getWifiProvisionedStatus();
                log(deviceController.wifiProvisionStatus.toString());

                Future.delayed(
                  const Duration(milliseconds: 400),
                  () async {
                    try {
                      await deviceController.getBatteryPercentageValues();
                      await deviceController.getFrequencyValues();
                      await deviceController.getMagnitudeValues();
                      await deviceController.getBatteryRemaining();
                      await deviceController.getWifiProvisionedStatus();
                    } catch (e) {
                      log(e.toString());
                      Fluttertoast.showToast(msg: e.toString());
                    }
                  },
                );

                switch (wifiStatus) {
                  case 0:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WifiPage(),
                      ),
                    );
                    break;
                  case 1:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CommandPage(),
                      ),
                    );
                    break;
                  case 2:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CommandPage(),
                      ),
                    );
                    break;
                  default:
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                  color: const Color(0XFF184D47),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: deviceController.connectedDevice ==
                          (deviceController.getScannedDevices.elementAt(0))
                      ? [
                          const BoxShadow(
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
                      Expanded(
                        child: Text(
                          deviceController.getScannedDevices.elementAt(0).name,
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 20,
                              color: Colors.white,
                              letterSpacing: 3,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      showCaseConnectButton(connectButtonKey, deviceController)
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
          );
        },
      ),
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
          if (controller.connectedDevice == null) {
            Fluttertoast.showToast(msg: "Please connect to the device first.");
          }
          {
            var wifiStatus = await controller.getWifiProvisionedStatus();

            Future.delayed(
              const Duration(milliseconds: 400),
              () async {
                try {
                  await controller.getBatteryPercentageValues();
                  await controller.getFrequencyValues();
                  await controller.getMagnitudeValues();
                  await controller.getBatteryRemaining();
                  await controller.getWifiProvisionedStatus();
                } catch (e) {
                  Fluttertoast.showToast(msg: e.toString());
                }
              },
            );
            switch (wifiStatus) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WifiPage(),
                  ),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CommandPage(),
                  ),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CommandPage(),
                  ),
                );
                break;
              default:
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
              color: const Color(0XFF184D47),
              borderRadius: BorderRadius.circular(10),
              boxShadow: controller.connectedDevice ==
                      (controller.getScannedDevices.elementAt(index))
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
                  Expanded(
                    child: Text(
                      controller.getScannedDevices.elementAt(index).name,
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 20,
                          color: Colors.white,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
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
