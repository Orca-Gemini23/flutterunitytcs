import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/bt_constants.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/utils/firebasehelper/firebasedb.dart';
import 'package:walk/src/utils/global_variables.dart';

class AdditionalSettings extends StatefulWidget {
  const AdditionalSettings({super.key});

  @override
  State<AdditionalSettings> createState() => _AdditionalSettingsState();
}

class _AdditionalSettingsState extends State<AdditionalSettings> {
  String _selectedMode = "Open loop";

  @override
  void initState() {
    FirebaseAnalytics.instance
        .logScreenView(screenName: 'Additional Settings Page')
        .then(
          (value) => debugPrint("Analytics stated"),
        );
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
                          if (_selectedMode == "Advanced") {
                            AdvancedMode.modevisiable = true;
                          } else {
                            AdvancedMode.modevisiable = false;
                          }
                        });
                        Analytics.addClicks(
                            _selectedMode, DateTime.timestamp());
                        ////Send Change Mode Command to device
                        log("$MODE $newValue;");

                        _storeMode();
                        await deviceController.sendToDevice(
                            "$MODE $newValue;", WRITECHARACTERISTICS);

                        if (_selectedMode == "Advanced") {
                          await deviceController.sendToDevice(
                              "alx_m 1;", WRITECHARACTERISTICS);
                          await deviceController.sendToDevice(
                              "arx_m 1;", WRITECHARACTERISTICS);
                          await deviceController.sendToDevice(
                              "arx_min: -0.5;", WRITECHARACTERISTICS);
                          await deviceController.sendToDevice(
                              "arx_max: 0.5;", WRITECHARACTERISTICS);
                          await deviceController.sendToDevice(
                              "alx_min: -0.5;", WRITECHARACTERISTICS);
                          await deviceController.sendToDevice(
                              "alx_max: 0.5;", WRITECHARACTERISTICS);
                        }
                      },
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
