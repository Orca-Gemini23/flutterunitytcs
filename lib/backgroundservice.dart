// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';
// import 'dart:ui';
//
// import 'package:flutter_background_service/flutter_background_service.dart';
// // import 'package:flutter_blue/flutter_blue.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:path_provider/path_provider.dart';
//
// import 'package:walk/src/constants/bt_constants.dart';
//
// int walkServiceNotificationChannelId = 101;
// String walkServiceNotificationChannelKey = "WALKFGS";
// String walkServiceNotificationChannelName = "WALK Service Notification Channel";
// String walkServiceNotificationChannelDescription =
//     "This is the primary notification channel used by WALK to display foreground service notifications";
//
// Future<void> initServices() async {
//   final service = FlutterBackgroundService();
//   // NotificationChannel walkServiceNotificationChannel = NotificationChannel(
//   //   channelKey: walkServiceNotificationChannelKey,
//   //   channelName: walkServiceNotificationChannelName,
//   //   channelDescription: walkServiceNotificationChannelDescription,
//   //   defaultColor: const Color(0XFFCBE2D2),
//   // );
//
//   await service.configure(
//     iosConfiguration: IosConfiguration(),
//     androidConfiguration: AndroidConfiguration(
//         onStart: onStart,
//         isForegroundMode: false,
//         notificationChannelId: walkServiceNotificationChannelKey,
//         foregroundServiceNotificationId: 101,
//         initialNotificationTitle: "WALK",
//         initialNotificationContent: "Keep WALK - inggg !!!"),
//   );
//
//   service.startService();
// }
//
// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();
//
//   List<BluetoothDevice> connDevices = [];
//   List<BluetoothService> services = [];
//   List<String> battValues = [];
//   List<BluetoothCharacteristic> characteristics = [];
//   Map<Guid, BluetoothCharacteristic> characteristicMap = {};
//   Timer? timer;
//
//   //// Fix this issue
//   ///When the service is running and the user puts the service in the background(ie when the app is opened) after which if the user closes the application another timer starts which results in concurrent scans;
//
//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen(
//       (event) async {
//         await service.setAsForegroundService();
//         await service.setForegroundNotificationInfo(
//             title: "Finding WALK 🕵🏽‍♂️🕵🏽‍♂️🕵🏽‍♂️🕵🏽‍♂️",
//             content: "Our detective is scanning for the device to connect ");
//         // service.setForegroundNotificationInfo(title: title, content: content)
//         timer = Timer.periodic(
//           const Duration(seconds: 10),
//           (timer) async {
//             connDevices = await FlutterBluePlus.connectedSystemDevices;
//             // write(
//             //   "Periodic called at ====> ${DateTime.now().toUtc().toString()}",
//             // );
//             if (connDevices.isEmpty) {
//               FlutterBluePlus.scan(
//                 withServices: [
//                   Guid("0000acf0-0000-1000-8000-00805f9b34fb"),
//                 ],
//                 scanMode: ScanMode.opportunistic,
//                 timeout: const Duration(
//                   seconds: 5,
//                 ),
//               ).listen(
//                 (scannedDevice) async {
//                   await scannedDevice.device
//                       .connect(); ////Connected to the device
//                   connDevices.add(scannedDevice.device);
//                   services = await connDevices.elementAt(0).discoverServices();
//                   characteristicMap.clear();
//                   characteristics = services
//                       .where((element) => element.uuid == SERVICE)
//                       .first
//                       .characteristics;
//                   BluetoothCharacteristic? clientTarget =
//                       characteristics.firstWhere((element) =>
//                           element.uuid == BATTERY_PERCENTAGE_CLIENT);
//                   BluetoothCharacteristic? serverTarget =
//                       characteristics.firstWhere((element) =>
//                           element.uuid == BATTERY_PERCENTAGE_SERVER);
//                   battValues = await getBatteryPercentageValues(
//                       clientTarget, serverTarget);
//
//                   ////Display a notification showing the left and right battery values
//                   await service.setForegroundNotificationInfo(
//                       title: "WALK Connected !!!!! 😎😎😎😎",
//                       content:
//                           "Left Battery :${battValues[1]}%  Right Battery :${battValues[0]}%");
//                 },
//               );
//             } else {
//               await connDevices.elementAt(0).connect();
//               services = await connDevices.elementAt(0).discoverServices();
//               characteristicMap.clear();
//               characteristics = services
//                   .where((element) => element.uuid == SERVICE)
//                   .first
//                   .characteristics;
//               BluetoothCharacteristic? clientTarget =
//                   characteristics.firstWhere(
//                       (element) => element.uuid == BATTERY_PERCENTAGE_CLIENT);
//               BluetoothCharacteristic? serverTarget =
//                   characteristics.firstWhere(
//                       (element) => element.uuid == BATTERY_PERCENTAGE_SERVER);
//               battValues =
//                   await getBatteryPercentageValues(clientTarget, serverTarget);
//
//               ////Display a notification showing the left and right battery values
//               await service.setForegroundNotificationInfo(
//                   title: "WALK Connected !!!!! 😎😎😎😎",
//                   content:
//                       "Left Battery :${battValues[1]}%  Right Battery :${battValues[0]}%");
//             }
//           },
//         );
//       },
//     );
//     service.on('setAsBackground').listen((event) async {
//       log("setAsBackground");
//       await service.setAsBackgroundService();
//       if (timer != null) {
//         timer!.cancel(); //// cancel any previously running timer ,
//       }
//     });
//   }
//   service.on("stopService").listen(
//     (event) {
//       log("stopping Service");
//       if (timer != null) {
//         timer!.cancel();
//       }
//       service.stopSelf();
//     },
//   );
// }
//
// Future<List<String>> getBatteryPercentageValues(
//     BluetoothCharacteristic? clientTarget,
//     BluetoothCharacteristic? serverTarget) async {
//   String batteryS = "--%";
//   String batteryC = "--%";
//   try {
//     var clientResponse = await clientTarget!.read();
//     var serverResponse = await serverTarget!.read();
//     String tempBattC = String.fromCharCodes(clientResponse);
//     String tempBattS = String.fromCharCodes(serverResponse);
//     if (double.parse(tempBattS) > 100 || double.parse(tempBattS) < 0) {
//       log("Server Battery Percentage Out of Limit , modifying ....");
//       if (double.parse(tempBattS) > 100) {
//         batteryS = "100";
//       } else {
//         batteryS = "0";
//       }
//     }
//     if (double.parse(tempBattC) > 100 || double.parse(tempBattC) < 0) {
//       log("Client battery percentage Out of Limit , modifying");
//       if (double.parse(tempBattC) > 100) {
//         batteryC = "100";
//       } else {
//         batteryC = "0";
//       }
//     } else {
//       log("Battery values in range");
//       log("CLIENT BATTERY PERCENTAGE is $tempBattC");
//       log("SERVER BATTERY PERCENTAGE is $tempBattS");
//       batteryC = tempBattC;
//       batteryS = tempBattS;
//     }
//     return [batteryC, batteryS];
//   } catch (e) {
//     log(e.toString());
//     log("Something went wrong while getting batteryValues.");
//     return [batteryC, batteryS];
//   }
// }
//
// write(String text) async {
//   final Directory? directory = await getExternalStorageDirectory();
//   final File file = File('${directory!.path}/counterfile.txt');
//   await file.writeAsString(text, mode: FileMode.writeOnlyAppend);
// }
//
// ///   Background Service How its supposed to work
// ///1. When the app closes or pauses a notification should pop up asking whether to start the connection and scanning or not.
// ///2. If yes then check whether WALK is connected or not ,
// ///3. If yes then you should connect to the device and discover the services and characteristics
// ///4. If not then scan for the device and connect to it and discover the services and characteristics
// ///5. After the services and characteristics have been discovered get the battery value and display the details
// ///6. Also give the user a refresh button to refresh the battery values or set a timer that scansif the device is present or not if not present then scan and connect else just refresh the battery values
// ///7. Try integrating a stream function for it so that upon the ConnectedBluetoothDevice state you can change the notification type
// ///
// ///
// ///
// // AwesomeNotifications().createNotification(
// //     content: NotificationContent(
// //         id: walkServiceNotificationChannelId,
// //         autoDismissible: false,
// //         locked: true,
// //         category: NotificationCategory.Status,
// //         channelKey: walkServiceNotificationChannelKey,
// //         notificationLayout: NotificationLayout.Default,
// //         color: const Color(0xff005749),
// //         backgroundColor: const Color(0XFFCBE2D2),
// //         title: "WALK Connected !!!!! 😎😎😎😎",
// //         body:
// //             "Left Battery :${battValues[1]}%  Right Battery :${battValues[0]}%",
// //         summary:
// //             "Left Battery :${battValues[1]}%  Right Battery :${battValues[0]}%"),
// //     actionButtons: [
// //       NotificationActionButton(
// //         key: "true",
// //         label: "Refresh",
// //         actionType: ActionType.KeepOnTop,
// //       )
// //     ],
// // );
