import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/widgets/stepgoalpage/circularstepindicator.dart';
import 'package:walk/src/widgets/stepgoalpage/templevisitcard.dart';
import 'package:walk/src/widgets/stepgoalpage/weekdayindicator';

class StepGoalPage extends StatefulWidget {
  const StepGoalPage({Key? key}) : super(key: key);

  @override
  State<StepGoalPage> createState() => _StepGoalPageState();
}

class _StepGoalPageState extends State<StepGoalPage> {
  List<Widget> getAllQuests() {
    List<Widget> questOptions = [
      Stack(children: [
        SizedBox(
          width: 258.w,
          height: 145.h,
          child: const Image(
            image: AssetImage(
              "assets/images/image 34.png",
            ),
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          right: 5,
          bottom: 5,
          child: Container(
            width: 150,
            height: 50,
            decoration: BoxDecoration(
              color: AppColor.whiteColor.withOpacity(
                .85,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    const WidgetSpan(
                        child: Icon(
                      Icons.location_on,
                      color: AppColor.batteryindicatorred,
                    )),
                    TextSpan(
                      text: "North East",
                      style: TextStyle(
                          color: AppColor.greenDarkColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          overflow: TextOverflow.ellipsis),
                    )
                  ],
                ),
                maxLines: 1,
              ),
            ),
          ),
        )
      ]),
      Stack(children: [
        SizedBox(
          width: 258.w,
          height: 145.h,
          child: const Image(
            image: AssetImage(
              "assets/images/image 35.png",
            ),
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          right: 5,
          bottom: 5,
          child: Container(
            width: 150,
            height: 50,
            decoration: BoxDecoration(
              color: AppColor.whiteColor.withOpacity(
                .85,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    const WidgetSpan(
                        child: Icon(
                      Icons.location_on,
                      color: AppColor.batteryindicatorred,
                    )),
                    TextSpan(
                      text: "Indian Temples",
                      style: TextStyle(
                        color: AppColor.greenDarkColor,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ]),
      Stack(children: [
        SizedBox(
          width: 258.w,
          height: 145.h,
          child: const Image(
            image: AssetImage(
              "assets/images/image 36.png",
            ),
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          right: 5,
          bottom: 5,
          child: Container(
            width: 150,
            height: 50,
            decoration: BoxDecoration(
              color: AppColor.whiteColor.withOpacity(
                .85,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    const WidgetSpan(
                        child: Icon(
                      Icons.location_on,
                      color: AppColor.batteryindicatorred,
                    )),
                    TextSpan(
                      text: "Himalayas",
                      style: TextStyle(
                          color: AppColor.greenDarkColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          overflow: TextOverflow.ellipsis),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ]),
      Stack(children: [
        SizedBox(
          width: 258.w,
          height: 145.h,
          child: const Image(
            image: AssetImage(
              "assets/images/image 37.png",
            ),
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          right: 5,
          bottom: 5,
          child: Container(
            width: 150,
            height: 50,
            decoration: BoxDecoration(
              color: AppColor.whiteColor.withOpacity(
                .85,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    const WidgetSpan(
                        child: Icon(
                      Icons.location_on,
                      color: AppColor.batteryindicatorred,
                    )),
                    TextSpan(
                      text: "Kerala",
                      style: TextStyle(
                          color: AppColor.greenDarkColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          overflow: TextOverflow.ellipsis),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ]),
    ];
    return questOptions;
  }

  Widget getQuestDetails(int index) {
    Map<int, String> questName = {
      0: "North East",
      1: "Indian Temples",
      2: "Himalayas",
      3: "Kerala"
    };

    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              child: Text(
            "This week : ${questName[index]}",
            style: TextStyle(
              color: AppColor.greenDarkColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          )),
          Container(
            alignment: Alignment.center,
            height: 50.h,
            child: const CustomWeekDayCircularIndicator(),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Today 25th Aug",
              style: TextStyle(
                color: AppColor.blackColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: double.maxFinite,
              child: ListView.separated(
                itemCount: 7,
                itemBuilder: (BuildContext context, int index) {
                  return const CustomTempleVisitCard();
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 5,
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  final CarouselController _crouselController = CarouselController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: AppColor.blackColor,
        ),
        title: const Text(
          "Step Count",
          style: TextStyle(
            color: AppColor.blackColor,
            fontSize: 16,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 100.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: AppColor.greyLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image(
                          width: 21.w,
                          height: 21.h,
                          image: const AssetImage(
                            "assets/images/trophy.png",
                          ),
                        ),
                        Text(
                          "100",
                          style: TextStyle(
                            color: AppColor.blackColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                ////First Child
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CustomStepCountCircularProgressIndicator(),
                  SizedBox(
                    width: 10.w,
                  ),
                  SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "263",
                            style: TextStyle(
                              fontSize: 40.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              WidgetSpan(
                                child: SizedBox(
                                  width: 5.w,
                                ),
                              ),
                              TextSpan(
                                text: "steps",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "Goal : 800 steps",
                          style: TextStyle(
                            color: AppColor.blackColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: 114.w,
                            height: 30.h,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppColor.black12,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Score Analysis",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ), ////For the Step Score,
              SizedBox(
                height: 30.h,
              ),

              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Choose a Quest for this week",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              SizedBox(
                width: double.maxFinite,
                height: 145.h,
                child: CarouselSlider(
                  carouselController: _crouselController,
                  items: getAllQuests(),
                  options: CarouselOptions(
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        _currentIndex = index;
                        setState(() {});
                      }),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              const SizedBox(
                width: 200,
                child: Divider(
                  color: AppColor.black12,
                  thickness: 5,
                ),
              ),
              Expanded(
                child: getQuestDetails(_currentIndex),
              )
            ],
          ),
        ),
      ),
    );
  }
}
