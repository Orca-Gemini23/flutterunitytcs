import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/utils/firebase/firebase_db.dart';
import 'package:walk/src/utils/global_variables.dart';

class DeviceControlBtn extends StatefulWidget {
  const DeviceControlBtn({super.key, required this.deviceControlKey});

  final GlobalKey deviceControlKey;

  @override
  State<DeviceControlBtn> createState() => _DeviceControlBtnState();
}

class _DeviceControlBtnState extends State<DeviceControlBtn>
    with WidgetsBindingObserver {
  DeviceController? deviceController;
  bool _isDeviceButtonTapped = false;

  @override
  Widget build(BuildContext context) {
    deviceController = Provider.of<DeviceController>(context);
    return InkWell(
      key: widget.deviceControlKey,
      highlightColor: Colors.transparent,
      splashColor: AppColor.primary,
      onHighlightChanged: (value) {
        setState(() {
          _isDeviceButtonTapped = value;
        });
      },
      onTap: () async {
        onPressed(deviceController);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastLinearToSlowEaseIn,
        height: DeviceSize.isTablet
            ? 170.h
            : _isDeviceButtonTapped
                ? 145.h
                : 150.h,
        width: DeviceSize.isTablet
            ? 170.w
            : _isDeviceButtonTapped
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
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              deviceController?.connectedDevice != null
                  ? const BoxShadow(
                      color: AppColor.primary, blurRadius: 4, spreadRadius: 1)
                  : const BoxShadow(
                      color: AppColor.appShadowDark,
                      offset: Offset(0, 4),
                      blurRadius: 4,
                      spreadRadius: 2),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 92.w,
                height: 92.h,
                child: Image.asset(
                  "assets/images/devicecontrol.png",
                  scale: DeviceSize.isTablet ? 2 : 3,
                ),
                // const Image(
                //   fit: BoxFit.contain,
                //   color: AppColor.blackColor,
                //   image: AssetImage(
                //     "assets/images/devicecontrol.png",
                //   ),
                // ),
              ),
              Text(
                deviceController?.connectedDevice == null
                    ? "Connect Device"
                    : "Device Control",
                overflow: TextOverflow.fade,
                maxLines: 1,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontFamily: 'Helvetica',
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onPressed(DeviceController? deviceController) async {
    await deviceController?.checkPrevConnection();
    Analytics.addClicks("DeviceControlButton", DateTime.timestamp());
    if (deviceController?.connectedDevice == null) ////no device yet connected
    {
      Navigator.pushNamed(
        context,
        '/connectionscreen',
      );
    } else {
      Navigator.pushNamed(
        context,
        '/devicecontrol',
      );
    }
  }
}
