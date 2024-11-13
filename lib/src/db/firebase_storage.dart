import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseStorageDB {
  static Future<void> getData() async {
    final storage = FirebaseStorage.instance;
    final storageRef = storage.ref();

    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final files = directory?.listSync();
    if (files != null) {
      for (var file in files) {
        if (file is File) {
          var fileName = file.path.split('/').last;
          var folderName = FirebaseAuth.instance.currentUser!.uid;
          final uploadRef = storageRef.child("$folderName/$fileName");
          if ((fileName.contains("ball") ||
                  fileName.contains("swing") ||
                  fileName.contains("fish")) &&
              !fileName.contains("-")) {
            try {
              if (file.path.endsWith('.csv')) {
                var fileLines = await file.readAsLines();
                if (fileLines.length > 23) {
                  await uploadRef.putData(await file.readAsBytes());
                }
              }
            } catch (e) {
              debugPrint("---> $e");
            }
          }
        }
      }
    }
  }

  static Future<void> storeReportFile(File file) async {
    final storage = FirebaseStorage.instance;
    final storageRef = storage.ref();

    var fileName = file.path.split('/').last;
    var folderName = FirebaseAuth.instance.currentUser!.uid;
    final uploadRef = storageRef.child("$folderName/$fileName");

    try {
      await uploadRef.putData(await file.readAsBytes());
    } catch (e) {
      debugPrint("---> $e");
    }
  }
}
