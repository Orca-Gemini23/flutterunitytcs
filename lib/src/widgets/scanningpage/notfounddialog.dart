import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walk/src/constants/app_color.dart';

Widget deviceNotFoundDialog() {
  return Dialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      width: 300.w,
      height: 305.h,
      decoration: BoxDecoration(
        color: AppColor.lightbluegrey,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 25.h,
          ),
          SizedBox(
            height: 78.h,
            width: 78.w,
            child: const Image(
              image: AssetImage("assets/images/devicenotfound.png"),
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 25.h,
          ),
          Text(
            "Oops! device not found",
            style: TextStyle(
                color: AppColor.greenDarkColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 35.h,
          ),
          RichText(
            text: TextSpan(
              children: [
                const WidgetSpan(
                  child: Icon(Icons.info_outline, size: 20),
                ),
                TextSpan(
                  text: "Make sure the device is ON",
                  style: TextStyle(
                    color: AppColor.blackColor,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          RichText(
            text: TextSpan(
              children: [
                const WidgetSpan(
                  child: Icon(Icons.info_outline, size: 20),
                ),
                TextSpan(
                  text: "Charge the device",
                  style: TextStyle(
                    color: AppColor.blackColor,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
