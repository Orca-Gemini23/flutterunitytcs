import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/utils/firebase/firebase_db.dart';
import 'package:walk/src/utils/global_variables.dart';

class TodaysGoalBox extends StatefulWidget {
  const TodaysGoalBox({
    super.key,
    required this.goalBoxKey,
  });

  final GlobalKey goalBoxKey;

  @override
  State<TodaysGoalBox> createState() => _TodaysGoalBoxState();
}

class _TodaysGoalBoxState extends State<TodaysGoalBox> {
  Future<bool> hasCompletedToday() async {
    final today = DateTime.now();
    final value = await FirebaseDB.currentDb
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.phoneNumber)
        .get();
    final gameHistoryData =
        (value.data() as Map<String, dynamic>)["game_history"] as List<dynamic>;
    return gameHistoryData.any((entry) =>
        entry.date.year == today.year &&
        entry.date.month == today.month &&
        entry.date.day == today.day);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: widget.goalBoxKey,
      onTap: () {
        // Go.to(
        //   context: context,
        //   push: const StepGoalPage(),
        // );
      },
      child: Container(
        margin: const EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 20,
        ),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: AppColor.lightbluegrey,
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
                height: 105.h,
                image: const AssetImage(
                  "assets/images/re1.png",
                ),
              ),
            ),
            Positioned(
              right: DeviceSize.isTablet ? 125 : 25,
              top: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Goal",
                    style: TextStyle(
                      color: AppColor.primary,
                      fontFamily: 'Helvetica',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  FutureBuilder<bool>(
                    future: hasCompletedToday(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData && snapshot.data == true) {
                        return Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Completed',
                                style: TextStyle(
                                  color: AppColor.primary,
                                  fontFamily: 'Helvetica',
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const WidgetSpan(
                                child: SizedBox(
                                  width: 5,
                                ),
                              ),
                              WidgetSpan(
                                child: Icon(
                                  Icons.done,
                                  color: AppColor.amberColor,
                                  size: 20.sp,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Not Completed',
                                style: TextStyle(
                                  color: AppColor.primary,
                                  fontFamily: 'Helvetica',
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const WidgetSpan(
                                child: SizedBox(
                                  width: 5,
                                ),
                              ),
                              WidgetSpan(
                                child: Icon(
                                  Icons.pending_actions_sharp,
                                  color: AppColor.amberColor,
                                  size: 20.sp,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
