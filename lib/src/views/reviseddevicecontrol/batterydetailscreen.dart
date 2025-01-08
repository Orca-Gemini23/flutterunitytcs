import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/utils/firebasehelper.dart/firebasedb.dart';
import 'package:walk/src/utils/global_variables.dart';
import 'package:walk/src/widgets/batterydetailindicator.dart';

class BatteryDetails extends StatefulWidget {
  const BatteryDetails({super.key, required this.initalPage});

  final int initalPage;

  @override
  State<BatteryDetails> createState() => _BatteryDetailsState();
}

class _BatteryDetailsState extends State<BatteryDetails> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: AppColor.blackColor,
          size: DeviceSize.isTablet ? 36 : 20,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColor.blackColor,
          ),
          onPressed: (() {
            Navigator.pop(context);
          }),
        ),
        title: Text(
          "Battery Monitor",
          style: TextStyle(
            color: AppColor.blackColor,
            fontSize: DeviceSize.isTablet ? 20.h : 16.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding:
              const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 20),
          child: Column(
            children: [
              CarouselSlider(
                items: widget.initalPage == 0
                    ? [
                        SizedBox(
                          height: 260.h,
                          width: 200.w,
                          child: const CustomServerBatteryValueIndicator(),
                        ),
                        SizedBox(
                          height: 260.h,
                          width: 200.w,
                          child: const CustomClientBatteryValueIndicator(),
                        ),
                      ]
                    : [
                        SizedBox(
                          height: 260.h,
                          width: 200.w,
                          child: const CustomClientBatteryValueIndicator(),
                        ),
                        SizedBox(
                          height: 260.h,
                          width: 200.w,
                          child: const CustomServerBatteryValueIndicator(),
                        ),
                      ],
                options: CarouselOptions(
                    viewportFraction: 1,
                    height: 260.h,
                    onPageChanged: (index, reason) {
                      Analytics.addClicks(
                          "CustomServerBatteryValueIndicatorSwipe",
                          DateTime.timestamp());
                      _current = index;
                      setState(() {});
                    }),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  2,
                  (index) => Container(
                    width: 15.0,
                    height: 15.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? AppColor.greenDarkColor
                          : AppColor.greyLight,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              ////Also add a text if the charging is on
              Container(
                height: DeviceSize.isTablet ? 160.h : 105.h,
                padding: EdgeInsets.only(
                  top: 10.h,
                  left: 20.w,
                ),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: AppColor.lightbluegrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.cable_sharp,
                      size: DeviceSize.isTablet ? 60 : 30,
                      color: AppColor.blackColor,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Last Charge",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          "To 90%",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "6hrs 20min ago",
                          style: TextStyle(
                              fontSize: 13.sp, fontWeight: FontWeight.w400),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Container(
                height: DeviceSize.isTablet ? 160.h : 105.h,
                padding: EdgeInsets.only(
                  top: 10.h,
                  left: 20.w,
                ),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: AppColor.lightbluegrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lock_clock,
                      size: DeviceSize.isTablet ? 60 : 30,
                      color: AppColor.blackColor,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Available",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          "4hrs 30min",
                          style: TextStyle(
                              fontSize: 13.sp, fontWeight: FontWeight.w400),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
