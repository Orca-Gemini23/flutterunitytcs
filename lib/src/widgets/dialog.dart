import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/pages/home_page.dart';

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: ((context) => const HomePage()),
            settings: const RouteSettings(name: '/home'),
          ),
        );
      },
      btnOkText: "Take me to home",
      btnOkColor: AppColor.primary,
    ).show();
  }

  static showScoreUplodingDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      title: "Uploading you scores",
      desc: "Please wait while we upload your data to cloud .",
      customHeader: const CircularProgressIndicator(
        color: AppColor.primary,
        backgroundColor: Colors.white,
      ),
      borderSide: const BorderSide(color: AppColor.primary, width: 4),
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
    ).show();
  }
}
