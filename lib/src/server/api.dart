import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/db/sqlite_db.dart';
import 'dart:convert';

import 'package:walk/src/views/user/revisedaccountpage.dart';
import 'package:connectivity/connectivity.dart';

Future<bool> isNetworkAvailable() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}

void sendDataWhenNetworkAvailable() {
  Timer.periodic(const Duration(seconds: 30), (timer) async {
    if (await isNetworkAvailable()) {
      List localData = await DBHelper.instance.getData();
      for (var item in localData) {
        final jsonData = item['data']; // Get the JSON data from the map
        final decodedData = jsonDecode(jsonData);
        API.addData(decodedData);
        await DBHelper.instance.deleteData(item['id']);
      }
    }
  });
}

class API {
  static addData(List<dynamic> score) async {
    var baseUrl = (country == "India")
        ? "https://f02966xlb7.execute-api.ap-south-1.amazonaws.com/flutterdata/flutter-app-s3-ap-south-1-mumbai/"
        : "https://wcdq86190h.execute-api.eu-west-2.amazonaws.com/DevS/flutter-app-s3-eu-west-2-london/";

    debugPrint("score is coming");

    var jsonData = jsonEncode(score);

    String game = jsonData[1] == '1' ? "Swing" : "Ball";
    var url = Uri.parse(
        "$baseUrl${LocalDB.user!.name.trimRight()}/$game-${DateTime.now()}.json");
    // print(url);

    if (await isNetworkAvailable()) {
      try {
        final res = await http.put(url, body: jsonData);
        if (res.statusCode == 200) {
          var data = res.body.toString();
          debugPrint("Data written to file successfully: $data");
        } else {
          debugPrint("Failed to write data to the file");
        }
      } catch (e) {
        debugPrint("API Error: ${e.toString()}");
      }
    } else {
      await DBHelper.instance.insertData(score);
      List localData = await DBHelper.instance.getData();
      debugPrint('Data stored locally: $localData');
    }
  }

  static getScore() async {
    var baseUrl =
        "https://h1obcwd8tj.execute-api.ap-south-1.amazonaws.com/Data_S3/s3-gait-balance-score-data?file=${LocalDB.user!.name.trimRight()}.json";

    debugPrint("score is coming");

    var url = Uri.parse(baseUrl);
    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        debugPrint("Data fetched successfully: $data");
        debugPrint("${data.runtimeType}");
        return data;
      } else {
        debugPrint("Failed to fetch data ");
        return {'Gait Score': '', 'Balance Score': ''};
      }
    } catch (e) {
      debugPrint("API Error: ${e.toString()}");
    }
  }
}
