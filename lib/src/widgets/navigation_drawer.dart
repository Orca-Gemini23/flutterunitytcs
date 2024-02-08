// ignore_for_file: unused_import
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:walk/env/flavors.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/models/user_model.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/utils/screen_context.dart';
import 'package:walk/src/views/device/command_page.dart';
import 'package:walk/src/views/faqscreens/faqpage.dart';
import 'package:walk/src/views/org_info/about_us.dart';
import 'package:walk/src/views/org_info/contact_us.dart';
import 'package:walk/src/views/reviseddevicecontrol/newdevicecontrol.dart';
import 'package:walk/src/views/user/account_page.dart';
import 'package:walk/src/views/user/help_section/help.dart';
import 'package:walk/src/views/user/personal_info.dart';
import 'package:walk/src/views/user/revisedaccountpage.dart';
import 'package:walk/src/views/user/tutorial.dart';
import 'package:walk/src/widgets/homepage/usernametext.dart';

Drawer navigationDrawer(BuildContext context) {
  return Drawer(
    // backgroundColor: Color(DRAWERCOLOR),
    semanticLabel: "drawer",
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
    elevation: 30,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: AppColor.lightgreen,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          height: Screen.height(context: context) * 0.25,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const UserNameImage(),
              const SizedBox(
                height: 20,
              ),
              ValueListenableBuilder<Box<UserModel>>(
                valueListenable: LocalDB.listenableUser(),
                builder: (contex, userBox, child) {
                  return Text(
                    userBox
                        .get(
                          0,
                          defaultValue: LocalDB.defaultUser,
                        )!
                        .name,
                    style: TextStyle(
                      color: AppColor.blackColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        drawerItem(context),
      ],
    ),
  );
}

Widget drawerItem(BuildContext context) {
  List<IconData> drawerIcon = [
    Icons.home,
    Icons.person,
    Icons.tune,
    Icons.group,
    Icons.email,
    // Icons.qr_code,
    Icons.help,
    Icons.question_answer,
    // Icons.logout_sharp,
  ];
  List<String> drawerTileName = [
    'Home',
    'Account',
    'Device Control',
    'About Us',
    'Contact Us',
    // 'QR-Scanner',
    'Tutorial',
    "FAQ's",
    // 'Log Out',
  ];
  List<Function()?> drawerOnTap = [
    () {
      //Home
      Go.back(context: context);
    },
    () {
      Go.to(
        context: context,
        push: const Revisedaccountpage(),
      );
    },
    () {
      if (Provider.of<DeviceController>(context, listen: false)
              .connectedDevice ==
          null) {
        Fluttertoast.showToast(msg: 'No device connected!');
      } else {
        // Go.to(
        //   context: context,
        //   push: DeviceControlPage(),
        // );
      }
    },
    () {
      Go.to(
        context: context,
        push: const AboutUsPage(),
      );
    },
    () {
      Go.to(
        context: context,
        push: const ContactUsPage(),
      );
    },
    // () {
    // Go.to(
    //   context: context,
    //   push: const QrScanner(),
    // );
    //Goto qr scanner page
    // },
    () {
      Go.to(
        context: context,
        push: const TutorialPage(),
      );
    },
    () {
      Go.to(
        context: context,
        push: const Faqpage(),
      );
    },
    // () {
    //   //LogOut
    // },
  ];

  return ListView.builder(
    shrinkWrap: true,
    physics:
        const BouncingScrollPhysics(parent: NeverScrollableScrollPhysics()),
    itemBuilder: (context, index) {
      if (Flavors.prod) {
        return index == 9
            ? const Center()
            : ListTile(
                leading: Icon(
                  drawerIcon[index],
                  color: AppColor.blackColor,
                  size: 26,
                ),
                title: Text(
                  drawerTileName[index],
                  style: const TextStyle(
                    color: AppColor.blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                onTap: drawerOnTap[index],
              );
      } else {
        return ListTile(
          leading: Icon(drawerIcon[index]),
          title: Text(
            drawerTileName[index],
            style: const TextStyle(
              color: AppColor.blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
          onTap: drawerOnTap[index],
        );
      }
    },
    itemCount: drawerTileName.length,
  );
}
