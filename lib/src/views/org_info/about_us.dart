import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColor.blackColor,
        ),
        title: const Text(
          AppString.aboutUsTitle,
          style: TextStyle(
            color: AppColor.blackColor,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppString.org,
                      style: TextStyle(
                        fontSize: 32.sp,
                        letterSpacing: 4,
                        color: AppColor.greenDarkColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.all(0.5),
                      color: AppColor.greenDarkColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Lifespark\nTechnologies",
                      style: TextStyle(
                          color: AppColor.greenDarkColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                AppString.aboutUsParagraph,
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14.sp),
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
                        "We are based at the \nIndian Institute of Technology \n,Bombay ,India",
                        style: TextStyle(
                          color: AppColor.blackColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
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
