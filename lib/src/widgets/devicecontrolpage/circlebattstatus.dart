import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

Widget circularProgressIndicator(
    double percentage, String direction, int batteryRemaining) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(
        child: Text(
          "Batt left $batteryRemaining mins",
          style: const TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 12,
              letterSpacing: 3,
              fontWeight: FontWeight.bold,
              color: Color(0xff9C9C9C)),

        
        ),
      ),
      SleekCircularSlider(
        initialValue: percentage,
        appearance: CircularSliderAppearance(
          animDurationMultiplier: 4,
          customWidths: CustomSliderWidths(
              handlerSize: 4,
              progressBarWidth: 16,
              shadowWidth: 18,
              trackWidth: 16),
          customColors: CustomSliderColors(
            dotColor: Colors.transparent,
            progressBarColor: percentage > 20 ? Colors.green : Colors.red,
            trackColor: const Color(0xffEDEDED),
          ),
          infoProperties: InfoProperties(
            bottomLabelText: direction,
            bottomLabelStyle: const TextStyle(
              color: Colors.black38,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    ],
  );
}
