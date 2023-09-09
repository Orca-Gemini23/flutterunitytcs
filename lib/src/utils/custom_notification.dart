import 'dart:developer';

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
      defaultColor: Colors.white);

  static initNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        myTestNotificationChannel,
      ],
      debug: true,
    );
    await listenToNotificationResults();
  }

  static sendNormalTestNotification({String? title, String? body}) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: testNotificationChannelId,
      channelKey: testChannelKey,
      title: title ?? "Default Title",
      body: body ?? "Default Body",
      color: Colors.white,
    ));
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
