import 'dart:developer';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

class Test {
  static Future<String> localPath() async {
    final dirName = await getExternalStorageDirectory();

    return dirName!.path;
  }

  static void exportCSV(List<Map<String, dynamic>> list) async {
    List<List<dynamic>> rows = [];
    rows.add(["Time", "BattValue"]);

    for (var map in list) {
      rows.add([map["Time"], map["BattValue"]]);
    }
    print(rows.toString());

    String csv = const ListToCsvConverter().convert(rows);
    String dir = await localPath();
    String filePath = "$dir/batteryTestData.csv";

    File file = File(filePath);
    file.writeAsStringSync(csv, mode: FileMode.writeOnlyAppend);
    Fluttertoast.showToast(msg: "Saved !!!!");
  }
}
