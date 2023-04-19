import 'package:flutter/material.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/utils/screen_context.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static final Map<String, String> _profile = {
    'Name': 'Kira',
    'Phone': '+91 9876543216',
    'Gender': 'Male',
    'City': 'Mumbai',
    'Device': 'WALK'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppString.profileTitle,
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
            Go.back(context: context);
          }),
        ),
        centerTitle: false,
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
            (index) {
              return Container(
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                padding: const EdgeInsets.all(10),
                height: Screen.height(context: context) * 0.1,
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(16.0),
                  // border: const Border(
                  //   bottom: BorderSide(color: AppColor.black12),
                  // ),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColor.greyLight,
                      offset: Offset(2, 2),
                      blurRadius: 2.0,
                    ),
                    BoxShadow(
                      color: AppColor.whiteColor,
                      offset: Offset(-2, -2),
                      blurRadius: 2.0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _profile.keys.elementAt(index),
                      style: const TextStyle(
                        color: AppColor.blackColor,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _profile.values.elementAt(index),
                      style: const TextStyle(
                        color: AppColor.blackColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
