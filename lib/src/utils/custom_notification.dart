// import 'dart:developer';
// import 'dart:io';
// import 'dart:math';
//
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:walk/src/utils/custom_navigation.dart';
// import 'package:walk/src/views/reviseddevicecontrol/connectionscreen.dart';
//
// class NotificationService {
//   final BuildContext context;
//   NotificationService(this.context);
//   static int testNotificationChannelId = 100;
//   static String testChannelKey = "Test";
//   static String testChannelDescription =
//       "This channel is used to create test notifications";
//   static String testChannelName = "WALK test notification channel";
//   static NotificationChannel myTestNotificationChannel = NotificationChannel(
//     channelKey: testChannelKey,
//     channelName: testChannelName,
//     channelDescription: testChannelDescription,
//     defaultColor: Colors.white,
//     importance: NotificationImportance.High,
//     channelShowBadge: true,
//   );
//
//   static NotificationChannel myScheduledNotificationChannel =
//       NotificationChannel(
//     channelKey: 'scheduled_channel',
//     channelName: 'Scheduled Notifications',
//     channelDescription:
//         "This channel is used to create scheduled notifications",
//     defaultColor: Colors.white,
//     importance: NotificationImportance.High,
//     channelShowBadge: true,
//   );
//
//   static initNotification() async {
//     await AwesomeNotifications().initialize(
//       // null,
//       'resource://drawable/res_notification_app_icon',
//       [
//         myTestNotificationChannel,
//         myScheduledNotificationChannel,
//       ],
//       debug: true,
//     );
//   }
//
//   static notificationPermission(context) {
//     AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
//       if (!isAllowed) {
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Allow Notifications'),
//             content: const Text('Our app would like to send you notifications'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Text(
//                   'Don\'t Allow',
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 18,
//                   ),
//                 ),
//               ),
//               TextButton(
//                   onPressed: () => AwesomeNotifications()
//                       .requestPermissionToSendNotifications()
//                       .then((_) => Navigator.pop(context)),
//                   child: const Text(
//                     'Allow',
//                     style: TextStyle(
//                       color: Colors.teal,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ))
//             ],
//           ),
//         );
//       }
//     });
//   }
//
//   // static sendNormalTestNotification({String? title, String? body}) async {
//   //   await AwesomeNotifications().createNotification(
//   //       content: NotificationContent(
//   //     id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
//   //     channelKey: testChannelKey,
//   //     title: title ?? "Default Title",
//   //     body: body ?? "Default Body",
//   //     color: Colors.white,
//   //   ));
//   // }
//
//   static Future<void> sendScheduledTestNotification(
//       {String? title, String? body}) async {
//     bool isPermissionGranted =
//         await AwesomeNotifications().isNotificationAllowed();
//     int intervalMinutes = 60 ~/ 3;
//     if (isPermissionGranted) {
//       for (int i = 0; i < 3; i++) {
//         await AwesomeNotifications().createNotification(
//           content: NotificationContent(
//               id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
//               channelKey: 'scheduled_channel',
//               title: title ?? "Reminder!!! Do Therapy.",
//               body: body ?? "Don't Missout the therapy for better you.",
//               color: Colors.white,
//               payload: {'page': 'ConnectionScreen'}),
//           actionButtons: [
//             NotificationActionButton(key: 'DO_NOW', label: 'Do Now'),
//             NotificationActionButton(key: 'MARK_DONE', label: 'Mark as Done')
//           ],
//           schedule: NotificationCalendar(
//             weekday: DateTime.now().weekday,
//             hour: DateTime.now().hour > 13 ? 17 : 11,
//             minute: 0 + intervalMinutes * i,
//             second: 0,
//             millisecond: 0,
//             repeats: true,
//           ),
//         );
//       }
//     }
//   }
//
//   static Future<void> cancelScheduledNotifications() async {
//     await AwesomeNotifications().cancelAllSchedules();
//   }
//
//   // static sendNotificationWithButtons() async {
//   //   await AwesomeNotifications().createNotification(
//   //     content: NotificationContent(
//   //       id: testNotificationChannelId,
//   //       channelKey: testChannelKey,
//   //       title: "Hey , testing notifications",
//   //       body:
//   //           "Hope You are doing fine !!!! , seems like you have not connected to WALK want to connect ????",
//   //       color: Colors.white,
//   //     ),
//   //     actionButtons: [
//   //       NotificationActionButton(
//   //           key: "true",
//   //           label: "Scan and Connect",
//   //           color: Colors.white,
//   //           actionType: ActionType.KeepOnTop),
//   //       NotificationActionButton(
//   //           key: "false",
//   //           label: "Not right now",
//   //           color: Colors.white,
//   //           actionType: ActionType.DismissAction),
//   //     ],
//   //   );
//   // }
//
//   listenToNotificationResults() async {
//     bool result = await AwesomeNotifications().setListeners(
//       onActionReceivedMethod: onActionReceivedMethod,
//       onDismissActionReceivedMethod: onDismissActionReceivedMethod,
//     );
//     return result;
//   }
//
//   @pragma("vm:entry-point")
//   Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
//     if (receivedAction.channelKey == 'scheduled_channel') {
//       //&& Platform.isIOS) {
//       AwesomeNotifications().getGlobalBadgeCounter().then(
//         (value) {
//           AwesomeNotifications().setGlobalBadgeCounter(value - 1);
//         },
//       );
//     }
//     // if (receivedAction.buttonKeyPressed == "true") {
//     //   //startBackgroundservice
//     //   log("Attempting to start foreground service");
//     //   FlutterBackgroundService().invoke("setAsForeground");
//     // }
//     if (receivedAction.buttonKeyPressed == 'DO_NOW') {
//       await Go.to(context: context, push: const ConnectionScreen());
//       AwesomeNotifications().getGlobalBadgeCounter().then(
//         (value) {
//           AwesomeNotifications().setGlobalBadgeCounter(0);
//         },
//       );
//     }
//     if (receivedAction.buttonKeyPressed == 'MARK_DONE') {
//       AwesomeNotifications().getGlobalBadgeCounter().then(
//         (value) {
//           AwesomeNotifications().setGlobalBadgeCounter(0);
//         },
//       );
//       // AwesomeNotifications().cancel(receivedAction.id ?? 0);
//     }
//     // log("coming here");
//   }
//
//   @pragma("vm:entry-point")
//   static Future<void> onDismissActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     if (receivedAction.channelKey == 'scheduled_channel') {
//       // && Platform.isIOS) {
//       AwesomeNotifications().getGlobalBadgeCounter().then(
//             (value) => AwesomeNotifications().setGlobalBadgeCounter(value - 1),
//           );
//     }
//   }
// }
//
//
//
//
//
//
//
//
//
// // static Future<void> sendScheduledTestNotification(
// //       {String? title, String? body}) async {
// //     bool isPermissionGranted =
// //         await AwesomeNotifications().isNotificationAllowed();
// //     int intervalMinutes = 60 ~/ 3;
// //     if (isPermissionGranted) {
// //       for (int i = 0; i < 3; i++) {
// //         await AwesomeNotifications().createNotification(
// //           content: NotificationContent(
// //               id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
// //               channelKey: 'scheduled_channel',
// //               title: title ?? "Reminder!!! Do Therapy.",
// //               body: body ?? "Don't Missout the therapy for better you.",
// //               color: Colors.white,
// //               payload: {'page': 'ConnectionScreen'}),
// //           actionButtons: [
// //             NotificationActionButton(key: 'DO_NOW', label: 'Do Now'),
// //             NotificationActionButton(key: 'MARK_DONE', label: 'Mark as Done')
// //           ],
// //           schedule: NotificationCalendar(
// //             weekday: DateTime.now().weekday,
// //             hour: DateTime.now().hour > 13 ? 17 : 11,
// //             minute: 0 + intervalMinutes * i,
// //             second: 0,
// //             millisecond: 0,
// //             repeats: true,
// //           ),
// //         );
// //       }
// //     }
// //   }
//
// // static Future<void> sendScheduledTestNotification(
// //       {String? title, String? body}) async {
// //     bool isPermissionGranted =
// //         await AwesomeNotifications().isNotificationAllowed();
// //     int intervalMinutes = 20; // Set the desired interval in minutes
// //     int totalNotifications = 3; // Number of notifications to be sent
//
// //     if (isPermissionGranted) {
// //       // Calculate the start time for notifications
// //       DateTime now = DateTime.now();
// //       DateTime startTime = DateTime(now.year, now.month, now.day, 11, 0, 0);
// //       if (now.hour > 13) {
// //         startTime = DateTime(now.year, now.month, now.day, 17, 0, 0);
// //       }
//
// //       for (int i = 0; i < totalNotifications; i++) {
// //         DateTime notificationTime =
// //             startTime.add(Duration(minutes: i * intervalMinutes));
// //         int notificationId =
// //             notificationTime.millisecondsSinceEpoch.remainder(100000);
//
// //         await AwesomeNotifications().createNotification(
// //           content: NotificationContent(
// //               id: notificationId,
// //               channelKey: 'scheduled_channel',
// //               title: title ?? "Reminder!!! Do Therapy.",
// //               body: body ?? "Don't Missout the therapy for better you.",
// //               color: Colors.white,
// //               payload: {'page': 'ConnectionScreen'}),
// //           actionButtons: [
// //             NotificationActionButton(key: 'DO_NOW', label: 'Do Now'),
// //             NotificationActionButton(key: 'MARK_DONE', label: 'Mark as Done')
// //           ],
// //           schedule: NotificationCalendar(
// //             weekday: notificationTime.weekday,
// //             hour: notificationTime.hour,
// //             minute: notificationTime.minute,
// //             second: notificationTime.second,
// //             millisecond: notificationTime.microsecond ~/ 1000,
// //             repeats: true,
// //           ),
// //         );
// //       }
// //     }
// //   }
//
// // static Future<void> sendScheduledTestNotification(
//   //     {String? title, String? body}) async {
//   //   bool isPermissionGranted =
//   //       await AwesomeNotifications().isNotificationAllowed();
//   //   int intervalMinutes = 1;
//   //   List<String> dailyMessages = [
//   //     'Bugün harika bir gün!',
//   //     'Yeni bir şeyler öğrenmeye hazır mısınız?',
//   //     'Hayalinizdeki projeye başlama zamanı!',
//   //     'Güzel anları değerlendirin!',
//   //     'Bugün bir gülümsemeyle başlayın!',
//   //   ];
//
//   //   // Rastgele bir mesaj seç
//   //   Random random = Random();
//   //   var selectedMessage = dailyMessages[random.nextInt(dailyMessages.length)];
//   //   if (isPermissionGranted) {
//   //     for (int i = 0; i < 3; i++) {
//   //       await AwesomeNotifications().createNotification(
//   //         content: NotificationContent(
//   //             id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
//   //             channelKey: 'scheduled_channel',
//   //             title: title ?? selectedMessage,
//   //             body: body ?? "Don't Missout the therapy for better you.",
//   //             color: Colors.white,
//   //             payload: {'page': 'ConnectionScreen'}),
//   //         actionButtons: [
//   //           NotificationActionButton(key: 'DO_NOW', label: 'Do Now'),
//   //           NotificationActionButton(key: 'MARK_DONE', label: 'Mark as Done')
//   //         ],
//   //         schedule: NotificationCalendar(
//   //           weekday: DateTime.now().weekday,
//   //           hour: DateTime.now().hour > 13 ? 16 : 11,
//   //           minute: 32 + intervalMinutes * i,
//   //           second: 0,
//   //           millisecond: 0,
//   //           repeats: true,
//   //         ),
//   //       );
//   //     }
//   //   }
//   // }