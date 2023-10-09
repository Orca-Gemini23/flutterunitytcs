import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:walk/env/flavors.dart';
import 'package:walk/src/db/local_db.dart';

import 'package:walk/src/utils/firebasehelper.dart/firebasedb.dart';
import 'package:walk/walk_app.dart';

RiveFile? file;

void main() async {
  /// Ensuring widgets initialization
  WidgetsFlutterBinding.ensureInitialized();
  log("Running Main.dart");

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.top,
  ]);
  Provider.debugCheckInvalidValueType = null;

  /// Setting up Environment
  Flavors.setupEnvironment(Environment.prod);

  /// Fixed app in potrait mode
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /// Initializes the firebase
  await FirebaseDB.initFirebaseServices();
  // await initServices();

  await initializeLocalDatabase();

  /// initializes Hive local databased

  // NotificationService.initNotification();

  /// Core app
  runApp(
    const WalkApp(),
  );
}
