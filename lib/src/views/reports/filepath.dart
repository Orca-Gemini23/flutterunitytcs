import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';

class FilePathChange {
  static Future<bool> getExternalFiles() async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    final files = directory?.listSync();
    if (directory != null) {
      String homePath = directory.path;
      if (files != null) {
        for (var file in files) {
          if (file is File) {
            var fileName = file.path.split('/').last;
            if (!fileName.contains("-")) {
              if (fileName.contains("ball") ||
                  fileName.contains("swing") ||
                  fileName.contains("fish")) {
                var fileLines = await file.readAsLines();
                if (fileLines.length > 6) {
                  try {
                    var destinationFile = await File(
                            "$homePath/${FirebaseAuth.instance.currentUser!.uid}-$fileName")
                        .create(recursive: true, exclusive: true);
                    await file.rename(destinationFile.path);
                  } catch (e) {
                    await file.delete();
                  }
                }
              }
            }
          }
        }
      }
    }
    return true;
  }
}
