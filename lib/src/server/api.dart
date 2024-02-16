import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:walk/src/db/local_db.dart';
import 'dart:convert';

import 'package:walk/src/views/user/revisedaccountpage.dart';

class API {
  static addData(List<dynamic> score) async {
    var baseUrl = (country == "India")
        ? "https://f02966xlb7.execute-api.ap-south-1.amazonaws.com/flutterdata/flutter-app-s3-ap-south-1-mumbai/"
        : "https://wcdq86190h.execute-api.eu-west-2.amazonaws.com/DevS/flutter-app-s3-eu-west-2-london/";

    print("scores is coming");

    var url = Uri.parse(
        "$baseUrl${LocalDB.user!.name.trimRight()}/test-${DateTime.now()}.json");
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
