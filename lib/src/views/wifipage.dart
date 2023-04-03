import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:walk/src/constants/constants.dart';
import 'package:walk/src/controllers/devicecontroller.dart';
import 'package:walk/src/controllers/wificontroller.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/views/commandpage.dart';
import 'package:walk/src/constants/bluetoothconstants.dart';

class WifiPage extends StatefulWidget {
  const WifiPage({super.key});

  @override
  State<WifiPage> createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage> {
  ///This page is used to obtain user's wifi ID and Password then connect to the wifi and send these wifi id and password to the device , wifi provisioning.
  final TextEditingController ssidController = TextEditingController();
  final TextEditingController passwdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Wifi Details"),
        backgroundColor: Color(APPBARCOLOR),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        height: double.infinity,
        width: double.infinity,
        child: Column(children: [
          TextField(
            controller: ssidController,
            decoration: const InputDecoration(
              labelText: "Wifi Id",
              labelStyle: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(),
          const SizedBox(
            height: 5,
          ),
          TextField(
            controller: passwdController,
            decoration: const InputDecoration(
              labelText: "Password",
              labelStyle: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
          ),
          Consumer2<WifiController, DeviceController>(
              builder: (context, wifiController, deviceController, child) {
            return ElevatedButton(
              onPressed: () async {
                bool result = await wifiController.connectToWifi(

                    ///Connecting to the wifi
                    ssidController.text,
                    passwdController.text);
                if (result) {
                  ///if wifi has been connected successfully then send the wifi SSID and password to the device
                  deviceController.sendToDevice(
                      "${ssidController.text}/${passwdController.text}",
                      WRITECHARACTERISTICS);

                  /// ignore: use_build_context_synchronously
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const CommandPage(),
                  //   ),
                  // );
                  Go.pushReplacement(
                      context: context, pushReplacement: const CommandPage());
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shadowColor: Colors.black,
                  elevation: 10),
              child: const Text("Submit / Connect "),
            );
          })
        ]),
      ),
    );
  }
}
