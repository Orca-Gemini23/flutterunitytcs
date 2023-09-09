import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:walk/src/constants/app_color.dart';

class CustomStepCountCircularProgressIndicator extends StatefulWidget {
  const CustomStepCountCircularProgressIndicator({super.key});

  @override
  State<CustomStepCountCircularProgressIndicator> createState() =>
      _CustomStepCountCircularProgressIndicatorState();
}

class _CustomStepCountCircularProgressIndicatorState
    extends State<CustomStepCountCircularProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130.h,
      width: 128.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              child: Container(
            width: 82.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                Color(0xffFAB94F),
                AppColor.whiteColor,
              ], focalRadius: 10, radius: 0.7, tileMode: TileMode.repeated),
            ),
          )),
          Positioned(
            top: 3,
            child: CircularPercentIndicator(
              radius: 62.h,
              percent: 1,
              progressColor: const Color(0xffFAB94F),
              lineWidth: 7,
              backgroundColor: Colors.transparent,
              circularStrokeCap: CircularStrokeCap.round,
              center: SizedBox(
                width: 23.w,
                height: 27.h,
                child: Image.asset(
                  "assets/images/walkingman.png",
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
