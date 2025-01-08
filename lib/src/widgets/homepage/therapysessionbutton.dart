import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/utils/firebasehelper.dart/firebasedb.dart';
import 'package:walk/src/utils/global_variables.dart';

class TherapySessionBtn extends StatefulWidget {
  const TherapySessionBtn({super.key, required this.therapySessionKey});

  final GlobalKey therapySessionKey;

  @override
  State<TherapySessionBtn> createState() => _TherapySessionBtnState();
}

class _TherapySessionBtnState extends State<TherapySessionBtn> {
  bool _isTherapyButtonTapped = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceController>(
      key: widget.therapySessionKey,
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
            height: DeviceSize.isTablet
                ? 170.h
                : _isTherapyButtonTapped
                    ? 145.h
                    : 150.h,
            width: DeviceSize.isTablet
                ? 170.w
                : _isTherapyButtonTapped
                    ? 147.w
                    : 154.w,
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
                color: AppColor.greenDarkColor,
                // deviceController.connectedDevice == null
                //     ? AppColor.greyLight
                //     : AppColor.lightgreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 92.w,
                    height: 92.h,
                    child: Image.asset(
                      "assets/images/therapysession.png",
                      scale: DeviceSize.isTablet ? 2 : 3,
                      // fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    "Therapy games",
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      fontFamily: 'Helvetica',
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
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

  void therapyButtonOnPressed(DeviceController deviceController) async {
    Analytics.addClicks("TherapySessionButton", DateTime.timestamp());
    if (deviceController.connectedDevice == null) {
      Fluttertoast.showToast(
        msg: "Please Connect to the device first",
      );
    } else {
      Navigator.pushNamed(
        context,
        '/therapypage',
      );
    }
  }
}
