import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/widgets/tutorialcard.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColor.blackColor,
        ),
        title: const Text(
          "Tutorial",
          style: TextStyle(
            color: AppColor.blackColor,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SizedBox(
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
                    autoPlay: false,
                    padEnds: true,
                    enlargeCenterPage: true,
                    height: 450.h,
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
                    onTap: () => _controller.animateToPage(index),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
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
    );
  }
}
