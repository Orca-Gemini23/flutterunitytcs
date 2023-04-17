import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:walk/src/utils/background_isolate.dart';
import 'package:walk/walk_app.dart';
import 'package:walk/src/controllers/notificationcontroller.dart';

void main() async {
  /// Ensuring widgets initialization
  WidgetsFlutterBinding.ensureInitialized();

  /// Fixed app in potrait mode
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /// Initializes the firebase
  await Firebase.initializeApp();

  /// GEt token for firebase messaging
  await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(showFirebaseNotification);

  /// Implements android notification channel
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Asks for notifiaction permission
  await Permission.notification.isDenied.then(
      (value) => {value == true ? Permission.notification.request() : null});

  /// initializing background and foreground services
  await initializeService();

  /// Core app
  runApp(const WalkApp());
}
