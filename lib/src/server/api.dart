import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class API {
  static addData(String score) async {
    print("scores is coming");
    var url = Uri.parse("http://10.137.51.28:2000/api/push");

    try {
      final res = await http.post(url, body: {'score': score});
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
