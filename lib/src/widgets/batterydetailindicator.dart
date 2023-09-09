import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';

import '../controllers/device_controller.dart';

class CustomServerBatteryValueIndicator extends StatefulWidget {
  const CustomServerBatteryValueIndicator({
    super.key,
    this.isCharging = false,
  });
  final bool isCharging;

  @override
  State<CustomServerBatteryValueIndicator> createState() =>
      _CustomServerBatteryValueIndicatorState();
}

class _CustomServerBatteryValueIndicatorState
    extends State<CustomServerBatteryValueIndicator> {
  double batteryPercent = 20.0;

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceController>(
        builder: (context, deviceController, child) {
      return Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 36.h,
            child: CircularPercentIndicator(
              percent: deviceController.battS / 100,
              lineWidth: 10,
              radius: 100.w,
              progressColor: deviceController.battS > 25
                  ? AppColor.batteryindicatorgreen
                  : AppColor.batteryindicatorred,
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: Colors.transparent,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 70.h,
            child: Container(
              height: 152.h,
              width: 152.w,
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                shape: BoxShape.circle,
                boxShadow: deviceController.battS > 25
                    ? [
                        BoxShadow(
                            offset: Offset.zero,
                            color: const Color(0xffA5DECD).withOpacity(.4),
                            blurRadius: 30,
                            spreadRadius: 21)
                      ]
                    : [
                        BoxShadow(
                            offset: Offset.zero,
                            color: const Color(0xffDEBAA5).withOpacity(.4),
                            blurRadius: 30,
                            spreadRadius: 21)
                      ],
              ),
              child: widget.isCharging
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${deviceController.battS.floor()}%",
                          style: TextStyle(
                              color: deviceController.battC > 25
                                  ? AppColor.batteryindicatortextgreen
                                  : AppColor.batteryindicatortextred,
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "Charging",
                          style: TextStyle(
                            color: AppColor.blackColor,
                            fontSize: 13.sp,
                          ),
                        )
                      ],
                    )
                  : deviceController.battS < 25
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${deviceController.battS.floor()}%",
                              style: TextStyle(
                                  color: deviceController.battS > 25
                                      ? AppColor.batteryindicatortextgreen
                                      : AppColor.batteryindicatortextred,
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "Connect Charger",
                              style: TextStyle(
                                color: AppColor.blackColor,
                                fontSize: 13.sp,
                              ),
                            )
                          ],
                        )
                      : Center(
                          child: Text(
                            "${deviceController.battS.floor()}%",
                            style: TextStyle(
                                color: deviceController.battS > 25
                                    ? AppColor.batteryindicatortextgreen
                                    : AppColor.batteryindicatortextred,
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
            ),
          ),
          Positioned(
            left: 78.w,
            top: 0.h,
            child: Text(
              "Left",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      );
    });
  }
}

class CustomClientBatteryValueIndicator extends StatefulWidget {
  const CustomClientBatteryValueIndicator({
    super.key,
    this.isCharging = false,
  });
  final bool isCharging;

  @override
  State<CustomClientBatteryValueIndicator> createState() =>
      _CustomClientBatteryValueIndicatorState();
}

class _CustomClientBatteryValueIndicatorState
    extends State<CustomClientBatteryValueIndicator> {
  double batteryPercent = 20.0;

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceController>(
        builder: (context, deviceController, child) {
      return Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 36.h,
            child: CircularPercentIndicator(
              percent: deviceController.battC / 100,
              lineWidth: 10,
              radius: 100.w,
              progressColor: deviceController.battC > 25
                  ? AppColor.batteryindicatorgreen
                  : AppColor.batteryindicatorred,
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: Colors.transparent,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 70.h,
            child: Container(
              height: 152.h,
              width: 152.w,
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                shape: BoxShape.circle,
                boxShadow: deviceController.battC > 25
                    ? [
                        BoxShadow(
                            offset: Offset.zero,
                            color: const Color(0xffA5DECD).withOpacity(.4),
                            blurRadius: 30,
                            spreadRadius: 21)
                      ]
                    : [
                        BoxShadow(
                            offset: Offset.zero,
                            color: const Color(0xffDEBAA5).withOpacity(.4),
                            blurRadius: 30,
                            spreadRadius: 21)
                      ],
              ),
              child: widget.isCharging
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${deviceController.battC.floor()}%",
                          style: TextStyle(
                              color: deviceController.battC > 25
                                  ? AppColor.batteryindicatortextgreen
                                  : AppColor.batteryindicatortextred,
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "Charging",
                          style: TextStyle(
                            color: AppColor.blackColor,
                            fontSize: 13.sp,
                          ),
                        )
                      ],
                    )
                  : deviceController.battC < 25
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${deviceController.battC.floor()}%",
                              style: TextStyle(
                                  color: deviceController.battC > 25
                                      ? AppColor.batteryindicatortextgreen
                                      : AppColor.batteryindicatortextred,
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "Connect Charger",
                              style: TextStyle(
                                color: AppColor.blackColor,
                                fontSize: 13.sp,
                              ),
                            )
                          ],
                        )
                      : Center(
                          child: Text(
                            "${deviceController.battC.floor()}%",
                            style: TextStyle(
                                color: deviceController.battC > 25
                                    ? AppColor.batteryindicatortextgreen
                                    : AppColor.batteryindicatortextred,
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
            ),
          ),
          Positioned(
            left: 78.w,
            top: 0.h,
            child: Text(
              "Right",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      );
    });
  }
}
