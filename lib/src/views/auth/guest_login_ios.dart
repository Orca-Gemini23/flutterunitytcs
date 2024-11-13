import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/utils/global_variables.dart';
import 'package:walk/src/views/auth/phone_auth.dart';
import 'package:walk/src/views/user/newrevisedaccountpage.dart';

class GuestUserLogin extends StatefulWidget {
  const GuestUserLogin({super.key});

  @override
  State<GuestUserLogin> createState() => _GuestUserLoginState();
}

class _GuestUserLoginState extends State<GuestUserLogin> {
  final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    disabledBackgroundColor: Colors.grey,
    backgroundColor: const Color.fromRGBO(0, 87, 73, 1),
    minimumSize: const Size(double.maxFinite, 60),
    padding: const EdgeInsets.symmetric(horizontal: 16),
  );

  final ButtonStyle outlineButtonStyle = ElevatedButton.styleFrom(
    minimumSize: const Size(double.maxFinite, 60),
    padding: const EdgeInsets.symmetric(horizontal: 16),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 87, 73, 1),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              color: AppColor.greenDarkColor,
              height: 120,
              width: 120,
              child: const Center(
                child: Text(
                  AppString.org,
                  style: TextStyle(
                      fontSize: 80,
                      fontFamily: "Helvetica",
                      color: AppColor.whiteColor,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const Spacer(),
            // const SizedBox(height: 80),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFFFFF),
                        minimumSize: const Size(double.maxFinite, 60),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                      onPressed: () {
                        Go.to(context: context, push: const PhoneAuthPage());
                      },
                      child: const Text(
                        "CONTINUE WITH PHONE NUMBER",
                        style: TextStyle(color: Color(0xFF005749)),
                      )),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        minimumSize: const Size(double.maxFinite, 30),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          debugPrint("Signed in with temporary account.");
                          setState(() {
                            UserDetails.unavailable = true;
                          });
                          await FirebaseAuth.instance.signInAnonymously();
                          if (context.mounted) {
                            Go.to(
                            context: context,
                            push: const NewRevisedAccountPage(),
                          );
                          }
                        } on FirebaseAuthException catch (e) {
                          if (kDebugMode) {
                            print(e);
                          }
                        }
                      },
                      child: const Text(
                        "CONTINUE AS GUEST",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
