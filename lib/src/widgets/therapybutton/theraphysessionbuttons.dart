import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/utils/firebasehelper.dart/firebasedb.dart';
import 'package:walk/src/utils/global_variables.dart';
import 'package:walk/src/views/pages/Unity.dart';

class TherapySessionButton extends StatefulWidget {
  const TherapySessionButton({
    super.key,
    required this.unityScreenNumber,
    required this.imageAssetPath,
    required this.gameName,
  });

  final int unityScreenNumber;
  final String imageAssetPath;
  final String gameName;

  @override
  State<TherapySessionButton> createState() => _TherapySessionButtonState();
}

class _TherapySessionButtonState extends State<TherapySessionButton> {
  bool _isTherapyButtonTapped = false;

  @override
  Widget build(BuildContext context) {
    String gameName = widget.gameName;
    String imagePath = widget.imageAssetPath;
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
            height: DeviceSize.isTablet
                ? _isTherapyButtonTapped
                    ? 175.h
                    : 170.h
                : _isTherapyButtonTapped
                    ? 145.h
                    : 150.h,
            width: DeviceSize.isTablet
                ? _isTherapyButtonTapped
                    ? 150.w
                    : 144.w
                : _isTherapyButtonTapped
                    ? 147.w
                    : 154.w,
            child: Container(
              height: DeviceSize.isTablet ? 175.h : 150.h,
              width: DeviceSize.isTablet ? 150.w : 154.w,
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
                    : AppColor.gameEntryTileColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 92.w,
                    height: 92.h,
                    child: Image.asset(
                      imagePath,
                      scale: DeviceSize.isTablet ? 2 : 3.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    gameName,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Helvetica",
                      color: Colors.white,
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
    Analytics.addClicks(
        "${widget.gameName.replaceAll(" ", "")}Button", DateTime.timestamp());
    if (deviceController.connectedDevice == null) {
      Fluttertoast.showToast(
        msg: "Please Connect to the device first",
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => UnityScreen(i: widget.unityScreenNumber)),
          settings: RouteSettings(name: '/${widget.gameName}'),
        ),
      );
    }
  }
}
