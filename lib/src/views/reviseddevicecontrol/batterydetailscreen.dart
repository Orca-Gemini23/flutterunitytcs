import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/widgets/batterydetailindicator.dart';

class BatteryDetails extends StatefulWidget {
  const BatteryDetails({super.key});

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
        iconTheme: const IconThemeData(
          color: AppColor.blackColor,
        ),
        title: Text(
          "Battery Monitor",
          style: TextStyle(
            color: AppColor.blackColor,
            fontSize: 16.sp,
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
                items: [
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
                ],
                options: CarouselOptions(
                    viewportFraction: 1,
                    height: 260.h,
                    onPageChanged: (index, reason) {
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
                height: 105.h,
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
                    const Icon(
                      Icons.cable_sharp,
                      size: 30,
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
                height: 105.h,
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
                    const Icon(
                      Icons.lock_clock,
                      size: 30,
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
