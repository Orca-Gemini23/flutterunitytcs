import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:walk/src/controllers/shared_preferences.dart';

Future<void> reportGeneration(String filePathInput) async {
  String weight = await PreferenceController.getstringData("Weight");
  var uri = Uri.https(
      'csvreport-gen-kujosay34a-el.a.run.app', "/", {'weight': weight});
  log(uri.toString());

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
    'Authorization':
        'Bearer:eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJBdXRoZW50aWNhdGlvbiIsImlzcyI6ImxpZmVzcGFyay50ZWNoIiwiaWQiOjIzLCJjb3VudHJpZXMiOlsiSW5kaWEiLCJBdXN0cmFsaWEiLCJVU0EiXX0.1FEuK1FhyKIRzlDu_IjrRXd-WL4H6lOs2D88g4rTAdA',
    'Content-Type': 'multipart/form-data; boundary=$boundary',
  };

  // Sending the request until 200 status
  bool uploaded = false;
  while (!uploaded) {
    var response = await http.post(uri, headers: headers, body: body);
    // Printing the response
    if (response.statusCode == 200) {
      uploaded = true;
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }
      final pdfFilePath = '${directory!.path}/downloaded.pdf';
      File file = File(pdfFilePath);
      await file.writeAsBytes(response.bodyBytes);
      await OpenFile.open(pdfFilePath);
    } else {
      log('Failed to upload file. Status code: ${response.statusCode}');
    }
  }
}
