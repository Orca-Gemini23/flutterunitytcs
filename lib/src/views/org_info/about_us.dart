import 'package:flutter/material.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppString.aboutUsTitle,
          style: TextStyle(
            color: AppColor.greenDarkColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColor.blackColor,
          ),
          onPressed: (() {
            Navigator.pop(context);
          }),
        ),
        centerTitle: false,
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
      ),
      body: ListView(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  AppString.org,
                  style: TextStyle(
                    fontSize: 36,
                    letterSpacing: 8,
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
                const Text(
                  "Lifespark\nTechnologies",
                  style: TextStyle(
                      color: AppColor.greenDarkColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(20.0, 10, 10, 10),
            height: 60,
            color: AppColor.greenDarkColor,
            child: const Text(
              AppString.yours,
              style: TextStyle(
                  color: AppColor.whiteColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w300),
            ),
          ),
          const SizedBox(height: 30),
          const Align(
            alignment: Alignment.center,
            child: Text(
              AppString.companyDetails,
              style: TextStyle(
                color: AppColor.blackColor,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
