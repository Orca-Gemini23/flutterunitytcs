import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:walk/src/constants/bt_constants.dart';
import 'package:walk/src/controllers/device_controller.dart';

import '../../constants/app_color.dart';

Widget magSlider(bool isClient, DeviceController controller) {
  return SliderTheme(
    data: const SliderThemeData(
      trackHeight: 8,
      activeTrackColor: AppColor.greenDarkColor,
      thumbColor: AppColor.greenDarkColor,
    ),
    child: Slider(
        //MAGNITUDE SLIDER
        value: isClient
            ? controller.magCValue < 0
                ? 0
                : controller.magCValue
            : controller.magSValue,
        min: 0,
        max: 4,
        divisions: 4,
        label: isClient
            ? controller.magCValue.toString()
            : controller.magSValue.toString(),
        onChanged: (value) {
          HapticFeedback.lightImpact();
          isClient
              ? controller.setmagCValue(value)
              : controller.setmagSValue(value);
        },
        onChangeEnd: (value) async {
          String command = "";
          command = isClient ? "$MAG c $value;" : "$MAG s $value;";
          await controller.sendToDevice(command, WRITECHARACTERISTICS);
        }),
  );
}
