import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/utils/global_variables.dart';

List<Image> imageItems = const [
  Image(
    image: AssetImage("assets/images/tutorial/unfold.png"),
    fit: BoxFit.fill,
  ),
  Image(
    image: AssetImage("assets/images/tutorial/alignment.png"),
    fit: BoxFit.fill,
  ),
  Image(
    image: AssetImage("assets/images/tutorial/placement.png"),
    fit: BoxFit.fill,
  ),
  Image(
    image: AssetImage("assets/images/tutorial/wear1.png"),
    fit: BoxFit.fill,
  ),
  Image(
    image: AssetImage("assets/images/tutorial/switchon.png"),
    fit: BoxFit.fill,
  ),
  Image(
    image: AssetImage("assets/images/tutorial/charging.png"),
    fit: BoxFit.fill,
  ),
];
List<String> imageNames = const [
  "Unfold Device",
  "Check Device Alignment",
  "Device Placement",
  "Wear Device",
  "Switch On",
  "Charging",
];
List<String> imageDescription = [
  "Take the device out of the box and unfold it, pointing the triangle symbol down.",
  "If the triangular symbol has ‘R’, it is meant for the right leg and if it has ‘L’ it is for the left leg.",
  "Place the device on the leg as shown by the symbol. It should be 3 fingers above the knee with the triangle symbol in the centre of the leg.",
  "Wrap the Device on the leg securing the velcro in the shape of a cross. The device will loosen when standing so it has to be wrapped slightly tight.Stand and check the fitting, if needed re-adjust",
  "Slide button to turn device ‘ON’.",
  "The charging slit is on the top of the device as shown in the image.Red light - charging Blue light - charging completed"
];

Widget tutorialCard(int index) {
  if (index >= 0 && index < imageItems.length) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      width: 250.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 140.h,
            width: 220.w,
            child: imageItems[index],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            imageNames[index],
            overflow: TextOverflow.clip,
            style: TextStyle(
                color: AppColor.primary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: DeviceSize.isTablet ? 20 : 10),
          Flexible(
            child: Text(
              imageDescription[index],
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: AppColor.blackColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  } else {
    return lastTutorialCard();
  }
}

Widget lastTutorialCard() {
  return Container(
    width: 300.w,
    margin: EdgeInsets.symmetric(horizontal: 5.w),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(
        child: Column(children: [
          Text(
            "Sensory Cueing",
            style: TextStyle(
              color: AppColor.primary,
              fontSize: 16.sp,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 50.h,
                width: 50.w,
                child: const Image(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    "assets/images/tutorial/cueing.png",
                  ),
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                child: Text(
                  "The device will start sensory cueing once worn properly in standing position.It will stop cueing when sitting.",
                  style:
                      TextStyle(fontSize: DeviceSize.isTablet ? 12.sp : 14.sp),
                  textAlign: TextAlign.left,
                ),
              )
            ],
          )
        ]),
      ),
      SizedBox(
        height: 20.h,
      ),
      SizedBox(
        child: Column(children: [
          Text(
            "Focus on vibration \nwhile moving",
            style: TextStyle(
              color: AppColor.primary,
              fontSize: 16.sp,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 50.w,
                height: 50.h,
                child: const Image(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    "assets/images/tutorial/sensorycueing.png",
                  ),
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                child: Text(
                  "Move the leg which vibrates first, then the second.",
                  style:
                      TextStyle(fontSize: DeviceSize.isTablet ? 12.sp : 14.sp),
                  textAlign: TextAlign.left,
                ),
              )
            ],
          )
        ]),
      ),
      SizedBox(
        height: 20.h,
      ),
      SizedBox(
        child: Column(children: [
          Text(
            "2 hours a day",
            style: TextStyle(
              color: AppColor.primary,
              fontSize: 16.sp,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 50.h,
                width: 50.w,
                child: const Image(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    "assets/images/tutorial/formkit_time.png",
                  ),
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                child: Text(
                  "Wear the device for one hour each in the morning and evening or when you feel that you might freeze.",
                  style:
                      TextStyle(fontSize: DeviceSize.isTablet ? 12.sp : 14.sp),
                  textAlign: TextAlign.left,
                ),
              )
            ],
          )
        ]),
      ),
    ]),
  );
}
