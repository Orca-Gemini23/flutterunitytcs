import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:walk/env/flavors.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/utils/screen_context.dart';
import 'package:walk/src/views/device/command_page.dart';
import 'package:walk/src/views/org_info/about_us.dart';
import 'package:walk/src/views/org_info/contact_us.dart';
import 'package:walk/src/views/user/account_page.dart';
import 'package:walk/src/views/user/help_section/help.dart';
import 'package:walk/src/views/user/personal_info.dart';

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
          color: AppColor.greenColor,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          height: Screen.height(context: context) * 0.25,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              CircleAvatar(
                backgroundColor: AppColor.greenDarkColor,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Kira Sardeshpande",
                style: TextStyle(
                  color: AppColor.whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
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
    Icons.help,
    Icons.logout_sharp,
  ];
  List<String> drawerTileName = [
    'Home',
    'Account',
    'Device Control',
    'About Us',
    'Contact Us',
    'Need help',
    'Log Out',
  ];
  List<Function()?> drawerOnTap = [
    () {
      //Home
    },
    () {
      Go.to(context: context, push: const AccountPage());
    },
    () {
      if (Provider.of<DeviceController>(context, listen: false)
          .getConnectedDevices
          .isEmpty) {
        Fluttertoast.showToast(msg: 'No devices connected!');
      } else {
        Go.to(context: context, push: const CommandPage());
      }
    },
    () {
      Go.to(context: context, push: const AboutUsPage());
    },
    () {
      Go.to(context: context, push: const ContactUsPage());
    },
    () {
      Go.to(context: context, push: const HelpPage());
    },
    () {
      //LogOut
    },
  ];

  return ListView.builder(
    shrinkWrap: true,
    itemBuilder: (context, index) {
      if (Flavors.prod) {
        return index == 5
            ? const Center()
            : ListTile(
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
