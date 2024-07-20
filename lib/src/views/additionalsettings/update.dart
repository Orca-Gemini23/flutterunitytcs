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
                // deviceController.sendToDevice(
                //     "s", Guid("0000AE03-0000-1000-8000-00805f9b34fb"));

                // try {
                //   final result =
                //       await FirebaseFunctions.instanceFor(region: "us-central1")
                //           .httpsCallable('checkForUpdates')
                //           .call();
                //   print(result.data);
                // } on FirebaseFunctionsException catch (error) {
                //   if (kDebugMode) {
                //     print(error.code);
                //     print(error.details);
                //     print(error.message);
                //   }
                // }
                String token = "";
                // List<String> partialTokens = [];
                // String partialToken = "";

                await FirebaseAppCheck.instance.getLimitedUseToken().then(
                      (value) => {
                        token = value,
                        // print(value.length),
                        // print(value),
                      },
                    );

                print("------->$token");

                // for (int i = 0; i < token.length; i++) {
                //   partialToken += token[i];
                //   if (i % 200 == 0 && i > 0) {
                //     partialTokens.add(partialToken);
                //     partialToken = "";
                //   }
                // }

                // partialTokens.add(partialToken);
                // print(partialTokens);
                // print(partialTokens.length);

                // for (int i = 0; i < 5; i++) {
                //   deviceController.sendToDevice(partialTokens[i], guidList[i]);
                // }

                // print(partialTokens[0].length);
                // print(partialTokens[1].length);
                // print(partialTokens[2].length);
                // print(partialTokens[3].length);
                // print(partialTokens[4].length);

                print(token.substring(0, 200).length);
                print(token.substring(200, 400).length);
                print(token.substring(400, 600).length);
                print(token.substring(600, 800).length);
                print(token.substring(800).length);

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

                print("------->$token");
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
