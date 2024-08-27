import 'dart:developer';
import 'dart:io';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:walk/env/flavors.dart';
import 'package:walk/src/db/local_db.dart';
// import 'package:walk/src/utils/awshelper.dart/awsauth.dart';
import 'package:http/http.dart' as http;
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
  Provider.debugCheckInvalidValueType = null;

  //TODO This code block needs to be placed under check if user is logged in ,
  //TODO or in a function where it is called after every therapy session

  final directory = await getExternalStorageDirectory();
  final files = directory?.listSync();
  if (files != null) {
    for (var file in files) {
      if (file is File) {
        var fileName = file.path.split('/').last;
        var folderName = 'Data'; // Replace with actual folder name
        var request = http.MultipartRequest(
          'PUT',
          Uri.parse('https://exp1-nr25govfzq-uc.a.run.app/upl/$folderName/$fileName'),
          //TODO Replace with onCall() function specifically for uploading file based on user creds
        );
        request.files.add(await http.MultipartFile.fromPath('file', file.path));
        var response = await request.send();
        if (response.statusCode == 200) {
          log('Uploaded $fileName!');
          try {
            await file.delete();
          } catch (e) {
            log('Error deleting $fileName: $e');
          }
        } else {
          log('Upload failed for $fileName!');
        }
      }
    }
  }
  // final file = File('${directory!.path}/test.txt');
  // await file.writeAsString('Hello, World!');


  /// Setting up Environment
  Flavors.setupEnvironment(Environment.prod);

  /// Fixed app in potrait mode
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /// Initializes the firebase
  await FirebaseDB.initFirebaseServices();
  // await initServices();

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  await initializeLocalDatabase();

  await FirebaseAppCheck.instance.activate(
    //Tried with enum 'debug' in emulator and 'playIntegrity' in real device
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug, //AndroidProvider.playIntegrity
    appleProvider: AppleProvider.appAttest,
  );

  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    VersionNumber.versionNumber = packageInfo.version;
  });

  /// initializes Hive local databased

  // NotificationService.initNotification();
  // NotificationService.cancelScheduledNotifications();
  // NotificationService.sendScheduledTestNotification();

  // AWSAuth.configureAmplify();

  /// Core app
  runApp(
    const WalkApp(),
  );
}
