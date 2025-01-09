// ignore_for_file: prefer_final_fields, avoid_print
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:walk/src/constants/bt_constants.dart';
import 'package:walk/src/utils/global_variables.dart';
import 'package:walk/src/widgets/therapybutton/fileread.dart';

import '../views/unity.dart';
import '../widgets/scanningpage/notfounddialog.dart';

class DeviceController extends ChangeNotifier {
  /// stores scanned devices
  List<BluetoothDevice> _scannedDevices = [];

  bool isBluetoothOn = false;

  /// stores connected devices
  List<BluetoothDevice> _connectedDevices = [];

  BluetoothDevice? _connectedDevice;

  BluetoothDevice? get connectedDevice => _connectedDevice;

  void clearConnectedDevice() {
    _connectedDevice = null;
    notifyListeners();
  }

  void updateConnectedDevice(BluetoothDevice device) {
    _connectedDevice = device;
    notifyListeners();
  }

  ////Angle Values for Animation Rotation
  double leftAngleValue = 0;
  double rightAngleValue = 0;

  /// stores characterisitcs of devices
  List<BluetoothCharacteristic> _characteristics = [];

  /// stores services of devices
  List<BluetoothService> _services = [];

  bool isConnecting = false;

  /// checks whether wifi credentials are saved on or not
  int _wifiProvisioned = 0;

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

  Set<String> _info = {};

  /// Stores value for remaining battery
  int get clientBatteryRemaining {
    double seconds = double.parse(_rbattC);
    double minutes = seconds / 60;
    return minutes.floor();
  }

  int get serverBatteryRemaining {
    double seconds = double.parse(_rbattS);
    double minutes = seconds / 60;
    return minutes.floor();
  }

  ///outputs the set<String> which contains the information obtained from the device after sending the "info" command to the device;
  Set<String> get info => _info;

  /// Names for buttons in device controller page
  List<String> buttonNames = ['SOS', 'RES', 'RSTF', 'RPRV'];

  void clearInfo() {
    /// Clears the _info set so that new information can be stored , without older one being present creating ambiguity
    _info.clear();
    notifyListeners();
  }

  bool isScanning = false;
  bool get scanStatus => isScanning;
  void changeScanStatus(bool status) {
    isScanning = status;
    notifyListeners();
  }

  double _freqValue = 0.3;
  int _modeValue = -1;
  double _magSValue = 0;
  double _magCValue = 0;

  double get frequencyValue {
    return _freqValue;
  }

  int get modeValue {
    return _modeValue;
  }

  double get magSValue {
    return _magSValue;
  }

  double get magCValue {
    return _magCValue;
  }

  void setmodeValue(int value) {
    _modeValue = value;
    notifyListeners();
  }

  void setmagSValue(double value) {
    _magSValue = value;
    notifyListeners();
  }

  void setmagCValue(double value) {
    _magCValue = value;
    notifyListeners();
  }

  void setfreqValue(double value) {
    _freqValue = value;
    notifyListeners();
  }

  /// Getting wifi provision status
  int get wifiProvisionStatus => _wifiProvisioned;

  int _clientStatus = 0;

  int get clientStatus => _clientStatus;

  /// Status of battery
  bool _batteryInfoStatus = false;

  ///  Getting status of battery
  bool get batteryInfoStatus => _batteryInfoStatus;

  /// Stores server[L] battery value
  String _batteryS = "1.0";

  /// Stores client[R] battery value
  String _batteryC = "1.0";

  /// Stores client[R] remaining battery value
  String _rbattC = "0000";

  /// Stores server[L] remaining battery value
  String _rbattS = "0000";

  ///getting the context for dialog box
  BuildContext? homeContext;

  ///Intialising Location library
  loc.Location location = loc.Location();

  /// Battery value for client[R]
  double get battC {

    return double.tryParse(_batteryC) ?? 0.0;
  }

  /// Battery value for server[L]
  double get battS {
    return double.parse(_batteryS);
  }

  /// tells whether client is connect to server or not
  bool isClientConnected = false;

  /// client connection to server
  bool get bandC {
    return isClientConnected;
  }

  bool permissionRequested = false;
  bool get permissionRequestStatus => permissionRequested;

  // //Constructor to start scanning as soon as an object of Device Controller is inititated in the runApp
  DeviceController(
      {bool performScan = false, bool checkPrevconnection = false}) {
    if (!permissionRequested) {
      askForPermission();
    }

    if (checkPrevconnection) {
      checkPrevConnection();
    }
  }

  ///Handles the bluetooth and location permission for both devices, below and above android version 12;
  Future askForPermission() async {
    try {
      // Check if permissions are already granted
      final locationStatus = await Permission.location.isGranted;
      final bluetoothStatus = await Permission.bluetooth.isGranted;

      if (locationStatus && bluetoothStatus) {
      } else {
        if (!locationStatus) {
          await Permission.location.request();
        }
        if (!bluetoothStatus) {
          await Permission.bluetooth.request();
        }
        final locationStatusAfterRequest = await Permission.location.status;
        final bluetoothStatusAfterRequest = await Permission.bluetooth.status;

        if (locationStatusAfterRequest.isGranted &&
            bluetoothStatusAfterRequest.isGranted) {
          return;
        } else {
          await Permission.location.request();
          await Permission.bluetooth.request();
          // print("Permissions were not granted.");
        }
      }
      return;
    } catch (e) {
      print("Error: $e");
    }
  }

  ////Handles the bluetoothAdapaterStatus and turns it on;
  Future checkBluetoothAdapterState(BuildContext? context) async {
    try {
      log("Checking the Adapter state ");
      BluetoothAdapterState currentState =
          await FlutterBluePlus.adapterState.first;
      if (currentState != BluetoothAdapterState.on && context != null) {
        log("Turning on Bluetooth!!");
        await FlutterBluePlus.turnOn();
      }
    } catch (e) {
      print("Error in checkingBluetoothAdapterState ${e.toString}");
      Fluttertoast.showToast(
        msg:
            "Unable to turn on the bluetooth,please turn on bluetooth manually",
      );
      return false;
    }
    return true;
  }

  Future<Position> checkLocationPremission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();
    if (!serviceEnabled) {
      // do what you want
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // toast('Please location permission');
        // logger.w("get User LocationPosition()");
        await Geolocator.openAppSettings();

        // throw '${language.lblLocationPermissionDenied}';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw "language lbl Location Permission Denied Permanently, please enable it from setting";
    }

    return await Geolocator.getCurrentPosition().then((value) {
      return value;
    }).catchError((e) async {
      return await Geolocator.getLastKnownPosition().then((value) async {
        if (value != null) {
          return value;
        } else {
          throw "lbl Enable Location";
        }
      }).catchError((e) {
        // toast(e.toString());
        return Position(
          latitude: 0.0,
          longitude: 0.0,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0,
        );
      });
    });
  }

  /// Turning on Bluetooth from within the app
  Future<void> turnBluetoothOn(BuildContext context) async {
    try {
      // // Custom Dialog box for turning On Bluetooth
    } catch (e) {
      log(' error: $e');
    }
  }

  List<BluetoothDevice> _scannedDeviceNames = [];
  //// Used to scan the devices and add the scanned devices to the scannedDevices list;
  Future<void> startDiscovery(Function onConnect, BuildContext context) async {
    try {
      // ignore: unused_local_variable
      FlutterBluePlus.setLogLevel(LogLevel.none);
      StreamSubscription<List<ScanResult>>? scanSubscription;
      await askForPermission();
      _scannedDevices.clear();
      _scannedDeviceNames.clear();
      isConnecting =
          false; ////Reset the connecting flag so that when the scan results come up they can be connected to if needed

      isScanning = true;
      notifyListeners();
      Timer? scanTimer;

      scanSubscription = FlutterBluePlus.scanResults.listen(
        (event) async {
          log("Scan Result is $event ");
          if (event.isNotEmpty) {
            for (var element in event) {
              // if (element.device.platformName == "Test24022") {
              // print('this is element devices: $element');
              BluetoothDevice deviceName = element.device;
              if (!_scannedDeviceNames.contains(deviceName)) {
                _scannedDeviceNames.add(element.device);
              }
              print('this is _scannedDeviceNames $_scannedDeviceNames');
            }
          }
        },
        onDone: () {
          log("Scanning Done");
          isScanning = false;
          scanSubscription!.cancel();
          notifyListeners();
        },
      );

      await FlutterBluePlus.startScan(
        // withNames: ["14022024TEST"],
        withServices: [Guid("0000acf0-0000-1000-8000-00805f9b34fb")],
        androidUsesFineLocation: true,
      );
      void onDeviceSelected(BluetoothDevice deviceName) async {
        BluetoothDevice scannedDevice = deviceName;
        scanTimer?.cancel();
        FlutterBluePlus.stopScan();
        scanSubscription!.cancel();
        await connectToDevice(scannedDevice, onConnect);
      }

      scanTimer = Timer(const Duration(seconds: 10), () async {
        await FlutterBluePlus.stopScan();
        isScanning = false;
        isConnecting = false;
        scanSubscription!.cancel();
        if (context.mounted) {
          if (_scannedDeviceNames.isNotEmpty) {
            showScannedDevicesDialog(
                context, _scannedDeviceNames, onDeviceSelected);
          } else {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => deviceNotFoundDialog(),
            );
          }
        }
        notifyListeners();
      });

      log("Coming here");
    } catch (e) {
      log("Error in startDiscovery $e");
    }
  }

  void showScannedDevicesDialog(
      BuildContext context,
      List<BluetoothDevice> deviceNames,
      Function(BluetoothDevice) onDeviceSelected) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Scanned Devices',
            style: TextStyle(fontSize: DeviceSize.isTablet ? 40 : null),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: deviceNames.length,
              itemBuilder: (BuildContext context, int index) {
                if (deviceNames.isEmpty) {
                } else if (deviceNames.length == 1) {
                  onDeviceSelected(deviceNames[index]);
                  Device.name = deviceNames[index].platformName;
                  Navigator.of(context).pop();
                } else {
                  String deviceName = deviceNames[index].platformName;
                  return ListTile(
                    title: Text(
                      "WALK (${deviceName.substring(deviceName.length - 3, deviceName.length)})",
                      style:
                          TextStyle(fontSize: DeviceSize.isTablet ? 28 : null),
                    ),
                    onTap: () {
                      onDeviceSelected(deviceNames[index]);
                      Device.name = deviceName;
                      Navigator.of(context).pop();
                    },
                  );
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  ///Checks already connected devices and highlights the respective device's tile in the home screen.
  Future checkPrevConnection() async {
    _connectedDevices = await FlutterBluePlus.connectedSystemDevices;
    log("connected devices $_connectedDevices");
    if (_connectedDevices.isNotEmpty) {
      for (var device in _connectedDevices) {
        if (RegExp(r"^[a-zA-Z]\d{6}[a-zA-Z]\d{1,3}$")
                .hasMatch(device.platformName) ||
            RegExp(r"^TEST\d{4}$").hasMatch(device.platformName) ||
            RegExp(r"^TRAIL\d{4}$").hasMatch(device.platformName) ||
            device.platformName == "14022024TEST") {
          await connectToDevice(device, () {});
        }
        break;
      }

      // _connectedDevice = _connectedDevices[0];
    }
  }

  ///Used to connect to a device and update connectedDevices list
  Future connectToDevice(BluetoothDevice device, Function onConnect,
      {bool showToast = false}) async {
    try {
      if (await FlutterBluePlus.adapterState.first ==
          BluetoothAdapterState.on) {
        bool gotServices = false;
        isConnecting = true;
        // isScanning = false;
        notifyListeners();

        await device.connect(
          autoConnect: false,
        );
        if (Platform.isAndroid) {
          await device.requestConnectionPriority(
              connectionPriorityRequest: ConnectionPriority.high);
        }

        await HapticFeedback.vibrate();

        gotServices = await discoverServices(device);
        gotServices ? _connectedDevice = device : null;
        notifyListeners();
        onConnect();
      } else {
        ////Display a dialog to turn on the bluetooth
        if (homeContext == null) {
          await turnBluetoothOn(homeContext!);
        }
      }
    } catch (e) {
      log(e.toString());
      isScanning = false;
      isConnecting = false;
      // Fluttertoast.showToast(msg: "Could not connect ");
      device.disconnect();
      _connectedDevice = null;
      notifyListeners();
    }
  }

  ///Handles the disconnection procedure
  Future disconnectDevice(BluetoothDevice? device) async {
    try {
      // Fluttertoast.showToast(msg: "Disconnecting");
      await device!.disconnect();
      await HapticFeedback.mediumImpact();
      // Fluttertoast.showToast(msg: "Disconnected successfully");
      _connectedDevice = null;
      isConnecting = false;

      ///Removing the device for the connectedDevices list
      _services.clear();

      ///Clearing the services of the devices
      _characteristics.clear();

      /// Clearing the characteristics obtained from the device
      notifyListeners();
    } catch (e) {
      log("Error in disconnecting ${e.toString()}");
      // Fluttertoast.showToast(msg: "Could not disconnect :$e");
    }
  }

  ///Used to discover the services and characteristics;
  ///Also flood services and characteristics into a map
  Future<bool> discoverServices(BluetoothDevice device) async {
    try {
      _services = await device.discoverServices();
      _characteristicMap.clear();
      _characteristics = _services
          .where((element) => element.uuid == SERVICE)
          .first
          .characteristics;

      var subscriptionElement;

      for (var element in _characteristics) {
        characteristicMap.putIfAbsent(element.uuid, () => element);
        if (element.characteristicUuid ==
            Guid("0000abf1-0000-1000-8000-00805f9b34fb")) {
          // print(element);
          subscriptionElement = element;
        }
      }
      var subscription = subscriptionElement.onValueReceived.listen((event) {});
      device.cancelWhenDisconnected(subscription);
      await subscriptionElement.setNotifyValue(true);

      notifyListeners();
      return true;
    } catch (e) {
      // Fluttertoast.showToast(msg: "Unexpected error in getting the services");
      log("Discover services $e");
      return false;
    }
  }

  ///Used to send any message to the device basically command , it is sent in ASCII format
  Future<bool> sendToDevice(String command, Guid characteristic) async {
    try {
      ///Checking if the bluetooth is on
      if (await FlutterBluePlus.adapterState.first ==
          BluetoothAdapterState.on) {
        log("Sending$command");

        BluetoothCharacteristic? writeTarget =
            _characteristicMap[characteristic];

        ///Searching for the actual characteristic by the GUID of the characteristic known
        await writeTarget!.write(command.codeUnits);

        ///Converting the command to ASCII then sending
        await HapticFeedback.mediumImpact();
        // if (command.contains(RegExp(r"mode"))) {
        //   Fluttertoast.showToast(msg: "Mode changed ! ");
        // }
        notifyListeners();
        return true;
      } else {
        // Fluttertoast.showToast(msg: "Seems like bluetooth is turned off ");
        return false;
      }
    } catch (e) {
      log("error in sending message $e");
      // Fluttertoast.showToast(msg: "Unexpected error in sending command ");
      return false;
    }
  }

  Future<bool> changeDeviceMode(String newMode) async {
    try {
      if (await FlutterBluePlus.adapterState.first ==
          BluetoothAdapterState.on) {
        BluetoothCharacteristic? writeTarget =
            _characteristicMap[WRITECHARACTERISTICS];
        String commandToSend = "$MODE $newMode;";
        await writeTarget!.write(commandToSend.codeUnits);
        log("Changing mode to $newMode");
        bool res = await getDeviceMode();

        //// Check if the mode actually has changed or not
        if (modeValue.toString() == newMode && res) {
          // Fluttertoast.showToast(msg: "Mode changed !!");
          return true;
        }
        // Fluttertoast.showToast(msg: "Failed to change mode");
        return false;
      }
      // Fluttertoast.showToast(msg: "Seems like bluetooth is turned off ");
      return false;
    } catch (e) {
      log(
        "Error ocurred in changing the device mode ${e.toString()}",
      );
      return false;
    }
  }

  /// tells whether client is connect to server or not
  Future<bool> getClientConnectionStatus() async {
    try {
      BluetoothCharacteristic? client = _characteristicMap[CLIENT_CONN];
      var clientResponse = await client!.read();
      String isClientConn = String.fromCharCodes(clientResponse);
      isClientConnected = int.parse(isClientConn) == 1 ? true : false;
      log("is client is connected to server: $isClientConnected");
      notifyListeners();

      return true;
    } catch (e) {
      log(e.toString());
      log("Something went wrong while getting connecting to client.");
      return false;
    }
  }

  ///Function used to get battery values
  Future<bool> getBatteryPercentageValues() async {
    try {
      BluetoothCharacteristic? clientTarget =
      _characteristicMap[BATTERY_PERCENTAGE_CLIENT];
      BluetoothCharacteristic? serverTarget =
      _characteristicMap[BATTERY_PERCENTAGE_SERVER];

      var clientResponse = await clientTarget!.read();
      var serverResponse = await serverTarget!.read();
      String tempBattC = String.fromCharCodes(clientResponse);
      String tempBattS = String.fromCharCodes(serverResponse);
      log("CLIENT RAW BATTERY PERCENTAGE is $tempBattC");
      log("SERVER RAW BATTERY PERCENTAGE is $tempBattS");

      double parseBatteryValue(String value) {
        try {
          return double.parse(value);
        } catch (e) {
          return 0;
        }
      }

      double tempBattSValue = parseBatteryValue(tempBattS);
      double tempBattCValue = parseBatteryValue(tempBattC);

      if (tempBattSValue > 100 || tempBattSValue < 0) {
        log("Server Battery Percentage Out of Limit , modifying ....");
        if (tempBattSValue > 100) {
          tempBattS = "100";
        } else {
          tempBattS = "0";
        }
        notifyListeners();
      }
      if (tempBattCValue > 100 || tempBattCValue < 0) {
        log("Client battery percentage Out of Limit , modifying ....");
        if (tempBattCValue > 100) {
          tempBattC = "100";
        } else {
          tempBattC = "0";
        }
        notifyListeners();
        _batteryInfoStatus = true;
      }

      log("Battery values in range");
      log("CLIENT BATTERY PERCENTAGE is $tempBattC");
      log("SERVER BATTERY PERCENTAGE is $tempBattS");
      _batteryC = tempBattC;
      _batteryS = tempBattS;
      _batteryInfoStatus = true;
      notifyListeners();

      return true;
    } catch (e) {
      log(e.toString());
      log("Something went wrong while getting batteryValues.");
      return false;
    }
  }

  Future<bool> getFrequencyValues() async {
    try {
      BluetoothCharacteristic? serverTarget =
          _characteristicMap[FREQUENCY_SERVER];

      var serverResponse = await serverTarget!.read();
      var tempFreq = double.parse(String.fromCharCodes(serverResponse));
      if (tempFreq < 0.3) {
        _freqValue = 0.3;
        notifyListeners();
      }
      if (tempFreq > 2) {
        _freqValue = 2;
        notifyListeners();
      } else {
        _freqValue = tempFreq;
        notifyListeners();
      }

      log("SERVER Frequency Value is ${String.fromCharCodes(serverResponse)}");
      return true;
    } catch (e) {
      log(e.toString());
      log("Something went wrong while getting frequencyValues.");
      return false;
    }
  }

  Future<bool> getMagnitudeValues() async {
    try {
      BluetoothCharacteristic? serverTarget =
          _characteristicMap[MAGNITUDE_SERVER];
      BluetoothCharacteristic? clientTarget =
          _characteristicMap[MAGNITUDE_CLIENT];

      var serverResponse = await serverTarget!.read();
      var clientResponse = await clientTarget!.read();
      var serverTempMagnitude = double.parse(
        String.fromCharCodes(serverResponse),
      );
      var clientTempMagnitude = double.parse(
        String.fromCharCodes(clientResponse),
      );
      if (serverTempMagnitude < 0) {
        _magSValue = 0;
        notifyListeners();
      }
      if (serverTempMagnitude > 4) {
        _magSValue = 4;
        notifyListeners();
      } else {
        _magSValue = serverTempMagnitude;
        notifyListeners();
      }

      if (clientTempMagnitude < 0) {
        _magCValue = 0;
        notifyListeners();
      }
      if (clientTempMagnitude > 4) {
        _magCValue = 4;
        notifyListeners();
      } else {
        _magCValue = clientTempMagnitude;
        notifyListeners();
      }

      log("SERVER Magnitude Value is ${String.fromCharCodes(serverResponse)}");
      log("Client Magnitude Value is ${String.fromCharCodes(clientResponse)}");
      return true;
    } catch (e) {
      log(e.toString());
      log("Something went wrong while getting magnitudeValues.");
      return false;
    }
  }

  Future<void> getBatteryRemaining() async {
    try {
      BluetoothCharacteristic? clientTarget =
          _characteristicMap[BATTERY_TIME_REMAINING_CLIENT];
      BluetoothCharacteristic? serverTarget =
          _characteristicMap[BATTERY_TIME_REMAINING_SERVER];

      var clientResponse = await clientTarget!.read();
      var serverResponse = await serverTarget!.read();

      _rbattC = String.fromCharCodes(clientResponse);
      _rbattS = String.fromCharCodes(serverResponse);
      notifyListeners();

      log("Server battery remaining $_rbattS");
      log("Client battery reamining $_rbattC");
    } catch (e) {
      log(e.toString());
      log("Something went wrong while getting battery left values ");
    }
  }

  Future<bool> getDeviceMode() async {
    try {
      BluetoothCharacteristic? targetChar = _characteristicMap[DEVICE_MODE];
      log("Fetching mode");

      var serverResponse = await targetChar!.read();
      _modeValue = int.parse(
        String.fromCharCodes(serverResponse),
      );
      notifyListeners();

      log("Mode Value is ${String.fromCharCodes(serverResponse)}");
      return true;
    } catch (e) {
      log(
        e.toString(),
      );
      log("Something went wrong while getting Mode Value.");
      return false;
    }
  }

  Future<void> getClientConnectionStream() async {
    // try {
    //   BluetoothCharacteristic targetChar = _characteristicMap[DEVICE_MODE]!;
    //   await targetChar.setNotifyValue(true);
    //   var response;
    //   targetChar.onValueReceived.listen((event) {
    //     response = String.fromCharCodes(event);
    //     log("Client Status $response .");
    //     _clientStatus = response;
    //     notifyListeners();
    //   });
    // } catch (e) {
    //   log("error occurred in getting client status");
    // }
  }

  // Future<void> getClientStatusStream() async {
  //   ////actually this is just wifi provisioned status charac , listening for status here only!

  //   BluetoothCharacteristic? target = _characteristicMap[PROVISIONED_CLIENT];
  //   Timer.periodic(
  //     const Duration(seconds: 5),
  //     (timer) async {
  //       try {
  //         var devices = getConnectedDevices;
  //         if (devices.isNotEmpty) {
  //           var response = await target!.read();
  //           var result = String.fromCharCodes(response);
  //           log("Client Status Result is $result");
  //         } else {
  //           timer.cancel();
  //         }
  //       } catch (e) {
  //         log("in stream ${e.toString()}");
  //         // throw Exception("Reading from the device clashed!! , Retrying");
  //       }
  //     },
  //   );
  // }

  ///ONLY FOR NEWTON'S TESTING NOT TO BE USED IN ACTUAL APPLICATION
  Future<String> getRawBatteryForNewton() async {
    try {
      BluetoothCharacteristic? target =
          _characteristicMap[RAW_BATTERY_VALUE_SERVER];
      var response = await target!.read();
      return String.fromCharCodes(response);
    } catch (e) {
      log(e.toString());
      return "error occurred";
    }
  }

  Future<StreamSubscription<List<int>>> startStream() async {
    BluetoothCharacteristic? targetCharacteristic =
        _characteristicMap[THERAPY_CHARACTERISTICS];

    StreamController<List<int>> controller = StreamController<List<int>>();

    late StreamSubscription<List<int>> angleValuesSubscription;

    try {
      angleValuesSubscription = targetCharacteristic!.onValueReceived.listen(
        (event) {
          controller.add(event);
          String data = String.fromCharCodes(event);
          // if (DoStream.yes) log(data);

          try {
            UnityScreenState.sendAccelerometer(data);
            // ignore: empty_catches
          } catch (e) {}
          if (DoStream.yes) {
            // log(data);
            StreamControllerClass.fun(data);
            List<String> l = data.split(' ');
            l.removeAt(1);
            l.insert(0, DateTime.now().millisecondsSinceEpoch.toString());
            String s = l.join(',');
            // log(FileClass.name);
            File(FileClass.name)
                .writeAsStringSync(s, mode: FileMode.append, flush: true);
          }

          notifyListeners();
        },
        onError: (error) {
          controller.addError(error);
        },
        onDone: () {
          controller.close();
        },
      );
      targetCharacteristic.setNotifyValue(true);
    } catch (e) {
      log("Error in startStream: $e");
      controller.close(); // Close the custom stream in case of an error
    }

    return angleValuesSubscription; // Return the original subscription to the Bluetooth characteristic
  }

  Future<bool> refreshBatteryValues() async {
    bool refreshed;
    refreshed = await getBatteryPercentageValues() &&
        await getClientConnectionStatus() &&
        await getMagnitudeValues() &&
        await getFrequencyValues();
    if (refreshed) {
      return true;
    }
    return false;
  }
}
