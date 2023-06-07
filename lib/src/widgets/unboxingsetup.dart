import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:walk/src/constants/app_assets.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/controllers/shared_preferences.dart';

class UnboxingSetupDialog extends StatelessWidget {
  UnboxingSetupDialog({
    super.key,
  });

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              AppColor.greenColor,
              AppColor.greenDarkColor,
            ],
          ),
          borderRadius: BorderRadius.circular(20)),
      height: 400,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: PageView(
        controller: pageController,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        pageSnapping: true,
        padEnds: true,
        onPageChanged: (value) {
          pageController.initialPage == 4 ? pageController.dispose() : null;
        },
        children: [
          Container(
            ///First Container (Taking out the bands from the box )
            padding: const EdgeInsets.all(8),
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                const Positioned(
                  child: Text(
                    AppString.takeOutBands,
                    style: TextStyle(
                      color: AppColor.whiteColor,
                      fontSize: 20,
                    ),
                  ),
                ),
                Center(
                  child: Image.asset(
                    AppAssets.productImage,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 0,
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.purpleColor,
                    ),
                    onPressed: () {
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 10),
                          curve: Curves.easeIn);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(
                          Icons.next_plan,
                          color: AppColor.greenColor,
                        ),
                        Spacer(),
                        Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            ///Second Container (Locate the red switch)
            padding: const EdgeInsets.all(8),
            width: double.maxFinite,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Stack(
              children: [
                const Positioned(
                  child: Text(
                    AppString.turnOnSwitch,
                    style: TextStyle(
                      color: AppColor.whiteColor,
                      fontSize: 20,
                    ),
                  ),
                ),
                Center(
                  child: Image.asset(
                    AppAssets.productImage,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 0,
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.purpleColor,
                    ),
                    onPressed: () {
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 10),
                          curve: Curves.easeIn);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(
                          Icons.next_plan,
                          color: AppColor.greenColor,
                        ),
                        Spacer(),
                        Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.purpleColor,
                    ),
                    onPressed: () {
                      pageController.previousPage(
                          duration: const Duration(milliseconds: 10),
                          curve: Curves.easeIn);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(
                          Icons.arrow_back,
                          color: AppColor.greenColor,
                        ),
                        Spacer(),
                        Text(
                          "Back",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            //Third Container
            padding: const EdgeInsets.all(8),
            width: double.maxFinite,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Stack(
              children: [
                const Positioned(
                  child: Text(
                    "Please take out the bands from the box , and put them on a table.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                Center(
                  child: Image.asset(
                    "assets/images/product.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 0,
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.purpleColor,
                    ),
                    onPressed: () {
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 10),
                          curve: Curves.easeIn);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(
                          Icons.next_plan,
                          color: AppColor.greenColor,
                        ),
                        Spacer(),
                        Text(
                          "Done",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.purpleColor,
                    ),
                    onPressed: () {
                      pageController.previousPage(
                          duration: const Duration(milliseconds: 10),
                          curve: Curves.easeIn);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(
                          Icons.arrow_back,
                          color: AppColor.greenColor,
                        ),
                        Spacer(),
                        Text(
                          "Back",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            //Fourth Container
            padding: const EdgeInsets.all(8),
            width: double.maxFinite,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Stack(
              children: [
                const Positioned(
                  child: Text(
                    "Please take out the bands from the box , and put them on a table.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                Center(
                  child: Image.asset(
                    "assets/images/product.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 0,
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.purpleColor,
                    ),
                    onPressed: () {
                      PreferenceController.saveboolData("isUnboxingDone", true);
                      Navigator.of(context, rootNavigator: true).pop("done");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(
                          Icons.next_plan,
                          color: AppColor.greenColor,
                        ),
                        Spacer(),
                        Text(
                          "Done",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.purpleColor,
                    ),
                    onPressed: () {
                      pageController.previousPage(
                          duration: const Duration(milliseconds: 10),
                          curve: Curves.easeIn);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(
                          Icons.arrow_back,
                          color: AppColor.greenColor,
                        ),
                        Spacer(),
                        Text(
                          "Back",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
