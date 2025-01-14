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
import 'package:walk/src/utils/firebase/firebase_db.dart';
import 'package:walk/src/utils/firebase/firebase_messaging.dart';
import 'package:walk/src/utils/global_variables.dart';
import 'package:walk/walk_app.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  log("Running Main.dart");

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  Flavors.setupEnvironment(Environment.prod);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await FirebaseDB.initFirebaseServices();

  if (kDebugMode) {
    log("its debug mode");
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
  }

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    appleProvider: AppleProvider.appAttest,
  );

  PackageInfo.fromPlatform().then((packageInfo) {
    VersionNumber.versionNumber = packageInfo.version;
  });

  await initializeLocalDatabase();
  FirebaseCM().initNotifications();
  await dotenv.load();

  runApp(const WalkApp());
}
