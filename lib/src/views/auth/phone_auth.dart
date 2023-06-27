import 'package:flutter/material.dart';
import 'package:walk/src/constants/app_assets.dart';
import 'package:walk/src/constants/app_strings.dart';

import 'package:walk/src/utils/screen_context.dart';

import 'package:walk/src/widgets/textfields.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: -140,
              left: -140,
              child: Image.asset(AppAssets.backgroundImage),
            ),
            Container(
              height: Screen.height(context: context),
              width: Screen.width(context: context),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: Screen.height(context: context) * 0.45,
                    ),
                    const Text(
                      AppString.enterNumber,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: Screen.height(context: context) * 0.05,
                    ),
                    getTextfield(
                        "Enter Number", _phoneController, Icons.phone_android),
                    SizedBox(
                      height: Screen.height(context: context) * 0.1,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //add checks and submit details
                        //Go.to(context: context, push: const OTPPage());
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                        fixedSize: const Size(200, 50),
                        backgroundColor: const Color(0xff005749),
                        elevation: 7,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        AppString.sendOtp,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
