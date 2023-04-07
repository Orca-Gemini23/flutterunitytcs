import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/utils/screen_context.dart';
import 'package:walk/src/views/homepage.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';

class WifiController extends ChangeNotifier {
  ///This one handles wifi connection and current wifi provisioning status.
  ///If the the wifi is connected successfully then it makes the _isWifiVerified true else false;
  ///According to this status we have to show wifi provisioned logo or icon in the device command page

  /// Initiating WifiScan object
  final wifiScan = WiFiScan.instance;

  /// List of nearby scanned wifi access points
  List<WiFiAccessPoint> scannedResult = [];

  /// Wifi scanning permission checker
  bool wifiScanPermission = false;

  bool _isWifiVerified = false;

  /// Text editing controller for Wifi password
  final TextEditingController passwdController = TextEditingController();

  bool get wifiVerificationStatus => _isWifiVerified;
  void changeWifiVerificationStatus(bool status) {
    _isWifiVerified = status;
    notifyListeners();
  }

  Future<void> wifiScanPermissionDialog(BuildContext context) async {
    try {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        title: 'Scan to search nearby Wifi',
        btnOkOnPress: () {
          wifiScanPermission = true;
          wifiScanner();
        },
        btnCancelOnPress: () {
          Go.back(context: context);
        },
      ).show();
    } catch (e) {
      log('wifiPage permission method error: $e');
    } finally {
      // notifyListeners();
    }
  }

  Future connectToWifi(String ssid, String password) async {
    try {
      // bool result =
      //     await WiFiForIoTPlugin.findAndConnect(ssid, password: password);

      // if (result) {

      //   changeWifiVerificationStatus(true);
      //   return true;
      // } else {
      //   Fluttertoast.showToast(
      //       msg: "Cannot connect to the wifi . Please try again ");
      //   return false;
      // }
    } catch (e) {
      log("Error in connecting to wifi ${e.toString()}");
      Fluttertoast.showToast(
          msg: "Error in connecting to wifi ${e.toString()}");
      return false;
    }
  }

  /// TO scan nearby wifi connections
  Future<void> wifiScanner() async {
    try {
      scannedResult.clear();
      var canStartScan = await wifiScan.canStartScan(askPermissions: true);
      if (canStartScan == CanStartScan.yes) {
        var scanTriggered = await wifiScan.startScan();
        if (scanTriggered) {
          var wifiAccessPoints = await wifiScan.getScannedResults();
          scannedResult = wifiAccessPoints;
        }
      }
    } catch (e) {
      log("Error in scanning nearby wifi ${e.toString()}");
      Fluttertoast.showToast(
          msg: "Error in scanning nearby to wifi ${e.toString()}");
    } finally {
      notifyListeners();
    }
  }

  /// Dialog Box for wifi credentials
  Future<bool> wifiCredDialog(String ssid, BuildContext context) async {
    try {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        btnOk: ElevatedButton(
          onPressed: () {
            _isWifiVerified = true;
            Go.back(context: context);
          },
          child: const Text('Ok'),
        ),
        btnCancel: ElevatedButton(
          onPressed: () {
            _isWifiVerified = false;
            Go.back(context: context);
          },
          child: const Text('Cancel'),
        ),
        body: Column(
          children: [
            Text(
              'Connect to $ssid',
              style: const TextStyle(
                  fontSize: 18,
                  color: AppColor.blackColor,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: passwdController,
              decoration: const InputDecoration(
                labelText: AppString.wifiPassword,
                labelStyle: TextStyle(
                    color: AppColor.greenColor, fontWeight: FontWeight.w600),
                // enabledBorder: OutlineInputBorder(
                //   borderSide: BorderSide(color: AppColor.greenColor),
                // ),
                // focusedBorder: OutlineInputBorder(
                //   borderSide: BorderSide(color: AppColor.greenColor),
                // ),
              ),
            ),
          ],
        ),
      ).show();
      if (_isWifiVerified) {
        return true;
      } else {
        return false;
      }
      // changeWifiVerificationStatus(true);
    } catch (e) {
      log('Wifi Credential Dialog box error: $e');
      return false;
    } finally {}
  }

  @override
  void dispose() {
    passwdController.dispose();
    super.dispose();
  }
}
