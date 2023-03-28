import 'dart:developer';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import "package:workmanager/workmanager.dart";
import 'package:walk/controllers/notificationcontroller.dart';
import 'package:walk/main.dart';

@pragma('vm:entry-point')
void alarmCallback() async {
  log("alarm Callback");
  // ignore: deprecated_member_use
  // Soundpool pool = Soundpool(streamType: StreamType.notification);

  // int soundId =
  //     await rootBundle.load("assets/beep.mp3").then((ByteData soundData) {
  //   return pool.load(soundData);
  // });
  // int streamId = await pool.play(soundId);

  Workmanager().executeTask((taskName, inputData) {
    log("Native Background Task by Workmanager !!!");
    return Future.value(true);
  });
  // customNotification(
  //   0001,
  //   "Closed the app ?",
  //   "Get up and start walking!!!!",
  // );
}

class BackgroundController extends ChangeNotifier {
  static void initAlarm() async {
    log("initAlarm");
    Workmanager().initialize(alarmCallback, isInDebugMode: true);
    Workmanager().registerOneOffTask(
      "Workmanager1",
      "Test by eashubh",
      initialDelay: const Duration(minutes: 15),
    );
    // AndroidAlarmManager.oneShot(
    //   const Duration(seconds: 10),
    //   0001,
    //   alarmCallback,
    //   exact: true,
    //   allowWhileIdle: true,
    // );
  }
}
