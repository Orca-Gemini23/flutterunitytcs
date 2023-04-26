import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/controllers/wifi_controller.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/views/device/command_page.dart';
import 'package:walk/src/constants/bt_constants.dart';

class WifiPage extends StatefulWidget {
  const WifiPage({super.key});

  @override
  State<WifiPage> createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage> {
  ///This page is used to obtain user's wifi ID and Password then connect to the wifi and send these wifi id and password to the device , wifi provisioning.
  // final TextEditingController ssidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.wifiPageTitle),
        backgroundColor: AppColor.appBarColor,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        height: double.infinity,
        width: double.infinity,
        child: Consumer2<WifiController, DeviceController>(
            builder: (context, wifiController, deviceController, child) {
          if (wifiController.wifiScanPermission) {
            return RefreshIndicator(
              onRefresh: () async {
                await wifiController.wifiScanner();
              },
              child: SingleChildScrollView(
                child: wifiController.wifiScanLoader
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: List.generate(
                          wifiController.scannedResult.length,
                          (index) {
                            var accessPoint =
                                wifiController.scannedResult[index];
                            return ListTile(
                              title: Text(
                                accessPoint.ssid,
                                style: const TextStyle(),
                              ),
                              trailing: wifiSignal(accessPoint.level),
                              onTap: () async {
                                bool success = await wifiController
                                    .wifiCredDialog(accessPoint.ssid, context);
                                if (success) {
                                  deviceController.sendToDevice(
                                      "${accessPoint.ssid}/${wifiController.passwdController.text}",
                                      WRITECHARACTERISTICS);
                                  Go.pushReplacement(
                                    context: context,
                                    pushReplacement: const CommandPage(),
                                  );
                                } else {
                                  debugPrint('Error!!!!: $success');
                                }
                              },
                            );
                          },
                        ),

                        // TextField(
                        //   controller: ssidController,
                        //   decoration: const InputDecoration(
                        //     labelText: AppString.wifiId,
                        //     labelStyle: TextStyle(
                        //         color: AppColor.greenColor,
                        //         fontSize: 18,
                        //         fontWeight: FontWeight.w600),
                        //     enabledBorder: OutlineInputBorder(
                        //       borderSide: BorderSide(color: AppColor.greenColor),
                        //     ),
                        //     focusedBorder: OutlineInputBorder(
                        //       borderSide: BorderSide(color: AppColor.greenColor),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        // const Divider(),
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        // TextField(
                        //   controller: passwdController,
                        //   decoration: const InputDecoration(
                        //     labelText: AppString.wifiPassword,
                        //     labelStyle: TextStyle(
                        //         color: AppColor.greenColor,
                        //         fontSize: 18,
                        //         fontWeight: FontWeight.w600),
                        //     enabledBorder: OutlineInputBorder(
                        //       borderSide: BorderSide(color: AppColor.greenColor),
                        //     ),
                        //     focusedBorder: OutlineInputBorder(
                        //       borderSide: BorderSide(color: AppColor.greenColor),
                        //     ),
                        //   ),
                        // ),
                        // Consumer2<WifiController, DeviceController>(
                        //     builder: (context, wifiController, deviceController, child) {
                        //   return ElevatedButton(
                        //     onPressed: () async {
                        //       bool result = await wifiController.connectToWifi(

                        //           ///Connecting to the wifi
                        //           ssidController.text,
                        //           passwdController.text);
                        //       if (result) {
                        //         ///if wifi has been connected successfully then send the wifi SSID and password to the device
                        //         deviceController.sendToDevice(
                        //             "${ssidController.text}/${passwdController.text}",
                        //             WRITECHARACTERISTICS);

                        //         /// ignore: use_build_context_synchronously
                        //         // Navigator.pushReplacement(
                        //         //   context,
                        //         //   MaterialPageRoute(
                        //         //     builder: (context) => const CommandPage(),
                        //         //   ),
                        //         // );
                        //         Go.pushReplacement(
                        //             context: context, pushReplacement: const CommandPage());
                        //       }
                        //     },
                        //     style: ElevatedButton.styleFrom(
                        //         backgroundColor: AppColor.purpleColor,
                        //         shadowColor: AppColor.blackColor,
                        //         elevation: 10),
                        //     child: const Text("Submit / Connect "),
                        //   );
                        // })
                      ),
              ),
            );
          } else {
            return InkWell(
              onTap: () {
                context
                    .read<WifiController>()
                    .wifiScanPermissionDialog(context);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "Walk Device needs to connect to Wifi\nPlease give permission for scan\nAnd select your home Wifi.",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Icon(Icons.perm_scan_wifi),
                ],
              ),
            );
          }
        }),
      ),
    );
  }

  Widget wifiSignal(int level) {
    if (level > -70) {
      return const Icon(Icons.signal_wifi_4_bar_rounded);
    } else if (level > -80) {
      return const Icon(Icons.network_wifi_2_bar_rounded);
    } else {
      return const Icon(Icons.network_wifi_1_bar);
    }
  }
}
