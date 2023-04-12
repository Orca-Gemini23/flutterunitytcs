import 'dart:async';
import 'dart:developer';

import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:walk/src/constants/bluetoothconstants.dart';

///Controls the bluetooth device information and manages connection and data flow between the device and application.;
class DeviceController extends ChangeNotifier {
  /// stores scanned devices
  List<BluetoothDevice> _scannedDevices = [];

  /// stores connected devices
  List<BluetoothDevice> _connectedDevices = [];

  /// stores characterisitcs of devices
  List<BluetoothCharacteristic> _characteristics = [];

  /// stores services of devices
  List<BluetoothService> _services = [];

  /// checks whether wifi credentials are saved on or not
  bool _wifiProvisioned = false;

  /// getting scanned devices
  List<BluetoothDevice> get getScannedDevices => _scannedDevices;

  /// getting connected devices
  List<BluetoothDevice> get getConnectedDevices => _connectedDevices;

  ///Created a map of characteristics
  Map<Guid, BluetoothCharacteristic> _characteristicMap = {};

  ///Getter function to get the characteristic map
  Map<Guid, BluetoothCharacteristic> get characteristicMap =>
      _characteristicMap;

  ///
  bool _isListening = false;
  bool get listenStatus => _isListening;

  ///

  Set<String> _info = {};

  /// stores remaining battery value
  int _batteryRemaining = 000;

  /// Stores value for remaining battery
  int get batteryRemaining => _batteryRemaining;

  ///outputs the set<String> which contains the information obtained from the device after sending the "info" command to the device;
  Set<String> get info => _info;

  /// Names for buttons in device controller page
  List<String> buttonNames = ['SOS', 'RES', 'RSTF', 'RPRV'];

  void clearInfo() {
    /// Clears the _info set so that new information can be stored , without older one being present creating ambiguity
    _info.clear();
    notifyListeners();
  }

  /// Getting wifi provision status
  bool get wifiProvisionStatus => _wifiProvisioned;

  /// Status of battery
  bool _batteryInfoStatus = false;

  ///  Gwtting status of battery
  bool get batteryInfoStatus => _batteryInfoStatus;

  /// Stores server[L] battery value
  String _batteryS = "0.01";

  /// Stores client[R] battery value
  String _batteryC = "0.01";

  /// Stores client[R] remaining battery value
  String _rbattC = "0000";

  /// Stores server[L] remaining battery value
  String _rbattS = "0000";

  ///getting the context for dialog box
  BuildContext? homeContext;

  ///Intialising Location library
  Location location = Location();

  /// Battery value for client[R]
  double get battC {
    return double.parse(_batteryC);
  }

  /// Battery value for server[L]
  double get battS {
    return double.parse(_batteryS);
  }

  ///Constructor to start scanning as soon as an object of Device Controller is inititated in the runApp
  DeviceController({bool performScan = true}) {
    if (performScan) {
      startDiscovery();
    }
    checkPrevConnection();
  }

  ///Handles the bluetooth and location permission for both devices, below and above android version 12;
  Future askForPermission() async {
    final ble = FlutterBlue.instance; // initializes the flutter blue package
    if (await Permission.location.isDenied ||
        await Permission.bluetooth.isDenied) {
      await Permission.location.request();
      await Permission.bluetooth.request();
      await Permission.nearbyWifiDevices.request();
      await Permission.bluetoothAdvertise.request();
      await Permission.bluetoothConnect.request();
      await Permission.bluetoothScan.request();
      log("asking for permission complete");
      if (await Permission.bluetooth.isGranted &&
          await Permission.location.isGranted &&
          homeContext != null) {
        turnBluetoothOn(homeContext!);

        await location
            .serviceEnabled(); // check whether the service is enabled or not
      }
    } else if (!await ble.isOn ||
        !await location.serviceEnabled() && homeContext != null) {
      await location.requestService(); // request to on location service
      await BluetoothEnable.enableBluetooth; // enables bluetooth
    }
  }

  /// Turning on Bluetooth from within the app
  Future<void> turnBluetoothOn(BuildContext context) async {
    try {
      String dialogTitle = "Turn on Bluetooth and location?";
      bool displayDialogContent = true;
      String dialogContent =
          "This app requires Bluetooth and Location turned on to connect to a device.";
      String cancelBtnText = "Nope";
      String acceptBtnText = "Sure";
      double dialogRadius = 10.0;
      bool barrierDismissible = true; //

      /// Custom Dialog box for turning On Bluetooth
      await BluetoothEnable.customBluetoothRequest(
              context,
              dialogTitle,
              displayDialogContent,
              dialogContent,
              cancelBtnText,
              acceptBtnText,
              dialogRadius,
              barrierDismissible)
          .then((value) {
        log('customBT request: $value');
      });
    } catch (e) {
      log(' error: $e');
    }
  }

  /// Used to scan the devices and add the scanned devices to the scannedDevices list;
  void startDiscovery() async {
    try {
      await askForPermission();
      _scannedDevices.clear();
      var ble = FlutterBlue.instance;

      ble
          .scan(
        timeout: const Duration(seconds: 10),

        ///timeout can be ignored , to keep the scan running continuosly
        allowDuplicates: false,
      )
          .listen(
        (scanResult) {
          if (scanResult.device.name != "") {
            ///Consider only those devices that have a name that is not empty
            ///TODO:Convert it to scanResult.device.name.contains("walk")
            _scannedDevices.add(scanResult.device);
            notifyListeners();
          }
        },
      ).onError((error) {
        log('startDiscover() error: $error');
      });
    } catch (e) {
      log(e.toString());
    }
  }

  ///Checks already connected devices and highlights the restpective device's tile in the home screen.
  Future checkPrevConnection() async {
    log("check prev called ");
    _connectedDevices = await FlutterBlue.instance.connectedDevices;
    if (_connectedDevices.isNotEmpty) {
      await discoverServices(_connectedDevices[0]);

      ///Discovering the service of the device at index 0 in connectedDevices
    }
    notifyListeners();
  }

  ///Used to connect to a device and update connectedDevices list
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

  ///Handles the disconnection procedure
  Future disconnectDevice(BluetoothDevice device) async {
    try {
      Fluttertoast.showToast(msg: "Disconnecting ");
      await device.disconnect();
      await HapticFeedback.mediumImpact();
      Fluttertoast.showToast(msg: "Disconnected successfully");
      _connectedDevices.remove(device);

      ///Removing the device for the connectedDevices list
      _services.clear();

      ///Clearing the services of the devices
      _characteristics.clear();

      /// Clearing the characteristics obtained from the device
      notifyListeners();
    } catch (e) {
      log("Error in disconnecting ${e.toString()}");
      Fluttertoast.showToast(msg: "Could not disconnect :$e");
    }
  }

  ///Used to discover the services and characteristics;
  ///Also flood services and characteristics into a map
  Future discoverServices(BluetoothDevice device) async {
    try {
      _services = await device.discoverServices();
      _characteristicMap.clear();
      _characteristics = _services
          .where((element) => element.uuid == SERVICE)
          .first
          .characteristics;

      _characteristics.forEach((element) {
        characteristicMap.putIfAbsent(element.uuid, () => element);
        notifyListeners();
      });

      //log(characteristicMap[CHARGERCONN].toString());

      //log(_characteristics.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: "Unexpected error in getting the services$e");
      log(e.toString());
    }
  }

  ///Used to send any message to the device basically command , it is sent in ASCII format
  Future sendToDevice(String command, Guid characteristic) async {
    try {
      if (await FlutterBlue.instance.isOn) {
        ///Checking if the bluetooth is on
        BluetoothCharacteristic? writeTarget =
            _characteristicMap[WRITECHARACTERISTICS];

        ///Searching for the actual characteristic by the GUID of the characteristic known
        var response = await writeTarget!.write(command.codeUnits);

        ///Converting the command to ASCII then sending
        await HapticFeedback.mediumImpact();
        log("Command Sent !!!");
        Fluttertoast.showToast(msg: "Command Sent !! ");
      } else {
        Fluttertoast.showToast(msg: "Seems like bluetooth is turned off ");
      }
    } catch (e) {
      log("error in sending message $e");
      Fluttertoast.showToast(msg: "Unexpected error in sending command $e");
    }
  }

  ///Used to listen to a stream of messages when the user sends INFO command
  Future notifyRead(Guid characteristic, BuildContext context) async {
    try {
      if (await FlutterBlue.instance.isOn) {
        BluetoothCharacteristic charToTarget = _characteristics
            .firstWhere((element) => element.uuid == characteristic);
        clearInfo();

        ///Clear the previous stored info if any
        int count = 0;
        await charToTarget.setNotifyValue(true);
        await charToTarget.write(INFO.codeUnits);

        /// sending the info command

        await for (var value in charToTarget.value) {
          ///waiting for the stream to complete because we have to show a loading dialog to the user till this is completed
          log(String.fromCharCodes(value));

          String information = String.fromCharCodes(value);
          if (information.startsWith("batt")) {
            updateBattValues(information);
          }
          _info.add(information.trim());
          count++;
          if (count == 18) {
            ///We know the length of data we recieve so according to that we end the stream
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

  ///Function used to get battery values
  Future<void> getBatteryVoltageValues() async {
    try {
      BluetoothCharacteristic? clientTarget =
          _characteristicMap[BATTERY_PERCENTAGE_CLIENT];
      BluetoothCharacteristic? serverTarget =
          _characteristicMap[BATTERY_PERCENTAGE_SERVER];

      var clientResponse = await clientTarget!.read();

      ///divided by 1000
      var serverResponse = await serverTarget!.read();
      _batteryC = String.fromCharCodes(clientResponse);
      _batteryS = String.fromCharCodes(serverResponse);
      _batteryInfoStatus = true;
      notifyListeners();
      log("CLIENT BATTERY VOLTAGE is ${String.fromCharCodes(clientResponse)}");
      log("SERVER BATTERY VOLTAGE is ${String.fromCharCodes(serverResponse)}");
    } catch (e) {
      log(e.toString());
      log("Something went wrong while getting batteryValues.");
    }
  }

  ///Function to get the wifiProvisioned Status
  Future<bool> getProvisionedStatus() async {
    try {
      BluetoothCharacteristic? clientTarget =
          _characteristicMap[PROVISIONED_CLIENT];
      BluetoothCharacteristic? serverTarget =
          _characteristicMap[PROVISIONED_SERVER];

      var clientResponse = await clientTarget!.read();
      var serverResponse = await serverTarget!.read();

      if (String.fromCharCodes(clientResponse) == "1" &&
          String.fromCharCodes(serverResponse) == "1") {
        _wifiProvisioned = true;
        notifyListeners();
      } else {
        _wifiProvisioned = false;
        notifyListeners();
      }

      log("Client provisioned status is ${String.fromCharCodes(clientResponse)}");
      log("Server provisioned status is ${String.fromCharCodes(serverResponse)}");
      log("Wifi provisioned ${_wifiProvisioned}");
      return _wifiProvisioned;
    } catch (e) {
      log("${e.toString()}");
      log("Something went wrong while getting wifi provisioned status");
      return _wifiProvisioned;
    }
  }

  ///Updates and gets the battery value from the whole string like "rbatt c 0.100"(The string value might differ) so this will extract the battery value ie 0.100 from the string
  void updateBattValues(String value) {
    if (value.contains("s")) {
      _batteryS = value.substring(6, 11);
      log("batteryS is $_batteryS");
      _batteryInfoStatus = true;
      notifyListeners();
    } else {
      _batteryC = value.substring(6, 11);
      log("batteryC is $_batteryC");
      _batteryInfoStatus = true;
      notifyListeners();
    }
  }

  ///Updates wifi provisioned status (The ble device tells us whether it has user's wifi SSID and Password , if it has then wifi is provisioned else it is not );
  void updateWifiVerificationStatus() {
    if (_info.contains("provisioned s 1") &&
        _info.contains("provisioned c 1")) {
      _wifiProvisioned = true;
      print(_wifiProvisioned.toString() + "tetsing wifi");
      notifyListeners();
    } else {
      _wifiProvisioned = false;
      notifyListeners();
    }
  }
}
