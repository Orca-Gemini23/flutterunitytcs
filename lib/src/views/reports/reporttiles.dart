import 'dart:io';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/server/upload.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/utils/global_variables.dart';

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
    loadFiles().then((_) {
      _filteredItems = List.from(_files);
      _updateList();
      firstLoad = false;
    });
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
        var fileName = file.path.split('/').last;
        if (fileName.contains("-")) {
          if (fileName.contains("ball") ||
              fileName.contains("swing") ||
              fileName.contains("fish")) {
            String uid = fileName.split('-')[0];
            if (uid == FirebaseAuth.instance.currentUser!.uid) {
              if (file.path.endsWith('.csv')) {
                var fileLines = await file.readAsLines();
                if (fileLines.length > 6 &&
                    fileLines[0].split(",").last == "SessionID") {
                  // gameFiles.add(file);
                } else {
                  // file.delete();
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
  List<DateTime> selectedDates = [];
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
        _filteredItems = _files.where((item) {
          final itemDate = DateTime.parse(
              renameFile(item.path.split('/').last)[1]
                  .toString()
                  .substring(0, 10));
          return selectedDates.any((date) =>
              date.toString().substring(0, 10) ==
              itemDate.toString().substring(0, 10));
        }).toList();
      }
    });
  }

  Future<void> _selectMultipleDates(BuildContext context) async {
    final DateTimeRange? pickedDate = await showDateRangePicker(
      context: context,
      // initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: Theme(
              data: ThemeData.light().copyWith(
                dialogTheme: DialogTheme(
                  // backgroundColor: AppColor.greenColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                colorScheme:
                    ColorScheme.fromSeed(seedColor: AppColor.greenDarkColor),
              ),
              child: child!,
            ),
          ),
        );
      },
    );
    List<DateTime> dates = [];
    DateTime currentDate = pickedDate!.start;

    while (currentDate.isBefore(pickedDate.end) ||
        currentDate.isAtSameMomentAs(pickedDate.end)) {
      dates.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }
    for (var date in dates) {
      if (!selectedDates.contains(date)) {
        setState(() {
          selectedDates.add(date);
          log(selectedDates.toString());
          _sortOption = 'search';
          isFilter = true;
          _updateList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var uploadData = Provider.of<Report>(context);
    if (uploadData.loaded) {
      loadFiles().then((_) {
        _filteredItems = List.from(_files);
        _updateList();
        firstLoad = false;
      });
    }
    // log("Report Page: ${uploadData.loaded.toString()}");
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
                              // _selectDate(context);
                              _selectMultipleDates(context);
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
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: [
                          ...selectedDates.map((date) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    date.toString().substring(0, 10),
                                  ),
                                  const SizedBox(width: 20),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        if (selectedDates.length == 1) {
                                          _filteredItems = _files;
                                          _sortOption = "";
                                          isFilter = false;
                                          selectedDates.clear();
                                        } else {
                                          selectedDates.remove(date);
                                          _updateList();
                                        }
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      backgroundColor: Colors.transparent,
                                    ),
                                    child: const Text(
                                      "X",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                backgroundColor: Colors.transparent,
                              ),
                              onPressed: () {
                                setState(() {
                                  _filteredItems = _files;
                                  _sortOption = "";
                                  isFilter = false;
                                  selectedDates.clear();
                                });
                              },
                              child: const Text("Clear All"),
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
                                // String game = result[2];

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
                                                                .add(index);
                                                          }
                                                        });
                                                        // await reportGeneration(
                                                        //     file.path, game);
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
                                                      contentPadding: DeviceSize
                                                              .isTablet
                                                          ? const EdgeInsets
                                                              .fromLTRB(
                                                              48, 40, 48, 48)
                                                          : null,
                                                      title: Text(
                                                        'Delete File',
                                                        style: TextStyle(
                                                            fontSize: DeviceSize
                                                                    .isTablet
                                                                ? 40
                                                                : null),
                                                      ),
                                                      content: Text(
                                                        'Are you sure you want to delete the file?',
                                                        style: TextStyle(
                                                            fontSize: DeviceSize
                                                                    .isTablet
                                                                ? 24
                                                                : null),
                                                      ),
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
                                                          child: Text('Yes',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: DeviceSize
                                                                        .isTablet
                                                                    ? 24
                                                                    : null,
                                                              )),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Closes the dialog without action
                                                          },
                                                          child: Text(
                                                            'No',
                                                            style: TextStyle(
                                                              color: const Color(
                                                                  0xFF005749),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: DeviceSize
                                                                      .isTablet
                                                                  ? 24
                                                                  : null,
                                                            ),
                                                          ),
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
                                        // if (file.path.endsWith('.pdf')) {
                                        await OpenFile.open(file.path);
                                        // } else {
                                        //   null;
                                        // }
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                  ],
                ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // FilePathChange.getExternalFiles().then((value) async {
      //     loadFiles().then((_) {
      //       _filteredItems = List.from(_files);
      //       _updateList();
      //       firstLoad = false;
      //     });
      //   },
      //   backgroundColor: AppColor.greenDarkColor,
      //   child: const Icon(Icons.refresh),
      // ),
    );
  }
}
