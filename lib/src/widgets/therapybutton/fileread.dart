import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/device_controller.dart';

// class StreamFileChanger extends StatefulWidget {
//   const StreamFileChanger({super.key});

//   @override
//   State<StreamFileChanger> createState() => _StreamFileChangerState();
// }

// class _StreamFileChangerState extends State<StreamFileChanger> {
//   int _currentIndex = 0; // To keep track of the selected bottom nav item
//   List<Widget> _pages = []; // Pages for the bottom nav items

//   @override
//   void initState() {
//     super.initState();
//     DoStream.yes = false;
//     DeviceController deviceController =
//         Provider.of<DeviceController>(context, listen: false);
//     deviceController.startStream();
//     _pages = [
//       const StreamingStringScreen(), // First tab - StreamBuilder page
//       const AnglesDisplay(), // Second tab - Placeholder page for demonstration
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_currentIndex], // Display the selected page
//       // bottomNavigationBar: BottomNavigationBar(
//       //   selectedItemColor: AppColor.greenDarkColor,
//       //   currentIndex: _currentIndex,
//       //   onTap: (index) {
//       //     setState(() {
//       //       _currentIndex = index; // Update the index on tab click
//       //     });
//       //   },
//       //   items: const [
//       //     BottomNavigationBarItem(
//       //       icon: Icon(Icons.list),
//       //       label: 'Stream',
//       //     ),
//       //     BottomNavigationBarItem(
//       //       icon: Icon(Icons.info),
//       //       label: 'Files',
//       //     ),
//       //   ],
//       // ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppColor.greenDarkColor,
//         child: Text(DoStream.yes ? "Stop" : "Start"),
//         onPressed: () async {
//           if (DoStream.yes) {
//             await OpenFile.open(
//                 "/storage/emulated/0/Android/data/com.lifesparktech.walk/files/data.csv");
//           }
//           setState(() {
//             DoStream.yes = !DoStream.yes;
//           });
//         },
//       ),
//     );
//   }
// }

class StreamingStringScreen extends StatefulWidget {
  const StreamingStringScreen({super.key});

  @override
  State<StreamingStringScreen> createState() => _StreamingStringScreenState();
}

class _StreamingStringScreenState extends State<StreamingStringScreen> {
  final List<String> _messages = []; // List to hold all emitted messages
  late StreamController<String> _streamController;
  late ScrollController _scrollController; // Controller for the ListView

  // late File file;
  // String s = '';
  // List<dynamic> l = [];

  @override
  void initState() {
    _streamController = StreamControllerClass._streamController;
    super.initState();
    DoStream.yes = false;
    DeviceController deviceController =
        Provider.of<DeviceController>(context, listen: false);
    FileClass.initializeCommonName().then((_) {
      deviceController.startStream();
      _scrollController = ScrollController();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the ScrollController
    super.dispose();
  }

  // Future<void> getFileName() async {
  //   Directory? directory;
  //   if (Platform.isAndroid) {
  //     directory = await getExternalStorageDirectory();
  //   } else {
  //     directory = await getApplicationDocumentsDirectory();
  //   }

  //   String filePath = '${directory?.path}/data.csv';
  //   file = File(filePath);
  // }

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
      body: StreamBuilder<String>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          // if (DoStream.yes) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('Start stream for values'));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            _messages.add(snapshot.data!);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollController
                  .jumpTo(_scrollController.position.maxScrollExtent);
            });

            return ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${DateTime.now().toString().split(" ").last} : ${_messages[index]}",
                    style: const TextStyle(fontFamily: "Helvetica"),
                  ),
                );
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.greenDarkColor,
        child: Text(DoStream.yes ? "Stop" : "Start"),
        onPressed: () async {
          if (DoStream.yes) {
            setState(() {
              DoStream.yes = !DoStream.yes;
            });
            await OpenFile.open(FileClass.name);
            setState(() {
              FileClass.name = FileClass.commonName;
            });
          } else {
            setState(() {
              _messages.clear();
              FileClass.name +=
                  "${DateTime.now().millisecondsSinceEpoch.toString()}.csv";
              setState(() {
                DoStream.yes = !DoStream.yes;
              });
            });
          }
        },
      ),
      // : const Center(child: Text("Please start the stream")),
    );
  }
}

class StreamControllerClass {
  static final StreamController<String> _streamController =
      StreamController<String>.broadcast();
  static void fun(String data) {
    _streamController.add(data);
  }
}

class DoStream {
  static bool yes = false;
}

class FileClass {
  static Future<String> getFileName() async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    return '${directory?.path}/data';
  }

  static Future<void> initializeCommonName() async {
    commonName = await getFileName();
    name = commonName;
  }

  static String commonName = "";
  static String name = "";
}
