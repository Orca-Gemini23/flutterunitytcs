import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/views/therapyentrypage/therapypage.dart';
import 'package:walk/src/views/user/newrevisedaccountpage.dart';

class TherapySessionBtn extends StatefulWidget {
  const TherapySessionBtn({super.key, required this.pKey});

  final GlobalKey pKey;

  @override
  State<TherapySessionBtn> createState() => _TherapySessionBtnState();
}

class _TherapySessionBtnState extends State<TherapySessionBtn> {
  bool _isTherapyButtonTapped = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceController>(
      key: widget.pKey,
      builder: (context, deviceController, widget) {
        return InkWell(
          highlightColor: Colors.transparent,
          splashColor: AppColor.greenDarkColor,
          onHighlightChanged: (value) {
            deviceController.connectedDevice == null
                ? null
                : setState(() {
                    _isTherapyButtonTapped = value;
                  });
          },
          onTap: () async {
            therapyButtonOnPressed(deviceController);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastLinearToSlowEaseIn,
            height: _isTherapyButtonTapped ? 145.h : 150.h,
            width: _isTherapyButtonTapped ? 147.w : 154.w,
            child: Container(
              height: 150.h,
              width: 154.w,
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                      color: AppColor.appShadowDark,
                      offset: Offset(0, 4),
                      blurRadius: 4,
                      spreadRadius: 2)
                ],
                color: AppColor.greenDarkColor,
                // deviceController.connectedDevice == null
                //     ? AppColor.greyLight
                //     : AppColor.lightgreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 92.w,
                    height: 92.h,
                    child: Image.asset(
                      "assets/images/therapysession.png",
                      scale: 3,
                      // fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    "Therapy games",
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      fontFamily: 'Helvetica',
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool checkAccountEligible() {
    String phoneNumber = LocalDB.listenableUser()
        .value
        .get(0, defaultValue: LocalDB.defaultUser)!
        .phone;

    if (!RegExp(
            r"^(\+\d{1,2}\s?)?1?\-?\.?\s?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$")
        .hasMatch(phoneNumber)) {
      ////Dont allow user to use the therapy page
      return false;
    }
    return true;
  }

  void therapyButtonOnPressed(DeviceController deviceController) async {
    print("coming here");
    if (deviceController.connectedDevice == null) {
      Fluttertoast.showToast(
        msg: "Please Connect to the device first",
      );
    } else {
      bool accountEligible = checkAccountEligible();

      if (accountEligible) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => const TherapyEntryPage()),
          ),
        );
      } else {
        Fluttertoast.showToast(msg: "Please update the account details first");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NewRevisedAccountPage(),
          ),
        );
      }
    }
  }
}
