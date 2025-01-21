import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseStorageDB {
  static Future<void> putData() async {
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
              fileName.contains("fish"))) {
            try {
              if (file.path.endsWith('.csv')) {
                var fileLines = await file.readAsLines();
                if (fileLines.length > 10) {
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

  static Future<void> downloadFiles() async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("/${FirebaseAuth.instance.currentUser!.uid}");
    storageRef.listAll().then((value) async {
      for (var item in value.items) {
        Directory? directory;
        String filename = "";
        if (Platform.isAndroid) {
          directory = await getExternalStorageDirectory();
        } else {
          directory = await getApplicationDocumentsDirectory();
        }
        if (item.fullPath.substring((item.fullPath.length - 3)) == "pdf") {
          filename = item.name;
          final file = File("${directory?.path}/$filename");
          FirebaseStorage.instance.ref().child(item.fullPath).writeToFile(file);
        }
      }
    });
  }
}
