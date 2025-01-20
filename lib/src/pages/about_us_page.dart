import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/utils/global_variables.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColor.blackColor,
          size: DeviceSize.isTablet ? 36 : 24,
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
          AppString.aboutUsTitle,
          style: TextStyle(
            color: AppColor.blackColor,
            fontSize: DeviceSize.isTablet ? 36 : 20,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      AppString.org,
                      style: TextStyle(
                        fontSize: 42.h,
                        // letterSpacing: 4,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Helvetica",
                        color: AppColor.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 40.h,
                      padding: const EdgeInsets.all(0.5),
                      color: AppColor.primary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Lifespark\nTechnologies",
                      style: TextStyle(
                          color: AppColor.primary,
                          fontSize: 18.h,
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                AppString.aboutUsParagraph,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 14.h,
                  // fontFamily: "Helvetica",
                ),
              ),
            ),
            const Spacer(),
            Container(
              width: double.maxFinite,
              height: 130.h,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: const BoxDecoration(
                color: AppColor.greyLight,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 5.h,
                    child: Text(
                      "Location",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        fontFamily: "Helvetica",
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40.h,
                    left: 20.w,
                    child: SizedBox(
                      height: 53.h,
                      width: 106.w,
                      child: const Image(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          "assets/images/womannav.png",
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      top: 25.h,
                      right: 0,
                      child: Text(
                        "We are based at the \nIndian Institute of Technology, \nBombay ,India",
                        style: TextStyle(
                          color: AppColor.blackColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Helvetica",
                        ),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
