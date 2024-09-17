import 'dart:developer';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:walk/env/flavors.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/server/upload.dart';
// import 'package:walk/src/utils/awshelper.dart/awsauth.dart';
import 'package:walk/src/utils/firebasehelper.dart/firebasedb.dart';
import 'package:walk/src/utils/version_number.dart';
import 'package:walk/walk_app.dart';

RiveFile? file;

void main() async {
  /// Ensuring widgets initialization
  WidgetsFlutterBinding.ensureInitialized();
  log("Running Main.dart");

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.top,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set your desired color here
      statusBarIconBrightness: Brightness.light, // For light or dark icons
    ),
  );

  /// Setting up Environment
  Flavors.setupEnvironment(Environment.prod);

  /// Fixed app in potrait mode
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /// Initializes the firebase
  await FirebaseDB.initFirebaseServices();
  // await initServices();

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  await FirebaseAppCheck.instance.activate(
    //Tried with enum 'debug' in emulator and 'playIntegrity' in real device
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.playIntegrity, //AndroidProvider.playIntegrity
    appleProvider: AppleProvider.appAttest,
  );

  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    VersionNumber.versionNumber = packageInfo.version;
  });

  /// initializes Hive local databased
  await initializeLocalDatabase();

  Provider.debugCheckInvalidValueType = null;

  // UploadData.uplaod();

  // final file = File('${directory!.path}/test.txt');
  // await file.writeAsString('Hello, World!');

  // NotificationService.initNotification();
  // NotificationService.cancelScheduledNotifications();
  // NotificationService.sendScheduledTestNotification();

  // AWSAuth.configureAmplify();

  /// Core app
  runApp(
    const WalkApp(),
  );
}
