import 'dart:developer';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:provider/provider.dart';

import 'package:walk/controllers/backgroundcontroller.dart';
import 'package:walk/controllers/devicecontroller.dart';
import 'package:walk/controllers/notificationcontroller.dart';
import 'package:walk/controllers/wificontroller.dart';

import 'package:walk/views/splashpage.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AndroidAlarmManager.initialize();
  await FirebaseMessaging.instance.getToken();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(showFirebaseNotification);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => DeviceController(),
          ),
          ChangeNotifierProvider(
            create: (_) => WifiController(),
          ),
          ChangeNotifierProvider(
            create: (_) => BackgroundController(),
          ),
        ],
        child: const MaterialApp(
          home: SplashPage(),
          debugShowCheckedModeBanner: false,
        )),
  );
}
