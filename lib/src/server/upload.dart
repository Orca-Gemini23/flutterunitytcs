import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:walk/src/controllers/shared_preferences.dart';
import 'package:walk/src/db/firebase_storage.dart';
import 'package:walk/src/db/local_db.dart';

class UploadData {
  static upload() async {
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
          if (fileName.contains("ball") ||
              fileName.contains("swing") ||
              fileName.contains("fish")) {
            var folderName = FirebaseAuth
                .instance.currentUser!.uid; // Replace with actual folder name
            var request = http.MultipartRequest(
              'PUT',
              Uri.parse(
                  'https://exp1-nr25govfzq-uc.a.run.app/upl/$folderName/$fileName'),
              //TODO Replace with onCall() function specifically for uploading file based on user creds
            );
            try {
              request.files
                  .add(await http.MultipartFile.fromPath('file', file.path));
            } catch (e) {
              log('Error adding file to request: $e');
            }

            try {
              var response = await request.send();

              if (response.statusCode == 200) {
                log('Uploaded $fileName!');

              } else {
                log('Upload failed for $fileName!');
              }
            } catch (e) {
              log('Upload failed for $fileName! $e');
            }
          }
        }
      }
    }
  }

  static Future<List<FileSystemEntity>> getExternalFiles() async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    if (directory != null) {
      return directory.listSync(); // Get the list of files
    } else {
      return [];
    }
  }

  static String renameFile(String fileName) {
    fileName = fileName.split('-')[1];
    if (fileName.startsWith("b")) {
      var timestamp = fileName.substring(4, 17);
      DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
      fileName = "ball game session $date";
      return "Ball";
    } else if (fileName.startsWith("s")) {
      var timestamp = fileName.substring(5, 18);
      DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
      fileName = "swing game session $date";
      return "Swing";
    } else if (fileName.startsWith("f")) {
      var timestamp = fileName.substring(4, 17);
      DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
      fileName = "fish game session $date";
      return "Fish";
    }

    return "";
  }

  final Report report;
  UploadData(this.report);

  Future<void> loadFiles() async {
    List<FileSystemEntity> files = await getExternalFiles();
    List<FileSystemEntity> gameFiles = [];
    files
        .sort((a, b) => a.statSync().modified.compareTo(b.statSync().modified));
    for (var file in files) {
      if (file is File) {
        // print(file.path);
        var fileName = file.path.split('/').last;
        if (fileName.contains("-")) {
          // print(file.path);
          if (fileName.contains("ball") ||
              fileName.contains("swing") ||
              fileName.contains("fish")) {
            String uid = fileName.split('-')[0];
            // String fileTimeStamp = fileName.split('-')[1];
            if (uid == FirebaseAuth.instance.currentUser!.uid) {
              if (file.path.endsWith('.csv')) {
                var fileLines = await file.readAsLines();
                log(file.path);
                if (fileLines.length > 6 &&
                    fileLines[0].split(",").last == "SessionID") {
                  await report.reportGeneration(
                      file.path, renameFile(fileName));
                } else {
                  file.delete();
                }
              } else if (file.path.endsWith('.pdf')) {
                gameFiles.add(file);
              }
            }
          }
        }
      }
    }
  }
}

class Report extends ChangeNotifier {
  bool _loaded = false;
  bool get loaded => _loaded;

  Future<void> reportGeneration(String filePathInput, String gameName) async {
    String weight = await PreferenceController.getstringData("Weight");
    var uri = Uri.https(
        'csvreport-gen-kujosay34a-el.a.run.app', "/", {'weight': weight});

    // Boundary string
    String boundary = 'wL36Yn8afVp8Ag7AmP8qZ0SA4n1v9T';

    // File path and type
    String filePath = filePathInput;
    String fileName = filePath.split('/').last;
    String mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';

    // Reading the file
    File file = File(filePath);
    Uint8List fileBytes = await file.readAsBytes();

    // Building multipart body
    var body = '--$boundary\r\n'
        'Content-Disposition: form-data; name="dataBall"; filename="$fileName"\r\n'
        'Content-Type: $mimeType\r\n\r\n'
        '${utf8.decode(fileBytes)}\r\n'
        '--$boundary--\r\n';

    // Building request headers
    var headers = {
      'Authorization': dotenv.env['Authorization_token'] ?? "",
      'name': LocalDB.user!.name,
      'age': LocalDB.user!.age,
      // 'sex': LocalDB.user!.gender,
      'Content-Type': 'multipart/form-data; boundary=$boundary',
    };

    // Sending the request until 200 status
    bool uploaded = false;
    while (!uploaded) {
      var response = await http.post(uri, headers: headers, body: body);
      log(DateTime.now().toString());
      await Future.delayed(const Duration(seconds: 10)).then((_) {
        if (!uploaded) {
          uploaded = true;
        }
      });
      if (response.statusCode == 200) {
        uploaded = true;
        final pdfFilePath =
            "${filePathInput.substring(0, filePathInput.length - 3)}pdf";

        File pdfFile = File(pdfFilePath);
        await pdfFile.writeAsBytes(response.bodyBytes);
        await FirebaseStorageDB.storeReportFile(pdfFile);
        _loaded = true;
        notifyListeners();
        if (await file.exists()) {
          file.deleteSync();
        }
        await Future.delayed(const Duration(seconds: 1));
        log('uploaded file. $pdfFilePath. Status code: ${response.statusCode}');
        _loaded = false;
        notifyListeners();
      } else {
        log('Failed to upload file. Status code: ${response.statusCode}');
      }
    }
  }
}
