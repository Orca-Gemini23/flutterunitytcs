import 'dart:developer';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class NotificationService {
  static int testNotificationChannelId = 100;
  static String testChannelKey = "Test";
  static String testChannelDescription =
      "This channel is used to create test notifications";
  static String testChannelName = "WALK test notification channel";
  static NotificationChannel myTestNotificationChannel = NotificationChannel(
    channelKey: testChannelKey,
    channelName: testChannelName,
    channelDescription: testChannelDescription,
    defaultColor: Colors.white,
    importance: NotificationImportance.High,
    channelShowBadge: true,
  );

  static NotificationChannel myScheduledNotificationChannel =
      NotificationChannel(
    channelKey: 'scheduled_channel',
    channelName: 'Scheduled Notifications',
    channelDescription:
        "This channel is used to create scheduled notifications",
    defaultColor: Colors.white,
    importance: NotificationImportance.High,
    channelShowBadge: true,
  );

  static initNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        myTestNotificationChannel,
        myScheduledNotificationChannel,
      ],
      debug: true,
    );
    await listenToNotificationResults();
  }

  static notificationPermission(context) {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Allow Notifications'),
            content: const Text('Our app would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Don\'t Allow',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: const Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          ),
        );
      }
    });
  }

  static sendNormalTestNotification({String? title, String? body}) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: testChannelKey,
      title: title ?? "Default Title",
      body: body ?? "Default Body",
      color: Colors.white,
    ));
  }

  static Future<void> sendScheduledTestNotification(
      {String? title, String? body}) async {
    int intervalMinutes = 60 ~/ 3;
    for (int i = 0; i < 3; i++) {
      try {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
            channelKey: 'scheduled_channel',
            title: title ?? "Reminder!!! Do Therapy.",
            body: body ?? "Don't Missout the therapy for better you.",
            color: Colors.white,
          ),
          actionButtons: [
            NotificationActionButton(key: 'DO_NOW', label: 'Do Now'),
            NotificationActionButton(key: 'MARK_DONE', label: 'Mark Done')
          ],
          schedule: NotificationCalendar(
            weekday: DateTime.now().weekday,
            hour: DateTime.now().hour > 13 ? 17 : 11,
            minute: 0 + intervalMinutes * i,
            second: 0,
            millisecond: 0,
            repeats: true,
          ),
        );
      } catch (e) {
        log("notification disabled due to $e");
      }
    }
  }

  static sendNotificationWithButtons() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: testNotificationChannelId,
        channelKey: testChannelKey,
        title: "Hey , testing notifications",
        body:
            "Hope You are doing fine !!!! , seems like you have not connected to WALK want to connect ????",
        color: Colors.white,
      ),
      actionButtons: [
        NotificationActionButton(
            key: "true",
            label: "Scan and Connect",
            color: Colors.white,
            actionType: ActionType.KeepOnTop),
        NotificationActionButton(
            key: "false",
            label: "Not right now",
            color: Colors.white,
            actionType: ActionType.DismissAction),
      ],
    );
  }

  static listenToNotificationResults() async {
    bool result = await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
    return result;
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.channelKey == 'scheduled_channel' && Platform.isIOS) {
      AwesomeNotifications().getGlobalBadgeCounter().then(
            (value) => AwesomeNotifications().setGlobalBadgeCounter(value - 1),
          );
    }
    if (receivedAction.buttonKeyPressed == "true") {
      //startBackgroundservice
      log("Attempting to start foreground service");
      FlutterBackgroundService().invoke("setAsForeground");
    }
    log("coming here");
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {}
}
