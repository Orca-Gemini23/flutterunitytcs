import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/utils/custom_navigation.dart';

class CustomDialogs {
  static showBleDisconnectedDialog(
    BuildContext context,
  ) {
    AwesomeDialog(
      context: context,
      title: "Bluetooth Disconnected",
      dismissOnTouchOutside: false,
      desc: "Oops , lost bluetooth connection please try and connect again.",
      btnOkOnPress: () {
        Go.back(context: context);
      },
      btnOkText: "Take me to home",
      btnOkColor: AppColor.greenDarkColor,
    ).show();
  }

  static showScoreUplodingDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      title: "Uploading you scores",
      desc: "Please wait while we upload your data to cloud .",
      customHeader: const CircularProgressIndicator(
        color: AppColor.greenDarkColor,
        backgroundColor: Colors.white,
      ),
      borderSide: const BorderSide(color: AppColor.greenDarkColor, width: 4),
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
    ).show();
  }
}
