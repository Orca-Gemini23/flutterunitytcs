import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:walk/env/flavors.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/controllers/shared_preferences.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/models/user_model.dart';
import 'package:walk/src/pages/HomePage.dart';
import 'package:walk/src/pages/SplashScreen.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/utils/firebasehelper.dart/firebasedb.dart';
import 'package:walk/src/utils/global_variables.dart';
import 'package:walk/src/utils/screen_context.dart';
import 'package:walk/src/views/dialogs/confirmationbox.dart';
import 'package:walk/src/widgets/homepage/usernametext.dart';

Drawer navigationDrawer(BuildContext context) {
  return Drawer(
    key: keyMenu,
    // backgroundColor: Color(DRAWERCOLOR),
    width: DeviceSize.isTablet
        ? MediaQuery.of(context).size.width * 0.6
        : MediaQuery.of(context).size.width * 0.8,
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
          padding: EdgeInsets.symmetric(
              vertical: 10, horizontal: DeviceSize.isTablet ? 60 : 30),
          height: Screen.height(context: context) * 0.25,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 25),
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
                                .name ==
                            "Unknown User"
                        ? ""
                        : userBox
                            .get(
                              0,
                              defaultValue: LocalDB.defaultUser,
                            )!
                            .name,
                    style: TextStyle(
                      color: AppColor.blackColor,
                      fontSize: DeviceSize.isTablet ? 20.h : 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(child: drawerItem(context)),
      ],
    ),
  );
}

Widget drawerItem(BuildContext context) {
  List<IconData> drawerIcon = [
    Icons.home,
    Icons.person,
    Icons.tune,
    Icons.my_library_books_outlined,
    Icons.group,
    Icons.email,
    // Icons.qr_code,
    Icons.help,
    Icons.question_answer,
    // Icons.money_rounded,
    Icons.info_outline,
    Icons.logout_sharp,
    // Icons.autorenew,
  ];
  List<String> drawerTileName = [
    'Home',
    'Account',
    'Device Control',
    'Report',
    'About Us',
    'Contact Us',
    // 'QR-Scanner',
    'Tutorial',
    "FAQ's",
    // "Subscription",
    "App Version - v${VersionNumber.versionNumber}",
    'Log Out',
  ];
  List<Function()?> drawerOnTap = [
    () {
      //Home
      Analytics.addClicks("Drawer/HomeButton", DateTime.timestamp());
      Go.back(context: context);
    },
    () {
      Analytics.addClicks("Drawer/AccountButton", DateTime.timestamp());
      Navigator.pushNamed(
        context,
        '/accountpage',
      );
    },
    () {
      Analytics.addClicks("Drawer/DeviceControlButton", DateTime.timestamp());
      if (Provider.of<DeviceController>(context, listen: false)
              .connectedDevice ==
          null) {
        Navigator.pushNamed(
          context,
          '/connectionscreen',
        );
      } else {
        Navigator.pushNamed(
          context,
          '/devicecontrol',
        );
      }
    },
    () {
      Analytics.addClicks("Drawer/ReportButton", DateTime.timestamp());
      Navigator.pushNamed(
        context,
        '/reports',
      );
    },
    () {
      Analytics.addClicks("Drawer/AboutUsButton", DateTime.timestamp());
      Navigator.pushNamed(
        context,
        '/aboutus',
      );
    },
    () {
      Analytics.addClicks("Drawer/ContactUsButton", DateTime.timestamp());
      Navigator.pushNamed(
        context,
        '/contactus',
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
      Analytics.addClicks("Drawer/TutorialButton", DateTime.timestamp());
      Navigator.pushNamed(
        context,
        '/tutorial',
      );
    },
    () {
      Analytics.addClicks("Drawer/FaqButton", DateTime.timestamp());
      Navigator.pushNamed(
        context,
        '/faq',
      );
    },
    // () {
    //   Navigator.pushNamed(
    //     context,
    //     '/subscription',
    //   );
    // },
    null,
    () {
      Analytics.addClicks("Drawer/SignoutButton", DateTime.timestamp());
      showDialog(
        context: context,
        builder: (context) => ConfirmationBox(
            title: 'Logout',
            content: 'Are you sure you want to Logout?',
            btnText: 'Logout',
            onConfirm: () async {
              Navigator.of(context).pop();
              await FirebaseAuth.instance.signOut();
              await LocalDB.saveUser(LocalDB.defaultUser);
              await PreferenceController.clearAllData();
              CollectAnalytics.start = false;
              if (context.mounted) {
                Go.pushAndRemoveUntil(
                    context: context, pushReplacement: const SplashScreen());
              }
            }),
      );
    },
  ];

  return ListView.builder(
    shrinkWrap: true,
    // physics:
    //     const BouncingScrollPhysics(parent: NeverScrollableScrollPhysics()),
    itemBuilder: (context, index) {
      if (Flavors.prod) {
        return Column(
          children: [
            ListTile(
              leading: Padding(
                padding: DeviceSize.isTablet
                    ? const EdgeInsets.only(right: 40, left: 10)
                    : const EdgeInsets.all(0),
                child: Icon(
                  drawerIcon[index],
                  color: AppColor.blackColor,
                  size: DeviceSize.isTablet ? 40 : 26,
                ),
              ),
              title: Text(
                drawerTileName[index],
                style: TextStyle(
                  color: AppColor.blackColor,
                  fontSize: DeviceSize.isTablet ? 32 : 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              onTap: drawerOnTap[index],
            ),
            if (DeviceSize.isTablet) const SizedBox(height: 25)
          ],
        );
      } else {
        return ListTile(
          leading: Padding(
            padding: DeviceSize.isTablet
                ? const EdgeInsets.only(right: 40, left: 10)
                : const EdgeInsets.all(0),
            child: Icon(
              drawerIcon[index],
              color: AppColor.blackColor,
              size: DeviceSize.isTablet ? 40 : 26,
            ),
          ),
          title: Text(
            drawerTileName[index],
            style: TextStyle(
              color: AppColor.blackColor,
              fontSize: DeviceSize.isTablet ? 32 : 16,
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
