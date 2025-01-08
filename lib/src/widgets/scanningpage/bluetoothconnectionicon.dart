import 'package:flutter/material.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/utils/global_variables.dart';

Widget bluetoothIcon() {
  return Container(
    width: DeviceSize.isTablet ? 160 : 80,
    height: DeviceSize.isTablet ? 160 : 80,
    decoration: const BoxDecoration(
      color: AppColor.greenDarkColor,
      shape: BoxShape.circle,
    ),
    child: Icon(
      Icons.bluetooth, ////Change this if device is connected
      color: Colors.white,
      size: DeviceSize.isTablet ? 100 : 50,
    ),
  );
}

Widget bluetoothConnectedIcon() {
  return Container(
    width: DeviceSize.isTablet ? 160 : 80,
    height: DeviceSize.isTablet ? 160 : 80,
    decoration: const BoxDecoration(
      color: AppColor.blackColor,
      shape: BoxShape.circle,
    ),
    child: Icon(
      Icons.check, ////Change this if device is connected
      color: Colors.white,
      size: DeviceSize.isTablet ? 100 : 50,
    ),
  );
}
