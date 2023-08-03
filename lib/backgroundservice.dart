import 'dart:async';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:walk/src/constants/bt_constants.dart';

Future<void> initServices() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: false,
        initialNotificationTitle: "LIFESPARKTECH",
        initialNotificationContent: "Keep WALK - inggg !!!"),
  );

  service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  List<BluetoothDevice> connDevices = [];
  List<BluetoothService> _services = [];
  List<String> battValues = [];
  List<BluetoothCharacteristic> _characteristics = [];
  Map<Guid, BluetoothCharacteristic> _characteristicMap = {};
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen(
      (event) {
        service.setAsForegroundService();
        flutterLocalNotificationsPlugin.show(
          101,
          'WALK',
          'Hello , Happy WALK - inggg!!!!!! ${DateTime.now()}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              '101',
              'walkservice',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );

        Timer.periodic(
          const Duration(seconds: 15),
          (timer) async {
            connDevices = await FlutterBluePlus.connectedSystemDevices;
            print("Connected Devices are ${connDevices}");
            if (connDevices.isEmpty) {
              print("Starting Scans");
              FlutterBluePlus.scan(
                timeout: const Duration(seconds: 5),
                withServices: [
                  Guid("0000acf0-0000-1000-8000-00805f9b34fb"),
                ],
              ).listen(
                (scanresult) async {
                  print("Scanned a device ${scanresult}");
                  await scanresult.device
                      .connect(timeout: const Duration(seconds: 5));
                  print("Connected a device");
                  connDevices.add(scanresult.device);
                  _services = await scanresult.device.discoverServices();
                  _characteristicMap.clear();
                  _characteristics = _services
                      .where((element) => element.uuid == SERVICE)
                      .first
                      .characteristics;
                  BluetoothCharacteristic? clientTarget =
                      _characteristics.firstWhere(
                    (element) => element.uuid == BATTERY_PERCENTAGE_CLIENT,
                  );
                  BluetoothCharacteristic? serverTarget =
                      _characteristics.firstWhere((element) =>
                          element.uuid == BATTERY_PERCENTAGE_SERVER);
                  battValues = await getBatteryPercentageValues(
                      clientTarget, serverTarget);

                  flutterLocalNotificationsPlugin.show(
                    101,
                    'Walk device connected ${DateTime.now()}',
                    'Left battery ${battValues[1]}  Right battery ${battValues[0]}',
                    const NotificationDetails(
                      android: AndroidNotificationDetails(
                        '101',
                        'walkservice',
                        icon: 'ic_bg_service_small',
                        ongoing: true,
                      ),
                    ),
                  );

                  ////Once it connects try and show the data from the device in a notification
                },
              );
            } else {
              await connDevices.elementAt(0).connect();
              _services = await connDevices.elementAt(0).discoverServices();
              _characteristics = _services
                  .where((element) => element.uuid == SERVICE)
                  .first
                  .characteristics;

              BluetoothCharacteristic? clientTarget =
                  _characteristics.firstWhere(
                (element) => element.uuid == BATTERY_PERCENTAGE_CLIENT,
              );
              BluetoothCharacteristic? serverTarget =
                  _characteristics.firstWhere(
                      (element) => element.uuid == BATTERY_PERCENTAGE_SERVER);
              battValues =
                  await getBatteryPercentageValues(clientTarget, serverTarget);

              flutterLocalNotificationsPlugin.show(
                101,
                'Walk Connected ${DateTime.now()}',
                'Left battery ${battValues[1]}  Right battery ${battValues[0]}',
                const NotificationDetails(
                  android: AndroidNotificationDetails(
                    '101',
                    'walkservice',
                    icon: 'ic_bg_service_small',
                    ongoing: false,
                    playSound: false,
                  ),
                ),
              );
            }
          },
        );
      },
    );
    service.on('setAsBackground').listen((event) {
      print("setAsBackground");
      service.setAsBackgroundService();
    });
    service.on("scanConnectBle").listen(
      (event) async {
        // service.setAsForegroundService();
      },
    );
  }
  service.on("stopService").listen(
    (event) {
      print("stopping Service");
      service.stopSelf();
    },
  );
}

Future<List<String>> getBatteryPercentageValues(
    BluetoothCharacteristic? clientTarget,
    BluetoothCharacteristic? serverTarget) async {
  String _batteryS = "--%";
  String _batteryC = "--%";
  try {
    var clientResponse = await clientTarget!.read();
    var serverResponse = await serverTarget!.read();
    String tempBattC = String.fromCharCodes(clientResponse);
    String tempBattS = String.fromCharCodes(serverResponse);
    if (double.parse(tempBattS) > 100 || double.parse(tempBattS) < 0) {
      print("Server Battery Percentage Out of Limit , modifying ....");
      if (double.parse(tempBattS) > 100) {
        _batteryS = "100";
      } else {
        _batteryS = "0";
      }
    }
    if (double.parse(tempBattC) > 100 || double.parse(tempBattC) < 0) {
      print("Client battery percentage Out of Limit , modifying");
      if (double.parse(tempBattC) > 100) {
        _batteryC = "100";
      } else {
        _batteryC = "0";
      }
    } else {
      print("Battery values in range");
      print("CLIENT BATTERY PERCENTAGE is $tempBattC");
      print("SERVER BATTERY PERCENTAGE is $tempBattS");
      _batteryC = tempBattC;
      _batteryS = tempBattS;
    }
    return [_batteryC, _batteryS];
  } catch (e) {
    print(e.toString());
    print("Something went wrong while getting batteryValues.");
    return [_batteryC, _batteryS];
  }
}
