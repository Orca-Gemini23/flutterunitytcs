import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:walk/src/constants/app_assets.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/controllers/devicecontroller.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/views/auth/login_page.dart';
import 'package:walk/src/views/device/wifipage.dart';
import 'package:walk/src/widgets/loadingdialog.dart';
import 'package:walk/src/widgets/navigationdrawer.dart';
import 'package:walk/test.dart';
import '../widgets/scanneditemtile.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key, required this.isShowCaseDone});
  final bool isShowCaseDone;
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with WidgetsBindingObserver {
  final GlobalKey globalKey1 = GlobalKey();
  final GlobalKey globalKey2 = GlobalKey();
  final GlobalKey globalKey3 = GlobalKey();
  final GlobalKey globalKey4 = GlobalKey();
  final PageController pageController = PageController();
  bool _isPeriodicRunning = false;

  bool _isInForeground = true;
  bool serviceStarted = false;
  static const platform = MethodChannel("example_service");
  String _serverState = "Did you not make the call yet ";
  Future<void> _startService() async {
    try {
      serviceStarted
          ? _stopService()
          : Timer(
              const Duration(seconds: 2),
              (() async {
                final result =
                    await platform.invokeMethod('startExampleService');

                ///TODO : Start Scan and try connecting to the device
              }),
            );
      setState(() {
        serviceStarted = true;
      });
    } on PlatformException catch (e) {
      log("Failed to invoke method: '${e.message}'.");
    }
  }

  Future<void> _stopService() async {
    try {
      final result = await platform.invokeMethod('stopExampleService');
      setState(() {
        _serverState = result;
        serviceStarted = false;
      });
    } on PlatformException catch (e) {
      log("Failed to invoke method: '${e.message}'.");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    (WidgetsBinding.instance).addPostFrameCallback(
      (_) {
        widget.isShowCaseDone
            ? null
            : ShowCaseWidget.of(context).startShowCase(
                [globalKey1, globalKey2, globalKey3, globalKey4],
              );
      },
    );
    context.read<DeviceController>().homeContext = context;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _stopService();
        log("app in resumed");
        break;
      case AppLifecycleState.inactive:
        _startService();
        log("app in inactive");
        break;
      case AppLifecycleState.paused:
        log("app in paused");
        break;
      case AppLifecycleState.detached:
        log("app in detached");
        _startService();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<DeviceController>().startDiscovery();
      },
      child: Scaffold(
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
        body: Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: AppColor.bgColor,
          ),
          child: Consumer<DeviceController>(
            builder: (context, controller, child) {
              return ScannedDevicesList(
                controller: controller,
                gkey1: globalKey1,
                gkey2: globalKey2,
              );
            },
          ),
        ),
        floatingActionButton:

            ///TODO:Add refresh button
            Consumer<DeviceController>(
                builder: (context, controller, snapshot) {
          return FloatingActionButton(
            onPressed: () async {
              String value = await controller.getRawBatteryNewton();
              List<Map<String, String>> batteryMap = [];

              Timer.periodic(
                const Duration(seconds: 5),
                (timer) async {
                  String value = await controller.getRawBatteryNewton();
                  if (value != "error occurred") {
                    batteryMap.clear();
                    batteryMap.add({
                      "Time": DateTime.now().toString(),
                      "BattValue": "$value"
                    });
                    Test.exportCSV(batteryMap);
                  }
                },
              );

              //controller.getProvisionedStatus();
              // Go.to(context: context, push: WifiPage());
              // print("LEngth is " + controller.info.length.toString());
              // controller.info.forEach((element) {
              //   print(element);
              // });
              // loadingDialog(context);

              // showDialog(
              //   context: (context),
              //   builder: (context) {
              //     return Dialog(
              //       shape: const RoundedRectangleBorder(
              //           side: BorderSide.none,
              //           borderRadius: BorderRadius.all(Radius.circular(20))),
              //       child: Container(
              //         decoration: BoxDecoration(
              //             color: AppColor.greenDarkColor,
              //             borderRadius: BorderRadius.circular(20)),
              //         height: 400,
              //         child: PageView(
              //           controller: pageController,
              //           physics: const BouncingScrollPhysics(),
              //           scrollDirection: Axis.horizontal,
              //           pageSnapping: true,
              //           padEnds: true,
              //           onPageChanged: (value) {
              //             pageController.initialPage == 4
              //                 ? pageController.dispose()
              //                 : null;
              //           },
              //           children: [
              //             Container(
              //               padding: const EdgeInsets.all(8),
              //               width: double.maxFinite,
              //               decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(20)),
              //               child: Stack(children: [
              //                 const Positioned(
              //                     child: Text(
              //                   AppString.takeOutBands,
              //                   style: TextStyle(
              //                     color: AppColor.whiteColor,
              //                     fontSize: 20,
              //                   ),
              //                 )),
              //                 Center(
              //                   child: Image.asset(
              //                     AppAssets.productImage,
              //                     fit: BoxFit.fill,
              //                   ),
              //                 ),
              //               ]),
              //             ),
              //             Container(
              //               padding: const EdgeInsets.all(8),
              //               width: double.maxFinite,
              //               decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(20)),
              //               child: Stack(
              //                 children: [
              //                   const Positioned(
              //                     child: Text(
              //                       AppString.turnOnSwitch,
              //                       style: TextStyle(
              //                         color: AppColor.whiteColor,
              //                         fontSize: 20,
              //                       ),
              //                     ),
              //                   ),
              //                   // Center(
              //                   //   child: Image.asset(
              //                   //     AppAssets.buttonAnimation,
              //                   //     fit: BoxFit.fill,
              //                   //   ),
              //                   // ),
              //                 ],
              //               ),
              //             ),
              //             Container(
              //               width: double.maxFinite,
              //               color: Colors.blue,
              //               child: const Center(
              //                 child: Text("helkloooo"),
              //               ),
              //             ),
              //             Container(
              //               padding: const EdgeInsets.all(8),
              //               width: double.maxFinite,
              //               decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(20)),
              //               child: Stack(children: [
              //                 const Positioned(
              //                   child: Text(
              //                     "Please take out the bands from the box , and put them on a table.",
              //                     style: TextStyle(
              //                       color: Colors.white,
              //                       fontSize: 20,
              //                     ),
              //                   ),
              //                 ),
              //                 Center(
              //                   child: Image.asset(
              //                     "assets/images/product.png",
              //                     fit: BoxFit.fill,
              //                   ),
              //                 ),
              //                 Align(
              //                   alignment: Alignment.bottomRight,
              //                   child: ElevatedButton(
              //                     child: const Text("Close"),
              //                     onPressed: () {
              //                       Navigator.of(context, rootNavigator: true)
              //                           .pop();
              //                     },
              //                   ),
              //                 )
              //               ]),
              //             ),
              //           ],
              //         ),
              //       ),
              //     );
              //   },
              // );
            },
          );
        }),
      ),
    );
  }
}
