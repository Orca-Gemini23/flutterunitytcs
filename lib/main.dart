import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:walk/env/flavors.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/utils/firebasehelper.dart/firebasecm.dart';
import 'package:walk/src/utils/firebasehelper.dart/firebasedb.dart';
import 'package:walk/src/utils/global_variables.dart';
import 'package:walk/walk_app.dart';

final navigatorKey = GlobalKey<NavigatorState>();

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
  if (kDebugMode) {
    log("its debug mode");
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
  }

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  await FirebaseAppCheck.instance.activate(
    //Tried with enum 'debug' in emulator and 'playIntegrity' in real device
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider:
        AndroidProvider.playIntegrity, //AndroidProvider.playIntegrity
    appleProvider: AppleProvider.appAttest,
  );

  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    VersionNumber.versionNumber = packageInfo.version;
  });

  /// initializes Hive local databased
  await initializeLocalDatabase();
  FirebaseCM().initNotifications();

  await dotenv.load(fileName: '.env');

  // Provider.debugCheckInvalidValueType = null;

  /// Core app
  runApp(
    const WalkApp(),
  );
}
