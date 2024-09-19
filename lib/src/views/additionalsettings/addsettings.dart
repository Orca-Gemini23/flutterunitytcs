import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/bt_constants.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/utils/version_number.dart';
// import 'package:walk/src/utils/custom_navigation.dart';
// import 'package:walk/src/views/additionalsettings/update.dart';

class AdditionalSettings extends StatefulWidget {
  const AdditionalSettings({super.key});

  @override
  State<AdditionalSettings> createState() => _AdditionalSettingsState();
}

class _AdditionalSettingsState extends State<AdditionalSettings> {
  String _selectedMode = "Open loop";

  @override
  void initState() {
    super.initState();
    _loadMode();
  }

  void _loadMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedMode = (prefs.getString('mode') ?? 'Open loop');
    });
  }

  void _storeMode() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('mode', _selectedMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: AppColor.blackColor,
        ),
        title: const Text(
          "Additional Settings",
          style: TextStyle(
            color: AppColor.blackColor,
            fontSize: 16,
          ),
        ),
      ),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 15,
          left: 15,
          right: 15,
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColor.lightgreen,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text(
                    "Mode",
                    style: TextStyle(
                      color: AppColor.blackColor,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Consumer<DeviceController>(
                      builder: (context, deviceController, widget) {
                    print("----->$_selectedMode");
                    print(modesDictionary[_selectedMode]);
                       

                    return DropdownButton<String>(
                      value: modesDictionary[_selectedMode],
                      items: modesDictionary.keys.map((String modeName) {
                        return DropdownMenuItem<String>(
                          value: modesDictionary[modeName],
                          child: Text(modeName),
                        );
                      }).toList(),
                      onChanged: (String? newValue) async {
                        log(newValue!);
                        // deviceController.setmodeValue(newValue as int);
                        setState(() {
                          _selectedMode = modesDictionary.keys.firstWhere(
                              (element) =>
                                  modesDictionary[element] == newValue);
                          if(_selectedMode == "Advanced"){          
                            AdvancedMode.modevisiable = true;
                          }
                          else{
                            AdvancedMode.modevisiable = false;
                          }
                        });
                        ////Send Change Mode Command to device
                        log("$MODE $newValue;");

                        _storeMode();
                        await deviceController.sendToDevice(
                            "$MODE $newValue;", WRITECHARACTERISTICS);
                      },
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColor.lightgreen,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 150,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<DeviceController>(
                    builder: (context, deviceController, widget) {
                      return TextButton(
                        onPressed: () async {
                          debugPrint("Tapped");
                          await deviceController.sendToDevice(
                              "$MODE 4;", WRITECHARACTERISTICS);
                          _selectedMode = 'Open loop';
                          _storeMode();
                        },
                        child: const Text(
                          "Reset",
                          style: TextStyle(
                              color: AppColor.blackColor, fontSize: 16),
                        ),
                      );

                      // GestureDetector(
                      //   onTap: () async {
                      //     ////Reset the device
                      //     debugPrint("Tapped");
                      //     await deviceController.sendToDevice(
                      //         "$MODE 4;", WRITECHARACTERISTICS);
                      //     _selectedMode = 'Open loop';
                      //     _storeMode();
                      //   },
                      //   child: const Text(
                      //     "Reset",
                      //     style: TextStyle(
                      //         color: AppColor.blackColor, fontSize: 16),
                      //   ),
                      // );
                    },
                  ),
                  const Divider(
                    thickness: 2,
                    color: AppColor.blackColor,
                  ),
                  Consumer<DeviceController>(
                    builder: (context, deviceController, widget) {
                      return TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Restart",
                          style: TextStyle(
                              color: AppColor.blackColor, fontSize: 16),
                        ),
                      );
                    },
                  ),
                  // const Divider(
                  //   thickness: 2,
                  //   color: AppColor.blackColor,
                  // ),
                  // Consumer<DeviceController>(
                  //   builder: (context, deviceController, widget) {
                  //     return GestureDetector(
                  //       onTap: () {
                  //         Go.to(context: context, push: const DeviceUpdate());
                  //       },
                  //       child: const Text(
                  //         "Check for update",
                  //         style: TextStyle(
                  //             color: AppColor.blackColor, fontSize: 16),
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const UpdateScreen(),
                  ),
                );
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: AppColor.lightgreen,
                      borderRadius: BorderRadius.circular(12.0)),
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                  // height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Update', // "Update" text
                                        style: TextStyle(
                                            color: Colors
                                                .black, // Black color for "Update"
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      TextSpan(
                                        text: ' WALK Band\'\s', // "Band" text
                                        style: TextStyle(
                                            color: AppColor
                                                .greenDarkColor, // Green color for "Band"
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                const Icon(Icons.arrow_forward)
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Keep your device up-to-date & \n enhance your device\'s preformance',
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 124, 124, 124),
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
