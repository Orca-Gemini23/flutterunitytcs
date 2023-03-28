import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:walk/constants.dart';

class DeviceController extends ChangeNotifier {
  List<BluetoothDevice> _scannedDevices = [];
  List<BluetoothDevice> _connectedDevices = [];
  List<BluetoothCharacteristic> _characteristics = [];
  List<BluetoothService> _services = [];

  bool _wifiProvisioned = false;
  List<BluetoothDevice> get getScannedDevices => _scannedDevices;
  List<BluetoothDevice> get getConnectedDevices => _connectedDevices;
  Set<String> _info = {};
  int _batteryRemaining = 000;

  int get batteryRemaining => _batteryRemaining;

  Set<String> get info => _info;
  void clearInfo() {
    _info.clear();
    notifyListeners();
  }

  bool get wifiProvisionStatus => _wifiProvisioned;
  bool _batteryInfoStatus = false;
  bool get batteryInfoStatus => _batteryInfoStatus;
  String _batteryS = "0.01";
  String _batteryC = "0.01";
  String _rbattC = "0000";
  String _rbattS = "0000";

  double get battC {
    return double.parse(_batteryC) * 100;
  }

  double get battS {
    return double.parse(_batteryS) * 100;
  }

  DeviceController({bool performScan = true}) {
    if (performScan) {
      startDiscovery();
    }
    checkPrevConnection();
  }

  Future askForPermission() async {
    if (await Permission.location.isDenied) {
      await Permission.location.request();
      await Permission.bluetooth.request();
      await Permission.nearbyWifiDevices.request();
      await Permission.bluetoothAdvertise.request();
      await Permission.bluetoothConnect.request();
      await Permission.bluetoothScan.request();
      log("asking for permission complete");
    }
  }

  void startDiscovery() async {
    try {
      await askForPermission();
      _scannedDevices.clear();
      var ble = FlutterBlue.instance;

      ble
          .scan(
        timeout: const Duration(seconds: 10),
        allowDuplicates: false,
      )
          .listen(
        (scanResult) {
          print("Scanned device");
          if (scanResult.device.name != "") {
            // convert it to scanResult.device.name.contains("walk")
            _scannedDevices.add(scanResult.device);
            notifyListeners();
          }
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future checkPrevConnection() async {
    log("check prev called ");
    _connectedDevices = await FlutterBlue.instance.connectedDevices;
    if (_connectedDevices.isNotEmpty) {
      await discoverServices(_connectedDevices[0]);
    }
    notifyListeners();
  }

  Future connectToDevice(BluetoothDevice device) async {
    try {
      log("coming here");
      Fluttertoast.showToast(msg: "Connecting to ${device.name}");
      await device.connect();
      await HapticFeedback.vibrate();

      Fluttertoast.showToast(msg: "Connected to ${device.name}");
      await discoverServices(device);
      _connectedDevices.clear;
      _connectedDevices.add(device);
      notifyListeners();
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Could not connect :$e");
      device.disconnect();
      _connectedDevices.clear();
      notifyListeners();
    }
  }

  Future disconnectDevice(BluetoothDevice device) async {
    try {
      Fluttertoast.showToast(msg: "Disconnecting ");
      await device.disconnect();
      await HapticFeedback.mediumImpact();
      Fluttertoast.showToast(msg: "Disconnected successfully");
      _connectedDevices.remove(device);
      _services.clear();
      _characteristics.clear();
      notifyListeners();
    } catch (e) {
      log("Error in disconnecting ${e.toString()}");
      Fluttertoast.showToast(msg: "Could not disconnect :$e");
    }
  }

  Future discoverServices(BluetoothDevice device) async {
    try {
      _services = await device.discoverServices();
      _characteristics = _services
          .where((element) => element.uuid == SERVICE)
          .first
          .characteristics;
      log(_characteristics.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: "Unexpected error in getting the services$e");
      log(e.toString());
    }
  }

  Future sendToDevice(String command, Guid characteristic) async {
    try {
      if (await FlutterBlue.instance.isOn) {
        BluetoothCharacteristic charToTarget = _characteristics
            .firstWhere((element) => element.uuid == characteristic);
        var response = await charToTarget.write(command.codeUnits);
        await HapticFeedback.mediumImpact();

        Fluttertoast.showToast(msg: "Command Sent !! ");
      } else {
        Fluttertoast.showToast(msg: "Seems like bluetooth is turned off ");
      }
    } catch (e) {
      log("error in sending message $e");
      Fluttertoast.showToast(msg: "Unexpected error in sending command $e");
    }
  }

  Future notifyRead(Guid characteristic, BuildContext context) async {
    try {
      if (await FlutterBlue.instance.isOn) {
        BluetoothCharacteristic charToTarget = _characteristics
            .firstWhere((element) => element.uuid == characteristic);
        clearInfo();
        int count = 0;
        await charToTarget.setNotifyValue(true);
        await charToTarget.write(INFO.codeUnits);

        await for (var value in charToTarget.value) {
          log(String.fromCharCodes(value));

          String information = String.fromCharCodes(value);
          if (information.startsWith("batt")) {
            updateBattValues(information);
          }
          _info.add(information.trim());
          count++;
          if (count == 18) {
            updateWifiVerificationStatus();
            break;
          }
        }
      } else {
        Fluttertoast.showToast(msg: "Seems like your Bluetooth is turned off");
      }
    } catch (e) {
      log("Some error occurred in retrieving info ${e.toString()}");
      Fluttertoast.showToast(
          msg: "Some error occurred in retrieving info ${e.toString()}");
    }
  }

  void updateBattValues(String value) {
    if (value.contains("s")) {
      _batteryS = value.substring(6, 11);
      log("batteryS is ${_batteryS}");
      _batteryInfoStatus = true;
      // _rbattS = value.substring(value.lastIndexOf("s") + 1, value.length);
      // log("_rBattS is ${_rbattS}");
      notifyListeners();
    } else {
      _batteryC = value.substring(6, 11);
      log("batteryC is ${_batteryC}");
      _batteryInfoStatus = true;
      notifyListeners();
    }
  }

  void updateWifiVerificationStatus() {
    if (_info.contains("provisioned s 1;") &&
        _info.contains("provisioned c 1;")) {
      _wifiProvisioned = true;
      notifyListeners();
    } else {
      _wifiProvisioned = false;
      notifyListeners();
    }
  }
}
