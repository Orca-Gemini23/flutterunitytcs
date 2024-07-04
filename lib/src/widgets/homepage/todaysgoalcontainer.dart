import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/server/api.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/views/revisedhome/newhomepage.dart';
import 'package:walk/src/views/stepgoal/step_goal_page.dart';

class TodaysGoalBox extends StatefulWidget {
  const TodaysGoalBox({
    super.key,
  });

  @override
  State<TodaysGoalBox> createState() => _TodaysGoalBoxState();
}

class _TodaysGoalBoxState extends State<TodaysGoalBox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: keyGoalBox,
      onTap: () {
        Go.to(
          context: context,
          push: const StepGoalPage(),
        );
      },
      child: Container(
        ////Todays's goal Container

        padding: const EdgeInsets.only(
          top: 20,
          bottom: 20,
          left: 10,
          right: 10,
        ),
        width: double.maxFinite,
        height: 158.h,
        decoration: BoxDecoration(
          color: AppColor.greenDarkColor,
          boxShadow: const [
            BoxShadow(
              blurRadius: 2,
              spreadRadius: 2,
              color: AppColor.greyLight,
            )
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Positioned(
              child: Image(
                fit: BoxFit.contain,
                width: 143.w,
                height: 105.h,
                image: const AssetImage(
                  "assets/images/re1.png",
                ),
              ),
            ),
            Positioned(
              right: 25,
              top: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Goal",
                    style: TextStyle(
                      color: AppColor.whiteColor,
                      fontSize: 16.sp,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Completed',
                          style: TextStyle(
                            color: AppColor.whiteColor,
                            fontSize: 16.sp,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const WidgetSpan(
                          child: SizedBox(
                            width: 5,
                          ),
                        ),
                        const WidgetSpan(
                          child: Icon(
                            Icons.verified,
                            color: AppColor.amberColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                      future: API.getScore(),
                      builder: ((context, snapshot) {
                        var gaitScore = snapshot.hasData
                            ? (snapshot.data as Map)['Gait Score']
                            : "";
                        var balanceScore = snapshot.hasData
                            ? (snapshot.data as Map)['Balance Score']
                            : "";

                        return Column(
                          children: [
                            Text(
                              "Gait Score : $gaitScore",
                              style: TextStyle(
                                  color: AppColor.whiteColor, fontSize: 12.sp),
                            ),
                            Text(
                              "Balance Score : $balanceScore",
                              style: TextStyle(
                                color: AppColor.whiteColor,
                                fontSize: 12.sp,
                              ),
                            )
                          ],
                        );
                      }))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
