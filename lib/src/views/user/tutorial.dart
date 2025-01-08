import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/utils/global_variables.dart';
import 'package:walk/src/views/revisedhome/newhomepage.dart';
import 'package:walk/src/views/revisedsplash.dart';
import 'package:walk/src/widgets/tutorialcard.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  // final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColor.blackColor,
          size: DeviceSize.isTablet ? 36 : 24,
        ),
        leading: tour
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                ),
                onPressed: (() {
                  Navigator.pop(context);
                }),
              )
            : null,
        title: Text(
          "Tutorial",
          style: TextStyle(
            color: AppColor.blackColor,
            fontSize: DeviceSize.isTablet ? 36 : 20,
          ),
        ),
        centerTitle: !tour ? true : false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: !tour,
      ),
      body: PopScope(
        canPop: tour,
        child: Stack(
          children: [
            SizedBox(
              // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 100),
              height: double.maxFinite,
              width: double.maxFinite,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CarouselSlider(
                      items: List.generate(
                        imageItems.length + 1,
                        (index) => tutorialCard(index),
                      ),
                      options: CarouselOptions(
                          enableInfiniteScroll: tour,
                          autoPlay: false,
                          padEnds: true,
                          enlargeCenterPage: true,
                          height: DeviceSize.isTablet ? 550.h : 450.h,
                          viewportFraction: .9,
                          reverse: false,
                          onPageChanged: (index, reason) {
                            log(index.toString());
                            setState(() {
                              _current = index;
                            });
                          }),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        imageItems.length + 1,
                        (index) => GestureDetector(
                          // onTap: () => _controller.animateToPage(index),
                          child: Container(
                            width: 12.0,
                            height: 12.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : AppColor.greenDarkColor)
                                  .withOpacity(
                                _current == index ? 0.9 : 0.4,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: (_current == imageItems.length) && !tour,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 48),
                  child: TextButton(
                    onPressed: () {
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RevisedHomePage(),
                            settings: const RouteSettings(name: '/home'),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    child: const Text(
                      "Next",
                      style: TextStyle(color: AppColor.greenDarkColor),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
