import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/shared_preferences.dart';
import 'package:walk/src/db/firebase_storage.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/views/reports/filepath.dart';

class ReportList extends StatefulWidget {
  const ReportList({super.key});

  @override
  State<ReportList> createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  List<FileSystemEntity> _files = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    FilePathChange.getExternalFiles().then((value) async {
      loadFiles().then((_) {
        _filteredItems = List.from(_files);
        _updateList();
        firstLoad = false;
      });
    });
  }

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
      'Authorization':
          'Bearer:eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJBdXRoZW50aWNhdGlvbiIsImlzcyI6ImxpZmVzcGFyay50ZWNoIiwiaWQiOjIzLCJjb3VudHJpZXMiOlsiSW5kaWEiLCJBdXN0cmFsaWEiLCJVU0EiXX0.1FEuK1FhyKIRzlDu_IjrRXd-WL4H6lOs2D88g4rTAdA',
      'name': LocalDB.user!.name,
      'age': LocalDB.user!.age,
      // 'sex': LocalDB.user!.gender,
      'Content-Type': 'multipart/form-data; boundary=$boundary',
    };

    // Sending the request until 200 status
    bool uploaded = false;
    while (!uploaded) {
      var response = await http.post(uri, headers: headers, body: body);
      await Future.delayed(const Duration(seconds: 10)).then((_) {
        if (!uploaded) {
          setState(() {
            isLoading = false;
          });
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
        if (showProgressIndicatorIndex.length == 1) {
          await OpenFile.open(pdfFilePath);
        }
        if (await file.exists()) {
          file.deleteSync();
        }
        setState(() {
          loadFiles().then((_) {
            _filteredItems = List.from(_files);
            _updateList();
            // isLoading = false;
          });
        });
      } else {
        log('Failed to upload file. Status code: ${response.statusCode}');
      }
    }
  }

  Future<List<FileSystemEntity>> getExternalFiles() async {
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
                // print(fileLines.length);
                // print(fileLines[0]);
                var arr = fileLines[0].split(",");
                // print(arr);
                // print(arr[3]);
                if (fileLines.length > 6 && arr.last == "SessionID") {
                  gameFiles.add(file);
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
    gameFiles = gameFiles.reversed.toList();

    setState(() {
      _files = gameFiles;
    });
  }

  List<dynamic> renameFile(String fileName) {
    fileName = fileName.split('-')[1];
    if (fileName.startsWith("b")) {
      var timestamp = fileName.substring(4, 17);
      DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
      fileName = "ball game session $date";
      return ["Ball game session", date, "Ball"];
    } else if (fileName.startsWith("s")) {
      var timestamp = fileName.substring(5, 18);
      DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
      fileName = "swing game session $date";
      return ["Swing game session", date, "Swing"];
    } else if (fileName.startsWith("f")) {
      var timestamp = fileName.substring(4, 17);
      DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
      fileName = "fish game session $date";
      return ["Fish game session", date, "Fish"];
    }

    return [];
  }

  String _sortOption = 'Ascending';
  bool isFilter = false;
  bool isSort = false;
  Color tileColor = Colors.red;
  int currIndex = -1;
  late List<FileSystemEntity> _filteredItems;
  DateTime? selectedDate;
  bool firstLoad = true;
  List<int> showProgressIndicatorIndex = [];

  void _updateList() {
    setState(() {
      // Sort the list based on the selected option
      if (_sortOption == 'Descending') {
        _filteredItems.sort((a, b) => renameFile(a.path.split('/').last)[1]
            .toString()
            .toLowerCase()
            .compareTo(renameFile(b.path.split('/').last)[1]
                .toString()
                .toLowerCase()));
      } else if (_sortOption == 'Ascending') {
        _filteredItems.sort((a, b) => renameFile(b.path.split('/').last)[1]
            .toString()
            .toLowerCase()
            .compareTo(renameFile(a.path.split('/').last)[1]
                .toString()
                .toLowerCase()));
      } else {
        _filteredItems = _files
            .where((item) =>
                renameFile(item.path.split('/').last)[1]
                    .toString()
                    .substring(0, 10)
                    .toLowerCase() ==
                (selectedDate.toString().substring(0, 10).toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme:
                ColorScheme.fromSeed(seedColor: AppColor.greenDarkColor),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        log(selectedDate.toString());
        _sortOption = 'search';
        isFilter = true;
        _updateList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColor.whiteColor,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColor.whiteColor,
          ),
          onPressed: (() {
            Navigator.pop(context);
          }),
        ),
        title: const Text(
          "Reports",
          style: TextStyle(
            color: AppColor.whiteColor,
          ),
        ),
        centerTitle: false,
        backgroundColor: AppColor.greenDarkColor,
        elevation: 0,
      ),
      body: firstLoad
          ? const Center(
              child: CircularProgressIndicator(color: AppColor.greenDarkColor))
          : _files.isEmpty
              ? const Center(child: Text("Not enough data to generate reports"))
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _selectDate(context);
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColor.greenDarkColor,
                            side: const BorderSide(
                              color: AppColor.greenDarkColor,
                              width: 1,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Text("Filter"),
                              SizedBox(width: 10),
                              Icon(Icons.filter_list_sharp)
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () {
                            showMenu(
                              context: context,
                              position:
                                  const RelativeRect.fromLTRB(1000, 80, 0, 0),
                              items: [
                                const PopupMenuItem<String>(
                                  value: 'Ascending',
                                  child: Text('Latest'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'Descending',
                                  child: Text('Older'),
                                ),
                              ],
                            ).then((value) async {
                              setState(() {
                                _sortOption =
                                    value ?? ''; // Default value if null
                                _sortOption == "Descending"
                                    ? isSort = true
                                    : isSort = false;
                                _updateList();
                              });
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColor.greenDarkColor,
                            backgroundColor:
                                isSort ? const Color(0x40005748) : Colors.white,
                            side: const BorderSide(
                              color: AppColor.greenDarkColor,
                              width: 1,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                "Sort",
                                style: TextStyle(
                                    color: AppColor.greenDarkColor,
                                    fontFamily: "Helvetica"),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.swap_vert_sharp,
                                  color: AppColor.greenDarkColor),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    Visibility(
                      visible: isFilter,
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 1, horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors
                                      .grey), // Adding border to mimic an OutlinedButton
                              borderRadius:
                                  BorderRadius.circular(5), // Rounded corners
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(selectedDate != null
                                    ? selectedDate.toString().substring(0, 10)
                                    : ""),
                                const SizedBox(width: 20),
                                // Icon(Icons.cancel_outlined),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _filteredItems = _files;
                                      _sortOption = "";
                                      isFilter = false;
                                    });
                                  },
                                  child: const Text(
                                    "X",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  // child: Icon(Icons.cancel_outlined),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _filteredItems.isEmpty
                        ? const Center(child: Text("No data"))
                        : Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              // physics: NeverScrollableScrollPhysics(),
                              itemCount: _filteredItems.length,
                              itemBuilder: (context, index) {
                                // Helper function to compare if two dates are the same (ignoring time)
                                bool isSameDate(
                                    DateTime date1, DateTime date2) {
                                  return date1.year == date2.year &&
                                      date1.month == date2.month &&
                                      date1.day == date2.day;
                                }

                                FileSystemEntity file = _filteredItems[index];

                                List<dynamic> result =
                                    renameFile(file.path.split('/').last);

                                String title = result[0];
                                var subTitle = result[1];
                                String game = result[2];

                                bool showDateHeader = true;

                                // Check if the current item has the same date as the previous item
                                if (index > 0 &&
                                    isSameDate(
                                        renameFile(
                                            file.path.split('/').last)[1],
                                        renameFile(_filteredItems[index - 1]
                                            .path
                                            .split('/')
                                            .last)[1])) {
                                  showDateHeader = false;
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (showDateHeader) // Show the date header only once per date
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 32),
                                        child: Text(
                                          DateFormat('dd-MM-yyyy')
                                              .format(subTitle)
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Helvetica"),
                                        ),
                                      ),
                                    ListTile(
                                      title: Text(title,
                                          style: const TextStyle(
                                              fontFamily: "Helvetica")),
                                      subtitle: Text(
                                          subTitle.toString().substring(0, 19),
                                          style: const TextStyle(
                                              fontFamily: "Helvetica")),
                                      leading: const Icon(
                                        Icons.picture_as_pdf,
                                        size: 40,
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          (file.path.endsWith('.csv'))
                                              ? (isLoading &&
                                                      showProgressIndicatorIndex
                                                          .contains(index))
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: LoadingAnimationWidget
                                                          .inkDrop(
                                                              color: AppColor
                                                                  .greenDarkColor,
                                                              size: 20),
                                                    )
                                                  : IconButton(
                                                      onPressed: () async {
                                                        // if (!isLoading) {
                                                        setState(() {
                                                          isLoading = true;
                                                          if (!showProgressIndicatorIndex
                                                              .contains(
                                                                  index)) {
                                                            showProgressIndicatorIndex
                                                                .add(
                                                                    index); // Select if not already selected
                                                          }
                                                        });
                                                        await reportGeneration(
                                                            file.path, game);
                                                      },
                                                      icon: const Icon(
                                                          Icons.download),
                                                    )
                                              : (file.path.endsWith('.pdf'))
                                                  ? IconButton(
                                                      onPressed: () {
                                                        Share.shareXFiles(
                                                          [XFile(file.path)],
                                                        );
                                                      },
                                                      icon: const Icon(
                                                          Icons.share))
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: LoadingAnimationWidget
                                                          .inkDrop(
                                                              color: AppColor
                                                                  .greenDarkColor,
                                                              size: 20),
                                                    ),
                                          IconButton(
                                            onPressed: () async {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Delete File'),
                                                      content: const Text(
                                                          'Are you sure you want to delete the file?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () async {
                                                            setState(() {
                                                              currIndex = index;
                                                            });
                                                            file.delete().then(
                                                                (onValue) {
                                                              setState(() {
                                                                _files.removeAt(
                                                                    index);
                                                                _filteredItems
                                                                    .removeAt(
                                                                        index);
                                                                currIndex = -1;
                                                              });
                                                            });
                                                            Go.back(
                                                                context:
                                                                    context);
                                                          },
                                                          child: const Text(
                                                              'Yes',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black)),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Closes the dialog without action
                                                          },
                                                          child: const Text(
                                                              'No',
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xFF005749),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                            icon: const Icon(Icons.delete),
                                          ),
                                        ],
                                      ),
                                      onTap: () async {
                                        if (file.path.endsWith('.pdf')) {
                                          await OpenFile.open(file.path);
                                        } else {
                                          null;
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                  ],
                ),
    );
  }
}
