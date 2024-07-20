import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/bt_constants.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/views/additionalsettings/update.dart';

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
      _selectedMode = (prefs.getString('mode') ?? 'Novib');
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
                color: AppColor.greyLight,
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
                        setState(() {
                          _selectedMode = modesDictionary.keys.firstWhere(
                              (element) =>
                                  modesDictionary[element] == newValue);
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
                color: AppColor.greyLight,
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
                      return GestureDetector(
                        onTap: () async {
                          ////Reset the device
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
                    },
                  ),
                  const Divider(
                    thickness: 2,
                    color: AppColor.blackColor,
                  ),
                  Consumer<DeviceController>(
                    builder: (context, deviceController, widget) {
                      return GestureDetector(
                        onTap: () {},
                        child: const Text(
                          "Restart",
                          style: TextStyle(
                              color: AppColor.blackColor, fontSize: 16),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    thickness: 2,
                    color: AppColor.blackColor,
                  ),
                  Consumer<DeviceController>(
                    builder: (context, deviceController, widget) {
                      return GestureDetector(
                        onTap: () {
                          Go.to(context: context, push: const DeviceUpdate());
                        },
                        child: const Text(
                          "Check for update",
                          style: TextStyle(
                              color: AppColor.blackColor, fontSize: 16),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
