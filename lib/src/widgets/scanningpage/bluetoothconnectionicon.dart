import 'package:flutter/material.dart';
import 'package:walk/src/constants/app_color.dart';

Widget bluetoothIcon() {
  return Container(
    width: 80,
    height: 80,
    decoration: const BoxDecoration(
      color: AppColor.blackColor,
      shape: BoxShape.circle,
    ),
    child: const Icon(
      Icons.bluetooth, ////Change this if device is connected
      color: Colors.white,
      size: 50,
    ),
  );
}

Widget bluetoothConnectedIcon() {
  return Container(
    width: 80,
    height: 80,
    decoration: const BoxDecoration(
      color: AppColor.blackColor,
      shape: BoxShape.circle,
    ),
    child: const Icon(
      Icons.check, ////Change this if device is connected
      color: Colors.white,
      size: 50,
    ),
  );
}
