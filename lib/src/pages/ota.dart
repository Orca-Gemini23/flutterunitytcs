import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_ota/ota_package.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/controllers/device_controller.dart';

class Ota extends StatefulWidget {
  const Ota({super.key});

  @override
  State<Ota> createState() => _OtaState();
}

class _OtaState extends State<Ota> {
  @override
  void initState() {
    // Replace with the actual UUIDs of your ESP32 BLE service and characteristics
    var device = context.read<DeviceController>().connectedDevice;
    for (var service in device?.servicesList ?? []) {
      print("Service: ${service.uuid}");
      for (var characteristic in service.characteristics) {
        print("Characteristic: ${characteristic.uuid}");
      }
    }
    BluetoothService? service = device?.servicesList
        .where((element) => element.uuid.toString().contains("abf0"))
        .first;
    BluetoothCharacteristic dataCharacteristic = service!.characteristics
        .where((element) => element.uuid.toString().contains("abf7"))
        .first;
    BluetoothCharacteristic notifyCharacteristic = service.characteristics
        .where((element) => element.uuid.toString().contains("abf8"))
        .first;

    Esp32OtaPackage otaPackage =
        Esp32OtaPackage(notifyCharacteristic, dataCharacteristic);
    otaPackage.updateFirmware(
      device!,
      1,
      3,
      service,
      dataCharacteristic,
      notifyCharacteristic,
      url:
          "https://firebasestorage.googleapis.com/v0/b/walk-90dbf.appspot.com/o/walk.bin?alt=media&token=ce7dda91-7ab7-4819-a53b-fb2ed4c5a2f2",
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
