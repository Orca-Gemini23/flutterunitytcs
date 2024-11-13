import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/bt_constants.dart';
import 'package:walk/src/controllers/device_controller.dart';

class DeviceUpdate extends StatefulWidget {
  const DeviceUpdate({super.key});

  @override
  State<DeviceUpdate> createState() => _DeviceUpdateState();
}

class _DeviceUpdateState extends State<DeviceUpdate> {
  List<Guid> guidList = [
    Guid("0000AE03-0000-1000-8000-00805f9b34fb"),
    Guid("0000AE04-0000-1000-8000-00805f9b34fb"),
    Guid("0000AE05-0000-1000-8000-00805f9b34fb"),
    Guid("0000AE06-0000-1000-8000-00805f9b34fb"),
    Guid("0000AE07-0000-1000-8000-00805f9b34fb")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DeviceController>(
        builder: (context, deviceController, widget) {
          return Center(
            child: TextButton(
              onPressed: () async {

                String token = "";


                await FirebaseAppCheck.instance.getLimitedUseToken().then(
                      (value) => {
                        token = value,
                        // print(value.length),
                        // print(value),
                      },
                    );





                await deviceController.sendToDevice(
                    token.substring(0, 195), guidList[0]);
                await deviceController.sendToDevice(
                    token.substring(195, 390), guidList[1]);
                await deviceController.sendToDevice(
                    token.substring(390, 585), guidList[2]);
                await deviceController.sendToDevice(
                    token.substring(585, 780), guidList[3]);
                await deviceController.sendToDevice(
                    token.substring(780), guidList[4]);

                await FirebaseAppCheck.instance.getLimitedUseToken().then(
                      (value) => {
                    token = value,
                    // print(value.length),
                    // print(value),
                  },
                );

                await deviceController.sendToDevice(
                    "tkn c 1 ${token.substring(0, 195)}",WRITECHARACTERISTICS);
                await deviceController.sendToDevice(
                    "tkn c 2 ${token.substring(195, 390)}", WRITECHARACTERISTICS);
                await deviceController.sendToDevice(
                    "tkn c 3 ${token.substring(390, 585)}", WRITECHARACTERISTICS);
                await deviceController.sendToDevice(
                    "tkn c 4 ${token.substring(585, 780)}",WRITECHARACTERISTICS);
                await deviceController.sendToDevice(
                    "tkn c 5 ${token.substring(780)}", WRITECHARACTERISTICS);


                // if (partialToken.isNotEmpty) {
                //   deviceController.sendToDevice(partialToken, guidList[4]);
                // }
                // await FirebaseAppCheck.instance
                //     .getLimitedUseToken()
                //     .then((value) => print("${value.length}\n$value"));
              },
              child: const Text('Check'),
            ),
          );
        },
      ),
    );
  }
}
