import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/controllers/devicecontroller.dart';
import 'package:walk/src/controllers/notificationcontroller.dart';
import 'package:walk/src/controllers/wificontroller.dart';
import 'package:walk/src/views/splashpage.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        ],
        child: const MaterialApp(
          home: SplashPage(),
          debugShowCheckedModeBanner: false,
        )),
  );
}
