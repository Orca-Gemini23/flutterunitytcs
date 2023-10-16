// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/views/reviseddevicecontrol/connectionscreen.dart';
import 'package:walk/src/views/reviseddevicecontrol/newdevicecontrol.dart';

class DeviceControlBtn extends StatefulWidget {
  const DeviceControlBtn({super.key});

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
      highlightColor: Colors.transparent,
      splashColor: AppColor.greenDarkColor,
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
        height: _isDeviceButtonTapped ? 145.h : 150.h,
        width: _isDeviceButtonTapped ? 147.w : 154.w,
        child: Container(
          height: 150.h,
          width: 154.w,
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: AppColor.lightgreen,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              deviceController?.connectedDevice != null
                  ? const BoxShadow(
                      color: AppColor.greenDarkColor,
                      blurRadius: 4,
                      spreadRadius: 1)
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
                child: const Image(
                  fit: BoxFit.contain,
                  color: AppColor.blackColor,
                  image: AssetImage(
                    "assets/images/devicecontrol.png",
                  ),
                ),
              ),
              Text(
                "Device Control",
                overflow: TextOverflow.fade,
                maxLines: 1,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onPressed(DeviceController? deviceController) async {
    await deviceController?.checkPrevConnection();
    if (deviceController?.connectedDevice == null) ////no device yet connected
    {
      Go.to(
        context: context,
        push: const ConnectionScreen(),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          settings: const RouteSettings(name: "/devicecontrolpage"),
          builder: (context) => const DeviceControlPage(),
        ),
      );
    }
  }
}
