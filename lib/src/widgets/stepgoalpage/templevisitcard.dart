import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walk/src/constants/app_color.dart';

class CustomTempleVisitCard extends StatefulWidget {
  const CustomTempleVisitCard({super.key});

  @override
  State<CustomTempleVisitCard> createState() => _CustomTempleVisitCardState();
}

class _CustomTempleVisitCardState extends State<CustomTempleVisitCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.h,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
      decoration: BoxDecoration(
        color: AppColor.lightgreen,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 83,
            height: 83,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/map.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Visit Temple A',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Goal: 800 steps',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              children: List.generate(
                3,
                (index) => Image(
                  width: 22.w,
                  height: 22.h,
                  image: const AssetImage(
                    "assets/images/trophy.png",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
