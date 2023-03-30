import 'dart:developer';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wifi_iot/wifi_iot.dart';

class WifiController extends ChangeNotifier {
  ///This one handles wifi connection and current wifi provisioning status.
  ///If the the wifi is connected successfully then it makes the _isWifiVerified true else false;
  ///According to this status we have to show wifi provisioned logo or icon in the device command page
  bool _isWifiVerified = false;
  bool get wifiVerificationStatus => _isWifiVerified;
  void changeWifiVerificationStatus(bool status) {
    _isWifiVerified = status;
    notifyListeners();
  }

  Future connectToWifi(String ssid, String password) async {
    try {
      bool result =
          await WiFiForIoTPlugin.findAndConnect(ssid, password: password);

      if (result) {
        changeWifiVerificationStatus(true);
        return true;
      } else {
        Fluttertoast.showToast(
            msg: "Cannot connect to the wifi . Please try again ");
        return false;
      }
    } catch (e) {
      log("Error in connecting to wifi ${e.toString()}");
      Fluttertoast.showToast(
          msg: "Error in connecting to wifi ${e.toString()}");
      return false;
    }
  }
}
