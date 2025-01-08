import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class UploadData {
  static uplaod() async {
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
              request.files.add(await http.MultipartFile.fromPath('file', file.path));
            } catch (e) {
              log('Error adding file to request: $e');
            }

            try {
              var response = await request.send();

              if (response.statusCode == 200) {
                log('Uploaded $fileName!');
                // try {
                //   await file.delete();
                // } catch (e) {
                //   log('Error deleting $fileName: $e');
                // }
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
}
