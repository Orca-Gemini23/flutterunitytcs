import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:walk/src/db/local_db.dart';
import 'dart:convert';

class API {
  static const baseUrl =
      "https://yxptx2bvl2.execute-api.ap-northeast-1.amazonaws.com/dev/flutter-app-data-s3/";

  static addData(List<dynamic> score) async {
    print("scores is coming");

    var url = Uri.parse(
        "$baseUrl${LocalDB.user!.name.trimRight()}test-${DateTime.now()}.json");
    // print(url);
    var jsonData = jsonEncode(score);

    try {
      final res = await http.put(url, body: jsonData);
      if (res.statusCode == 200) {
        var data = res.body.toString();
        print("Data written to file successfully: $data");
      } else {
        print("Failed to write data to the file");
      }
    } catch (e) {
      debugPrint("API Error: ${e.toString()}");
    }
  }
}
