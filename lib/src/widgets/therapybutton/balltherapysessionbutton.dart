// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/bt_constants.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/views/artherapy/animation_rotation.dart';
import 'package:walk/src/views/unity.dart';
import 'package:walk/src/views/user/revisedaccountpage.dart';

class BallTherapySessionBtn extends StatefulWidget {
  const BallTherapySessionBtn({super.key});

  @override
  State<BallTherapySessionBtn> createState() => _BallTherapySessionBtnState();
}

class _BallTherapySessionBtnState extends State<BallTherapySessionBtn> {
  bool _isTherapyButtonTapped = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceController>(
      builder: (context, deviceController, widget) {
        return InkWell(
          highlightColor: Colors.transparent,
          splashColor: AppColor.greenDarkColor,
          onHighlightChanged: (value) {
            deviceController.connectedDevice == null
                ? null
                : setState(() {
                    _isTherapyButtonTapped = value;
                  });
          },
          onTap: () async {
            therapyButtonOnPressed(deviceController);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastLinearToSlowEaseIn,
            height: _isTherapyButtonTapped ? 145.h : 150.h,
            width: _isTherapyButtonTapped ? 147.w : 154.w,
            child: Container(
              height: 150.h,
              width: 154.w,
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                      color: AppColor.appShadowDark,
                      offset: Offset(0, 4),
                      blurRadius: 4,
                      spreadRadius: 2)
                ],
                color: deviceController.connectedDevice == null
                    ? AppColor.greyLight
                    : AppColor.lightgreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 92.w,
                    height: 92.h,
                    child: const Image(
                      fit: BoxFit.contain,
                      // color: AppColor.blackColor,
                      image: AssetImage(
                        "assets/images/footballwithshadow.png",
                      
                      ),
                    ),
                  ),
                  Text(
                    "ball",
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool checkAccountEligible() {
    String userName = LocalDB.listenableUser()
        .value
        .get(
          0,
          defaultValue: LocalDB.defaultUser,
        )!
        .name;

    if (userName == "Unknown User") {
      ////Dont allow user to use the therapy page
      return false;
    }
    return true;
  }

  void therapyButtonOnPressed(DeviceController deviceController) async {
    print("coming here");
    if (deviceController.connectedDevice == null) {
      Fluttertoast.showToast(
        msg: "Please Connect to the device first",
      );
    } else {
      bool accountEligible = checkAccountEligible();

      if (accountEligible) {
        bool res = await deviceController.sendToDevice(
            "mode 9;", WRITECHARACTERISTICS);
        res
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => const UnityScreen(i: 0,)),
                ),
              )
            : Fluttertoast.showToast(
                msg: "Please try again",
              );
      } else {
        Fluttertoast.showToast(msg: "Please update the account details first");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Revisedaccountpage(),
          ),
        );
      }
    }
  }
}
