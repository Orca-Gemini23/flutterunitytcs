// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/widgets/navigation_drawer.dart';
import '../widgets/scanned_item_tile.dart';

GlobalKey homepageKey = GlobalKey();

class Homepage extends StatefulWidget {
  const Homepage(
      {super.key, required this.isShowCaseDone, required this.isUnboxingDone});
  final bool isShowCaseDone;
  final bool isUnboxingDone;
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with WidgetsBindingObserver {
  bool serviceStarted = false;
  MethodChannel channel = const MethodChannel("com.lifespark.walk");

  @override
  void initState() {
    DeviceController(performScan: false, checkPrevconnection: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homepageKey,
      drawer: navigationDrawer(context),
      appBar: AppBar(
        title: const Text(
          AppString.homeTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColor.appBarColor,
      ),
      body: Consumer<DeviceController>(
          builder: (context, deviceController, child) {
        return RefreshIndicator(
          color: AppColor.greenDarkColor,
          onRefresh: () async {
            if (deviceController.scanStatus == true) {
              Fluttertoast.showToast(msg: "Please wait !! Scanning.....");
            } else {
              //await deviceController.startDiscovery();
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: AppColor.bgColor,
            ),
            child: ShowCaseWidget(
              builder: Builder(
                builder: (context) => Consumer<DeviceController>(
                  builder: (context, controller, child) {
                    return ScannedDevicesList(
                      controller: controller,
                      isShowCaseDone: widget.isShowCaseDone,
                      isUnboxingDone: widget.isUnboxingDone,
                    );
                  },
                ),
              ),
            ),
          ),
        );
      }),
      floatingActionButton:
          Consumer<DeviceController>(builder: (context, controller, snapshot) {
        return FloatingActionButton(
          onPressed: () async {
            channel.invokeMethod("scanForDevices");

            // String value =
            // await controller.getRawBatteryNewton();
            // List<Map<String, String>> batteryMap = [];

            // Timer.periodic(
            //   const Duration(seconds: 5),
            //   (timer) async {
            //     String value = await controller.getRawBatteryNewton();
            //     if (value != "error occurred") {
            //       batteryMap.clear();
            //       batteryMap.add(
            //           {"Time": DateTime.now().toString(), "BattValue": value});
            //       Test.exportCSV(batteryMap);
            //     }
            //   },
            // );
          },
        );
      }),
    );
  }
}
//controller.getProvisionedStatus();
            // Go.to(context: context, push: WifiPage());
            // print("LEngth is " + controller.info.length.toString());
            // controller.info.forEach((element) {
            //   print(element);
            // });
            // loadingDialog(context);

            



 // static const platform = MethodChannel("example_service");
  // String _serverState = "Did you not make the call yet ";
  // Future<void> _startService() async {
  //   try {
  //     serviceStarted
  //         ? _stopService()
  //         : Timer(
  //             const Duration(seconds: 2),
  //             (() async {
  //               // final result =
  //               await platform.invokeMethod('startExampleService');

  //               ///TODO : Start Scan and try connecting to the device
  //             }),
  //           );
  //     setState(() {
  //       serviceStarted = true;
  //     });
  //   } on PlatformException catch (e) {
  //     log("Failed to invoke method: '${e.message}'.");
  //   }
  // }

  // Future<void> _stopService() async {
  //   try {
  //     final result = await platform.invokeMethod('stopExampleService');
  //     setState(() {
  //       _serverState = result;
  //       serviceStarted = false;
  //     });
  //   } on PlatformException catch (e) {
  //     log("Failed to invoke method: '${e.message}'.");
  //   }
  // }
